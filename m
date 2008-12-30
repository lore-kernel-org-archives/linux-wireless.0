Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23108.mail.ird.yahoo.com ([217.146.189.48]:33947 "HELO
	web23108.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751448AbYL3SGv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 13:06:51 -0500
Date: Tue, 30 Dec 2008 18:05:16 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <495A5FEC.5070608@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <226846.55836.qm@web23108.mail.ird.yahoo.com> (sfid-20081230_190654_648855_E6AF8D38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 30/12/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> From: Larry Finger <Larry.Finger@lwfinger.net>
> Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
> To: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>
> Cc: "Alan Stern" <stern@rowland.harvard.edu>, "Bob Copeland" <me@bobcopeland.com>, linux-wireless@vger.kernel.org, linux-pm@lists.linux-foundation.org, "USB list" <linux-usb@vger.kernel.org>, "Hin-Tak Leung" <htl10@users.sourceforge.net>, "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>
> Date: Tuesday, 30 December, 2008, 5:52 PM
> Alan Jenkins wrote:
> > That won't fix hibernation though.  The disconnect
> method can still get
> > called in resume from hibernation, before the
> workqueue gets unfrozen. 
> > To be honest, I'm far more interested in
> suspend-to-disk than
> > suspend-to-ram.
> 
> Does this patch fix your problem? It works here, but I only
> did one
> test. The patch is for wireless-testing.

BTW, there is already a bug on kernel bugzilla on this - maybe useful to
attach the patch to get the three people to test:
http://bugzilla.kernel.org/show_bug.cgi?id=11887

In fact I'll do this when I get back in a couple of hours. (am going
out soon...). I'll give this a try myself. 

> 
> Larry
> 
> 
> Index:
> wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> ===================================================================
> ---
> wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++
> wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -1464,6 +1464,32 @@ static int __devinit
> rtl8187_probe(struc
>  	return err;
>  }
> 
> +#ifdef CONFIG_PM
> +
> +static int rtl8187_suspend(struct usb_interface *intf,
> pm_message_t
> state)
> +{
> +	struct ieee80211_hw *dev = usb_get_intfdata(intf);
> +	struct rtl8187_priv *priv;
> +        int time;
> +
> +	if (!dev)
> +		return 0;
> +
> +	priv = dev->priv;
> +
> +	time =
> usb_wait_anchor_empty_timeout(&priv->anchored, 1000);
> +	if (!time)
> +		usb_kill_anchored_urbs(&priv->anchored);
> +	return 0;
> +}
> +
> +static int rtl8187_resume(struct usb_interface *intf)
> +{
> +	return 0;
> +}
> +
> +#endif /* CONFIG_PM */
> +
>  static void __devexit rtl8187_disconnect(struct
> usb_interface *intf)
>  {
>  	struct ieee80211_hw *dev = usb_get_intfdata(intf);
> @@ -1484,6 +1510,10 @@ static struct usb_driver
> rtl8187_driver
>  	.id_table	= rtl8187_table,
>  	.probe		= rtl8187_probe,
>  	.disconnect	= __devexit_p(rtl8187_disconnect),
> +#ifdef CONFIG_PM
> +	.suspend	= rtl8187_suspend,
> +	.resume		= rtl8187_resume,
> +#endif /* CONFIG_PM */
>  };
> 
>  static int __init rtl8187_init(void)


      
