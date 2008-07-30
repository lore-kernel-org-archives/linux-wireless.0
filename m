Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:52528 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYG3OxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 10:53:06 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC/RFT] rtl8187: Protect the config callback from mac80211 with a mutex
Date: Wed, 30 Jul 2008 11:53:13 -0300
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <48900654.7030100@lwfinger.net> <200807301524.40411.mb@bu3sch.de> <200807301527.26432.mb@bu3sch.de>
In-Reply-To: <200807301527.26432.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807301153.13947.herton@mandriva.com.br> (sfid-20080730_165312_074576_34D78764)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Wednesday 30 July 2008 10:27:26 Michael Buesch escreveu:
> On Wednesday 30 July 2008 15:24:40 Michael Buesch wrote:
> > On Wednesday 30 July 2008 08:12:36 Larry Finger wrote:
> > > Herton,
> > >
> > > Does this patch help your problem? I haven't done much testing, but
> > > things seem to be better with it here.
> > >
> > > Larry
> > >
> > > ==================
> > >
> > > Some users of the RTL8187B have experienced difficulties since commit
> > > 8f87dd7e540d455f8e7f11478133b85edc969c67 that introduced the power
> > > management wext hooks. This difficulty has not made much sense until
> > > it was realized that it was possible for mac80211 to make a call to the
> > > config routine while that routine was already being executed. This
> > > patch protects the critical section with a mutex.
> > >
> > > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > > ---
> > >
> > > Index: wireless-testing/drivers/net/wireless/rtl8187.h
> > > ===================================================================
> > > --- wireless-testing.orig/drivers/net/wireless/rtl8187.h
> > > +++ wireless-testing/drivers/net/wireless/rtl8187.h
> > > @@ -94,6 +94,7 @@ struct rtl8187_priv {
> > >   	const struct rtl818x_rf_ops *rf;
> > >   	struct ieee80211_vif *vif;
> > >   	int mode;
> > > +	struct mutex mutex;	/* used to lock config callback */
> >
> > Well, hm.
> > Using locks to protect code is a bad idea, most of the time.
> > So that comment makes no sense.
> >
> > What that lock _probably_ does it to protect the configuration
> > data in struct rtl8187_priv. So you'd better find out which data
> > that is and clarify the comment.
>
> and the mutex name, of course.
>
> 	/* Mutex to protect the device configuration data,
> 	 * which is foobar and bizzbaz */
> 	struct mutex conf_mutex;

Yes, it's better this way. About the lock, the problem here is you can't set 
the channel while transmitting data on 8187 (the card stops working util 
reset like the comment on the code), so we must enable tx loopback while 
setting channels, but you can't run rtl8187_config concurrently because one 
instance may be disabling tx loopback while other is still setting channel, 
or like the code is today there is a possibility that you set tx loopback 
forever. The lock could be only in that section.

The comment could be:
/* Mutex to protect the device configuration data,
 * we can't set channels concurrently */

--
[]'s
Herton
