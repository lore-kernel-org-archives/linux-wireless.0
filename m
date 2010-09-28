Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46516 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab0I1X64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 19:58:56 -0400
Received: by iwn5 with SMTP id 5so270840iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 16:58:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100928230211.GA9844@jm.kir.nu>
References: <20100928222945.GB10932@tux> <20100928230211.GA9844@jm.kir.nu>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 28 Sep 2010 16:58:35 -0700
Message-ID: <AANLkTimGPPUW6=QYpZz7q96vt1GOd5kJ-tvYEKxZZT2B@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix rate_control_send_low warnings for delbas
To: Jouni Malinen <j@w1.fi>
Cc: linville@tuxdriver.com, stable@kernel.org,
	linux-wireless@vger.kernel.org, Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 4:02 PM, Jouni Malinen <j@w1.fi> wrote:
> On Tue, Sep 28, 2010 at 03:29:45PM -0700, Luis R. Rodriguez wrote:
>
>> Added support for cfg80211/mac80211 to cleanly roam between two BSSes
>> on an ESS by allowing the station to reassociate to an old AP and
>> only when that is done drop the old association. What we forgot to
>> take into consideration is that when we disassociate with the older
>> AP we may need to transmit frames to that AP and those frames may
>> actually be intended to go under a different channel and even sometimes
>> a completely separate band than the new APs.
>
> which frames are you talking about here?

ieee80211_send_delba()

> When reassociating to a new BSS
> in an ESS, there should be no need to transmit frames to the old AP
> anymore, i.e., we are never associated with more than one BSS (when
> talking about a single vif). We could just drop any potential TX frame
> to the old AP after the moment the new AP is marked associated.

That's the goal of this patch.

>> + * @channel: the channel this sta belongs to
>
>>  struct ieee80211_sta {
>> +     struct ieee80211_channel *channel;
>>       u32 supp_rates[IEEE80211_NUM_BANDS];
>>       u8 addr[ETH_ALEN];
>>       u16 aid;
>
>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>
>> @@ -1213,6 +1217,12 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
>>       if (!tx->sta)
>>               tx->sta = sta_info_get(sdata, hdr->addr1);
>>
>> +     if (tx->sta && tx->sta->sta.channel &&
>> +         tx->sta->sta.channel->center_freq != tx->channel->center_freq) {
>> +             I802_DEBUG_INC(local->tx_handlers_drop_wrong_channel);
>> +             return TX_DROP;
>> +     }
>
> Could this drop some off-channel frames should we happen to have a STA
> entry for the destination?

This would depend on where we set the tx->channel and I highlighted
that part of the code on my patch context diffs. The channel comes
from local->hw.conf.channel so if the peer is defined then the
assumption being made here is that we will only transmit to it on the
channel that the peer was on. During offchannel operation the
currently configured channel should be same:

        offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
        if (scan_chan) {
                chan = scan_chan;
                channel_type = NL80211_CHAN_NO_HT;
                local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
        } else if (local->tmp_channel &&
                   local->oper_channel != local->tmp_channel) {
                chan = scan_chan = local->tmp_channel;
                channel_type = local->tmp_channel_type;
                local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
        } else {
                chan = local->oper_channel;
                channel_type = local->_oper_channel_type;
                local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
        }
        offchannel_flag ^= local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;

        if (offchannel_flag || chan != local->hw.conf.channel ||
            channel_type != local->hw.conf.channel_type) {
                local->hw.conf.channel = chan;
                local->hw.conf.channel_type = channel_type;
                changed |= IEEE80211_CONF_CHANGE_CHANNEL;
        }

> I'm not sure about all implications of this,
> but I could not convince myself that this would be safe for all P2P use
> cases (e.g., frame exchange on non-operating  channel with a device that
> happens to be in group with us).

When going off channel the local->hw.conf.channel would still be
respected and only if the peer exists would we make the check for it.
If this assumption would break something for P2P then let me know.

  Luis
