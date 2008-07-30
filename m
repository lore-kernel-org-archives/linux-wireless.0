Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:33585 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759708AbYG3RNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 13:13:45 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC/RFT] rtl8187: Protect the config callback from mac80211 with a mutex
Date: Wed, 30 Jul 2008 14:13:52 -0300
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <48900654.7030100@lwfinger.net> <200807301308.01631.herton@mandriva.com.br> <200807301816.37570.mb@bu3sch.de>
In-Reply-To: <200807301816.37570.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807301413.53059.herton@mandriva.com.br> (sfid-20080730_191401_597529_19E28A18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Wednesday 30 July 2008 13:16:37 Michael Buesch escreveu:
> On Wednesday 30 July 2008 18:08:01 Herton Ronaldo Krzesinski wrote:
> > Em Wednesday 30 July 2008 12:02:30 Michael Buesch escreveu:
> > > On Wednesday 30 July 2008 16:53:13 Herton Ronaldo Krzesinski wrote:
> > > > Em Wednesday 30 July 2008 10:27:26 Michael Buesch escreveu:
> > > > > On Wednesday 30 July 2008 15:24:40 Michael Buesch wrote:
> >
> > <snip>
> >
> > > > > and the mutex name, of course.
> > > > >
> > > > > 	/* Mutex to protect the device configuration data,
> > > > > 	 * which is foobar and bizzbaz */
> > > > > 	struct mutex conf_mutex;
> > > >
> > > > Yes, it's better this way. About the lock, the problem here is you
> > > > can't set the channel while transmitting data on 8187 (the card stops
> > > > working util reset like the comment on the code), so we must enable
> > > > tx loopback while setting channels, but you can't run rtl8187_config
> > > > concurrently because one instance may be disabling tx loopback while
> > > > other is still setting channel, or like the code is today there is a
> > > > possibility that you set tx loopback forever. The lock could be only
> > > > in that section.
> > > >
> > > > The comment could be:
> > > > /* Mutex to protect the device configuration data,
> > > >  * we can't set channels concurrently */
> > >
> > > I think you probably want to protect the tx-loopback (enabled or
> > > disabled) state. That's what you're actually doing implicitely. The
> > > problem is not any channel concurrency or something like that, but that
> > > the
> > > tx-loopback-enable/disable is not recursive is the real thing we want
> > > to lock here, probably.
> >
> > No, the issue is that I must enter in tx-loopback mode to set the
> > channels inside rtl8187_config, to avoid transmission of packets, so the
> > hardware doesn't halt. So that's why the lock, it must cover the entire
> > section of "enable loopback"->"set_chan"->"disable loopback", not only
> > the state of TX_CONF register.
>
> Yeah, I said exactly that.
> You protect the loopback stuff. Not any config callback or anything else.

Ah ok, only protect the section, like this?

diff --git a/drivers/net/wireless/rtl8187.h b/drivers/net/wireless/rtl8187.h
index 3afb49f..a4e42dc 100644
--- a/drivers/net/wireless/rtl8187.h
+++ b/drivers/net/wireless/rtl8187.h
@@ -92,6 +92,10 @@ struct rtl8187_priv {
 	const struct rtl818x_rf_ops *rf;
 	struct ieee80211_vif *vif;
 	int mode;
+	/* The mutex protects the TX loopback state.
+	 * Avoid concurrent channel changes with loopback enabled.
+	 */
+	struct mutex loopback_mutex;
 
 	/* rtl8187 specific */
 	struct ieee80211_channel channels[14];
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index d3067b1..cfa048b 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -835,6 +835,7 @@ static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 	struct rtl8187_priv *priv = dev->priv;
 	u32 reg;
 
+	mutex_lock(&priv->loopback_mutex);
 	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
 	/* Enable TX loopback on MAC level to avoid TX during channel
 	 * changes, as this has be seen to causes problems and the
@@ -846,6 +847,7 @@ static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 	priv->rf->set_chan(dev, conf);
 	msleep(10);
 	rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
+	mutex_unlock(&priv->loopback_mutex);
 
 	if (!priv->is_rtl8187b) {
 		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
@@ -1154,6 +1156,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 		printk(KERN_ERR "rtl8187: Cannot register device\n");
 		goto err_free_dev;
 	}
+	mutex_init(&priv->loopback_mutex);
 
 	printk(KERN_INFO "%s: hwaddr %s, %s V%d + %s\n",
 	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),


-- 
[]'s
Herton
