Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55924 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbZKBXRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 18:17:03 -0500
Received: by bwz27 with SMTP id 27so6920498bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2009 15:17:06 -0800 (PST)
Subject: Re: [PATCH 1/2] Allow scanning while in authenticated only state
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20091101201024.GA29524@jm.kir.nu>
References: <1256939391.31271.11.camel@maxim-laptop>
	 <1256939549.31271.14.camel@maxim-laptop>
	 <1256967782.3555.69.camel@johannes.local>
	 <1256982381.3089.10.camel@maxim-laptop>
	 <1256983366.3555.119.camel@johannes.local>
	 <1256985196.3089.34.camel@maxim-laptop>  <20091101201024.GA29524@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 01:17:01 +0200
Message-ID: <1257203821.6717.24.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-11-01 at 22:10 +0200, Jouni Malinen wrote: 
> On Sat, Oct 31, 2009 at 12:33:16PM +0200, Maxim Levitsky wrote:
> 
> > How about putting this in wpa_supplicant, and end all trouble with this
> > for once?
> > 
> > This is a workaround/hack, but at least it works....
> 
> Could you please add a comment pointing that out and explaining that the
> deauth in disassoc is there due to mac80211's inability to handle
> multiple APs in authenticated-but-not-associated state?
I resend this patch with proper comment.

> 
> > diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
> >  static int wpa_driver_nl80211_disassociate(void *priv, const u8 *addr,
> >                                            int reason_code)
> 
> > -       return wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DISASSOCIATE,
> > +
> > +       err = wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DISASSOCIATE,
> > +                                      reason_code);
> > +       if (err)
> > +               return err;
> > +       return wpa_driver_nl80211_mlme(drv, addr, NL80211_CMD_DEAUTHENTICATE,
> >                                        reason_code);
> 
> There should be no need for doing both disassoc and deauth; just send
> deauth only if that is needed. This will save one extra frame
> transmission and speeds up roaming a bit.
> 
> Though, is this enough to handle the roaming cases where wpa_supplicant
> may not try to send either disassociation or deauthentication?
Currently wpa_supplicant sends only disassociation.
deauthentication is send only in rare cases, usually due to [suspected]
authentication error.
Other that that I don't know, what I need is a clear statement about how
things should work that is:


* Should kernel allow authentication while in authenticated? I guess yes
To same AP? To different APs?

* What should kernel do if it done authentication to several APs?, but
not association.
should it timeout, or let wpa_suplicant do it?
Currently it allows 4 (or 3) such APs, and then then bugs out with
-ENOSPC


* Should kernel allow scanning while in authenticated but not associated
case? 
I have send patch to do so, I hope it will be accepted.


While 3 (or more if I didn't find all of them) problems remain, this
workaround is the only solution.


Best regards,
Maxim Levitsky

