Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55038 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab1KCItk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 04:49:40 -0400
Received: by qabj40 with SMTP id j40so831585qab.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 01:49:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1320308142.3950.3.camel@jlt3.sipsolutions.net>
References: <CAFED-jkVtVFBJfDc-18a+RogAFoTVudS9_POjZHFZ=AtBu1p0g@mail.gmail.com>
	<1320306440.3950.0.camel@jlt3.sipsolutions.net>
	<CAFED-j=sP7PSD8yv1U4RA9-NGnjJ9CE5C6qWOQxZ=rzGMdt+2w@mail.gmail.com>
	<1320307683.3950.2.camel@jlt3.sipsolutions.net>
	<1320308142.3950.3.camel@jlt3.sipsolutions.net>
Date: Thu, 3 Nov 2011 09:49:39 +0100
Message-ID: <CAFED-jkx-_2r_T4GBAG46XbxzcpQ-RNqmEF7PuQem3zyEdrrBA@mail.gmail.com> (sfid-20111103_094944_643003_4ACDA9BB)
Subject: Re: mac80211: UAPSD - EOSP bit seems to be not set when send qos null frame
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/3 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2011-11-03 at 09:08 +0100, Johannes Berg wrote:
>
>> > Yes, I see this is set correctly before we call ieee80211_set_qos_hdr().
>> > Next ieee80211_set_qos_hdr() fuction seems not care about EOSP bit and
>> > we have this bit cleared before ieee80211_tx() call.
>>
>> Oh, WTH. Somebody had posted a patch that fixed that, I thought that
>> went in but in my testing this didn't show up since my device always
>> sets/clears it according to what I told it.
>
> Try this please.
>
> johannes
>
> --- wireless-testing.orig/net/mac80211/wme.c    2011-11-02 11:05:29.000000000 +0100
> +++ wireless-testing/net/mac80211/wme.c 2011-11-03 09:14:30.000000000 +0100
> @@ -143,10 +143,13 @@ void ieee80211_set_qos_hdr(struct ieee80
>        /* Fill in the QoS header if there is one. */
>        if (ieee80211_is_data_qos(hdr->frame_control)) {
>                u8 *p = ieee80211_get_qos_ctl(hdr);
> -               u8 ack_policy = 0, tid;
> +               u8 ack_policy, tid;
>
>                tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
>
> +               /* preserve EOSP bit */
> +               ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
> +
>                if (unlikely(sdata->local->wifi_wme_noack_test))
>                        ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
>                /* qos header is 2 bytes */
>
>
>

Verified. Now works correctly.
Thanks.

BR
Janusz
