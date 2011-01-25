Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48156 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1AYRAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 12:00:22 -0500
Received: by yib18 with SMTP id 18so1782968yib.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 09:00:21 -0800 (PST)
Date: Tue, 25 Jan 2011 15:00:53 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Brett Rudley <brudley@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	"vossen@broadcom.com" <vossen@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcm80211: fix error report string
Message-ID: <20110125170052.GA2205@joana>
References: <1295894723-28346-1-git-send-email-padovan@profusion.mobi>
 <AANLkTi=GqWNd6yu0CeWAzt9ZRgCDkFRgwMExZiqEUr3Z@mail.gmail.com>
 <7A94256FD72B884D9E7C55586C3CBCEE13CD6E8FB6@SJEXCHCCR01.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE13CD6E8FB6@SJEXCHCCR01.corp.ad.broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brett,

* Brett Rudley <brudley@broadcom.com> [2011-01-24 13:57:46 -0800]:

> > -----Original Message-----
> > From: Rafał Miłecki [mailto:zajec5@gmail.com]
> > Sent: Monday, January 24, 2011 1:17 PM
> > To: Gustavo F. Padovan
> > Cc: Brett Rudley; Henry Ptasinski; Dowan Kim; vossen@broadcom.com; Arend
> > Van Spriel; linux-wireless@vger.kernel.org
> > Subject: Re: [PATCH] brcm80211: fix error report string
> > 
> > 2011/1/24 Gustavo F. Padovan <padovan@profusion.mobi>:
> > > Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
> > > ---
> > >  drivers/staging/brcm80211/sys/wlc_mac80211.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c
> > b/drivers/staging/brcm80211/sys/wlc_mac80211.c
> > > index 5eb41d6..ee1bcc5 100644
> > > --- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
> > > +++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
> > > @@ -6910,7 +6910,7 @@ prep_mac80211_status(struct wlc_info *wlc,
> > d11rxhdr_t *rxh, struct sk_buff *p,
> > >                preamble = 0;
> > >                if (IS_CCK(rspec)) {
> > >                        if (rxh->PhyRxStatus_0 & PRXS0_SHORTH)
> > > -                               WL_ERROR("Short CCK\n");
> > > +                               WL_ERROR("%s: Short CCK\n, __func__");
> > 
> > I have no idea how WL_ERROR works, but are you sure of that?
> > 
> > You wrote:
> > "%s: Short CCK\n, __func__"
> > 
> > Didn't you mean:
> > "%s: Short CCK\n", __func__
> > ?
> > 
> 
> Rafal's suggestion is correct, the patch was incorrect.
> (Good eyes, Rafal)

I just sent a corrected one yesterday in this thread.

-- 
Gustavo F. Padovan
http://profusion.mobi
