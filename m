Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46593 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab1H2HF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 03:05:56 -0400
Message-ID: <4E5B3A4D.2040306@openwrt.org> (sfid-20110829_090559_656385_35A2C177)
Date: Mon, 29 Aug 2011 09:05:49 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: retry sending failed BAR frames later instead
 of tearing down aggr
References: <1314558661-28454-1-git-send-email-nbd@openwrt.org> <CAGXE3d_=BtQ+TEHG+y+ReftHB5Y9XhojsLyo9qkKSm4EpOGB8g@mail.gmail.com>
In-Reply-To: <CAGXE3d_=BtQ+TEHG+y+ReftHB5Y9XhojsLyo9qkKSm4EpOGB8g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-29 8:58 AM, Helmut Schaa wrote:
> On Sun, Aug 28, 2011 at 9:11 PM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>  Unfortunately failed BAR tx attempts happen more frequently than I
>>  expected, and the resulting aggregation teardowns cause performance
>>  issues, as the aggregation session does not always get re-established
>>  properly.
>>  Instead of tearing down the entire aggr session, we can simply store the
>>  SSN of the last failed BAR tx attempt, wait for the first successful
>>  tx status event, and then send another BAR with the same SSN.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  Cc: Helmut Schaa<helmut.schaa@googlemail.com>
>
> [...]
>
>>    static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
>>    {
>>          struct ieee80211_mgmt *mgmt = (void *) skb->data;
>>          struct ieee80211_local *local = sta->local;
>>          struct ieee80211_sub_if_data *sdata = sta->sdata;
>>
>>  +       if (ieee80211_is_data_qos(mgmt->frame_control)) {
>>  +               struct ieee80211_hdr *hdr = (void *) skb->data;
>>  +               u8 *qc = ieee80211_get_qos_ctl(hdr);
>>  +               u16 tid = qc[0]&  0xf;
>>  +
>>  +               ieee80211_check_pending_bar(sta, hdr->addr1, tid);
>>  +       }
>>  +
>
> This code will not be run for injected QoS frames. Is this intended?
> Otherwise looks good to me.
I didn't consider it, but I think it's fine. I don't expect any 
aggregated injected traffic under normal circumstances anyway.

- Felix
