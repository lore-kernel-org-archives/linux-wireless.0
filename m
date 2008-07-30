Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56802 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbYG3N1y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 09:27:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] rtl8187: Protect the config callback from mac80211 with a mutex
Date: Wed, 30 Jul 2008 15:27:26 +0200
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <48900654.7030100@lwfinger.net> <200807301524.40411.mb@bu3sch.de>
In-Reply-To: <200807301524.40411.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807301527.26432.mb@bu3sch.de> (sfid-20080730_152757_774951_930A5D6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 July 2008 15:24:40 Michael Buesch wrote:
> On Wednesday 30 July 2008 08:12:36 Larry Finger wrote:
> > Herton,
> > 
> > Does this patch help your problem? I haven't done much testing, but things seem 
> > to be better with it here.
> > 
> > Larry
> > 
> > ==================
> > 
> > Some users of the RTL8187B have experienced difficulties since commit
> > 8f87dd7e540d455f8e7f11478133b85edc969c67 that introduced the power
> > management wext hooks. This difficulty has not made much sense until
> > it was realized that it was possible for mac80211 to make a call to the
> > config routine while that routine was already being executed. This patch
> > protects the critical section with a mutex.
> > 
> > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > ---
> > 
> > Index: wireless-testing/drivers/net/wireless/rtl8187.h
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/rtl8187.h
> > +++ wireless-testing/drivers/net/wireless/rtl8187.h
> > @@ -94,6 +94,7 @@ struct rtl8187_priv {
> >   	const struct rtl818x_rf_ops *rf;
> >   	struct ieee80211_vif *vif;
> >   	int mode;
> > +	struct mutex mutex;	/* used to lock config callback */
> 
> Well, hm.
> Using locks to protect code is a bad idea, most of the time.
> So that comment makes no sense.
> 
> What that lock _probably_ does it to protect the configuration
> data in struct rtl8187_priv. So you'd better find out which data
> that is and clarify the comment.

and the mutex name, of course.

	/* Mutex to protect the device configuration data,
	 * which is foobar and bizzbaz */
	struct mutex conf_mutex;

-- 
Greetings Michael.
