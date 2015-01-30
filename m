Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57666 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbbA3OCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 09:02:00 -0500
Received: by mail-wg0-f42.google.com with SMTP id x13so27146457wgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 06:01:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422623446.1919.20.camel@sipsolutions.net>
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
	<1422621086-28970-1-git-send-email-michal.kazior@tieto.com>
	<1422621086-28970-3-git-send-email-michal.kazior@tieto.com>
	<1422622694.1919.17.camel@sipsolutions.net>
	<CA+BoTQkVuDqZVCVUB6pkDKp2tZ1sgnezju6Kg48JvnS4a_LZyA@mail.gmail.com>
	<1422623446.1919.20.camel@sipsolutions.net>
Date: Fri, 30 Jan 2015 15:01:59 +0100
Message-ID: <CA+BoTQ=pRfxreghBMNoqXfADSLntws_UZqtLHRHbdTrLJvH6bw@mail.gmail.com> (sfid-20150130_150205_229820_85EC3E47)
Subject: Re: [PATCH v2 2/7] ath10k: implement chanctx API
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 January 2015 at 14:10, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2015-01-30 at 14:06 +0100, Michal Kazior wrote:
>
>> I'm a bit reluctant to freely use mac80211 owned structures out of
>> mac80211_ops callback context, i.e. from a tasklet fearing
>> inconsistencies. Or am I worrying unnecessarily? If so I guess I'll
>> redo this and use mac80211's structures directly :-)
>
> Yeah that's a concern, we were just looking at something similar.
> However, I think at least with channel contexts you should be fine since
> mac80211 never really modifies them much, except for the width and # of
> chains needed?

With `width` you'll change `center_freq1` in many cases. Reading a
pair of old-and-new of each may not necessarily be fatal but may
introduce subtle bugs that are hard to debug. Even if the current code
doesn't really use these values out of mac80211 callback context now
it may become a problem later.

I don't know. I'll think about this a bit more. You *do* have a point.


> We've recently seen a similar issue with vif->bss_conf, and I'm
> considering making that an RCU-protected pointer rather than the
> embedded sub-struct, that way mac80211 can replace it atomically when
> needed. I've yet to see if that's practical though.

It'd be lovely if I could freely read mac80211 structures from
whatever context I want without any worries but I think you'd have to
introduce explicit locking between mac80211 and drivers or go ham with
RCU :-)


Michał
