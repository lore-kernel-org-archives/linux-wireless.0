Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:11829 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0KIXgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 18:36:08 -0500
Received: from hpaq14.eem.corp.google.com (hpaq14.eem.corp.google.com [172.25.149.14])
	by smtp-out.google.com with ESMTP id oA9Na6ed021051
	for <linux-wireless@vger.kernel.org>; Tue, 9 Nov 2010 15:36:06 -0800
Received: from iwn36 (iwn36.prod.google.com [10.241.68.100])
	by hpaq14.eem.corp.google.com with ESMTP id oA9NXr1U015123
	for <linux-wireless@vger.kernel.org>; Tue, 9 Nov 2010 15:36:05 -0800
Received: by iwn36 with SMTP id 36so25422iwn.18
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 15:36:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101109214045.GF2374@tuxdriver.com>
References: <201010211402.43857.helmut.schaa@googlemail.com>
	<20101021161006.CF75720391@glenhelen.mtv.corp.google.com>
	<20101109214045.GF2374@tuxdriver.com>
Date: Tue, 9 Nov 2010 15:36:03 -0800
Message-ID: <AANLkTikfV-YRasEW5482msEguVwu3fKKTJP3Yrvzz-Qr@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: Add support for CQM tx bitrate monitoring
From: Paul Stewart <pstew@google.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	helmut.schaa@googlemail.com
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John, folks.  I've tried this with and without the change above
(obviously misapplied by me in the above case), and I have to say the
advantages (reducing number of events) is far outweighed by the
disadvantages (slower notification time), so I would vote to use the
first version of the patch in this thread, without the test for
IEEE80211_TX_CTL_RATE_CTRL_PROBE.  That's what I'm running in my tree.

--
Paul

On Tue, Nov 9, 2010 at 1:40 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Thu, Oct 21, 2010 at 08:58:12AM -0700, Paul Stewart wrote:
>> Am Donnerstag 21 Oktober 2010 schrieb Helmut Schaa:
>> > You might want to filter out probe frames based on
>> > IEEE80211_TX_CTL_RATE_CTRL_PROBE as otherwise you could end up with
>> > sending a huge number of events to userspace.
>>
>> Thanks, Helmut.  I've incorporated your excellent suggestion.  In practice
>> I have gotten reasonably modest rates of updates at the user side, but
>> filtering unnecessary stuff is definitely worthwhile.
>>
>> --
>>
>> Add state, work proc and debugging parameters for monitoring
>> transmit-rate changes.
>>
>> Signed-off-by: Paul Stewart <pstew@google.com>
>
>> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
>> index 3153c19..22c2c61 100644
>> --- a/net/mac80211/status.c
>> +++ b/net/mac80211/status.c
>> @@ -154,6 +154,24 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
>>               }
>>
>>               ieee80211_queue_work(&local->hw, &local->recalc_smps);
>> +     } else if (ieee80211_is_data(mgmt->frame_control) &&
>> +                sdata->vif.type == NL80211_IFTYPE_STATION &&
>> +                   !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)) {
>> +             struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
>> +             if (ifmgd->cqm_bitrate_thold != 0 &&
>> +                 (ifmgd->last_cqm_tx_rate.idx != sta->last_tx_rate.idx ||
>> +                  (ifmgd->last_cqm_tx_rate.flags &
>> +                   (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_40_MHZ_WIDTH |
>> +                    IEEE80211_TX_RC_SHORT_GI)) !=
>> +                  (sta->last_tx_rate.flags &
>> +                   (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_40_MHZ_WIDTH |
>> +                    IEEE80211_TX_RC_SHORT_GI)) ||
>> +                  sdata->u.mgd.last_cqm_bitrate == 0)) {
>> +                     ifmgd->last_cqm_tx_rate = sta->last_tx_rate;
>> +                     ifmgd->tx_bitrate_changed = true;
>> +                     ieee80211_queue_work(&local->hw,
>> +                                          &ifmgd->bitrate_notify_work);
>> +             }
>>       }
>>  }
>
>  CC [M]  net/mac80211/status.o
> net/mac80211/status.c: In function ‘ieee80211_frame_acked’:
> net/mac80211/status.c:159: error: ‘info’ undeclared (first use in this function)
> net/mac80211/status.c:159: error: (Each undeclared identifier is reported only once
> net/mac80211/status.c:159: error: for each function it appears in.)
> make[1]: *** [net/mac80211/status.o] Error 1
> make: *** [net/mac80211/] Error 2
>
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>
