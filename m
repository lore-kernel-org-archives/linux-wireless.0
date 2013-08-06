Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52877 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab3HFJsB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 05:48:01 -0400
Message-ID: <5200C64F.4080900@openwrt.org> (sfid-20130806_114805_650070_E18D94E6)
Date: Tue, 06 Aug 2013 11:47:59 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 07/12] ath9k: prepare queueing code for handling unaggregated
 traffic
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org> <1375732583-39001-7-git-send-email-nbd@openwrt.org> <20992.43399.220167.743676@gargle.gargle.HOWL>
In-Reply-To: <20992.43399.220167.743676@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-08-06 9:45 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> +		tx_info = IEEE80211_SKB_CB(skb);
>> +		tx_info->flags &= ~IEEE80211_TX_CTL_CLEAR_PS_FILT;
> Why is the PS filter flag cleared here ?
Because the previous value doesn't matter here. With software
scheduling, clearing the ps filter is triggered via
tid->ac->clear_ps_filter, and that is used to set the flag when a frame
is put into the hardware queue.
The IEEE80211_TX_CTL_CLEAR_PS_FILT is checked whenever a frame enters
the tid queue, and if it's set, tid->ac->clear_ps_filter gets set.
That way it doesn't have to loop the entire tid traffic up to the new
frame through the hw queue as filtered until the destination index gets
cleared.

>> -	txtid->paused = true;
>> +	txtid->paused = false;
> 
> Why change this ?
When going from aggregated to un-aggregated, the TID still needs to be
scheduled, and txtid->paused == true would prevent that.

- Felix

