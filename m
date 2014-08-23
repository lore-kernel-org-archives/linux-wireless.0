Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:33833 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHWPjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 11:39:45 -0400
Received: by mail-vc0-f182.google.com with SMTP id hy4so13377940vcb.41
        for <linux-wireless@vger.kernel.org>; Sat, 23 Aug 2014 08:39:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140822091409.GA3263@w1.fi>
References: <1407783114-5469-1-git-send-email-chaitanya.mgit@gmail.com> <20140822091409.GA3263@w1.fi>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 23 Aug 2014 21:02:02 +0530
Message-ID: <CABPxzYL3d0GPTeR1omxFi7XXUm2-Zq92AzgZnoLvLL1k1Cs8zQ@mail.gmail.com> (sfid-20140823_173948_932725_76EC1EA2)
Subject: Re: [mac80211] Enforce protected check for unicast robust management frames.
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 22, 2014 at 2:44 PM, Jouni Malinen <j@w1.fi> wrote:
>
> On Tue, Aug 12, 2014 at 12:21:54AM +0530, chaitanya.mgit@gmail.com wrote:
> > Enforce the check for protected field for all unicast
> > robust management frames.
>
> Why? This function is supposed to indicate whether the frame is a robust
> action frame and as such, has to have Protected bit set to one. If the
> sender (attacker) tries to send the frame unprotected, it will still
> need to be caught here.
>
> Rather than enforcing anything, this would add a significant security
> vulnerability by breaking PMF more or less completely.

I agree jouni, we were using this API to figure out the length of the
crypto header (IV) to pass it to the HW crypto, so even for
unencrypted frames during the initial connection we were treating as
robust mgmt frames causing us trouble.
>
>
> > This removed the dependency on the driver to check for protected
> > bit, especially for those drivers who believed the API :-).
>
> Huh.. What is this driver referring to or what do you think the API is
> supposed to be doing? ieee80211_is_unicast_robust_mgmt_frame() is a
> static function within net/mac80211/rx.c and has only a single caller,
> so it cannot really be used by any driver..

Sorry, i overlooked the static in git, we have a custom kernel without
the static.

>
> > diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> > @@ -569,6 +569,9 @@ static int ieee80211_is_unicast_robust_mgmt_frame(struct sk_buff *skb)
> >       if (is_multicast_ether_addr(hdr->addr1))
> >               return 0;
> >
> > +     if (!ieee80211_has_protected(hdr->frame_control))
> > +             return 0;
> > +
> >       return ieee80211_is_robust_mgmt_frame(skb);
>
> This looks very incorrect. This would completely break
> ieee80211_drop_unencrypted_mgmt() and allow unprotected robust
> management frames to be processed.

Ok i see it. robust mgmt and protected robust mgmt checks are
independently handled, but as the name suggested unicast robust mgmt
isn't it better to club those 2 checks together?






-- 
Thanks,
Regards,
Chaitanya T K.
