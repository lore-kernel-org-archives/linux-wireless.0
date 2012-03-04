Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58481 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab2CDWuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 17:50:12 -0500
Received: by vbbff1 with SMTP id ff1so2940068vbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 14:50:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVMo2ZgcNYDQ3UKRC2Wo_gibERBdgvaLWJmi52min8w3Hg@mail.gmail.com>
References: <1330731963-9905-1-git-send-email-thomas@cozybit.com>
 <1330731963-9905-2-git-send-email-thomas@cozybit.com> <1330774678.3619.1.camel@jlt3.sipsolutions.net>
 <CAG6hwVMo2ZgcNYDQ3UKRC2Wo_gibERBdgvaLWJmi52min8w3Hg@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Sun, 4 Mar 2012 14:49:51 -0800
Message-ID: <CAG6hwVMpZTG=vuidSvQvvJhBj=avW_JP5ewATLwTCZsNqcu5zw@mail.gmail.com> (sfid-20120304_235014_995172_1C43BF40)
Subject: Re: [PATCH v2 2/2] mac80211: fix mesh airtime link metric estimating
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open11s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

grrr, missed reply-all.

On Sun, Mar 4, 2012 at 2:37 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
> On Sat, Mar 3, 2012 at 3:37 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Fri, 2012-03-02 at 15:46 -0800, Thomas Pedersen wrote:
>>> Airtime link metric estimation was broken in HT mesh, use
>>> cfg80211_calculate_bitrate to get the right rate value.
>>>
>>> Also factor out rate copying from sta_set_sinfo().
>>>
>>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>>> ---
>>> v2:
>>> factor out rate copying (Johannes)
>>
>>> +void sta_set_rate_info(struct sta_info *sta, struct station_info *sinfo)
>>
>> For stack usage, it'd be better if you gave this two arguments (struct
>> rate_info *txrate, struct rate_info *rxrate), or maybe simply factored
>> out *only* the TX-rate bit?
>>
>
> like sta_set_rate_info(struct sta_info *sta, struct rate_info *txrate,
> struct rate_info *rxrate)?
>
> How do you feel about consolidating last_rx_flags and _index into an
> ieee80211_tx_rate? A bit odd maybe, but then we could use:
>
> sta_set_rate_info(struct ieee80211_tx_rate *rate, struct rate_info *rinfo);
>
> As needed for both last_rx and last_tx rates.
>
> Thomas
