Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55808
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662AbXBEP2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 10:28:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Jouni Malinen <jkmaline@cc.hut.fi>
Subject: Re: [PATCH] d80211: Add API to generate RTS and CTS-to-self frames
Date: Mon, 5 Feb 2007 16:28:46 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702051412.50703.mb@bu3sch.de> <20070205145824.GA6637@jm.kir.nu>
In-Reply-To: <20070205145824.GA6637@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702051628.46518.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 05 February 2007 15:58, Jouni Malinen wrote:
> > Index: bu3sch-wireless-dev/include/net/d80211.h
> > ===================================================================
> > --- bu3sch-wireless-dev.orig/include/net/d80211.h	2007-02-05 13:59:34.000000000 +0100
> > +++ bu3sch-wireless-dev/include/net/d80211.h	2007-02-05 14:01:30.000000000 +0100
> > @@ -194,7 +194,6 @@ struct ieee80211_tx_control {
> >  #define IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY (1<<9)
> >  	u32 flags;			       /* tx control flags defined
> >  						* above */
> > -	u16 rts_cts_duration;	/* duration field for RTS/CTS frame */
> >  	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, .. */
> >  	u8 power_level;		/* per-packet transmit power level, in dBm */
> >  	u8 antenna_sel; 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
> 
> NAK. Why are you removing this? It is needed for hardware that generates
> RTS/CTS frames.

As I said in response to Johannes' comment, if a driver needs just
the duration, we should export the functions to calculate it
and remove the calculation from the tx_control and the tx_control
setup path.

Currently there is no driver using it, so I simply removed it.

BTW: Which cards need the duration, but not the whole frame?

-- 
Greetings Michael.
