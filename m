Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49300 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1EJRs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 13:48:56 -0400
Message-ID: <4DC97A85.40109@candelatech.com> (sfid-20110510_194909_136860_661BEFE4)
Date: Tue, 10 May 2011 10:48:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k and ath9k bugs still in 2.6.39-rc7
References: <4DC968FD.1040906@candelatech.com> <4DC97189.1090105@openwrt.org>
In-Reply-To: <4DC97189.1090105@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 10:10 AM, Felix Fietkau wrote:
> On 2011-05-10 6:34 PM, Ben Greear wrote:
>> As far as I can tell, ath5k is critically broken due to un-initilized
>> spinlock (fixed in the patch I posted a few days ago), and ath9k stations
>> won't work due to PS bugs that Felix posted fixes for yesterday.
> Did you test my patch for that? I couldn't reproduce the issue, so I
> couldn't test whether my patch fully fixes it.

Better hold off on that patch..looks like the culprit.  Maybe vif is not NULL but
still bogus?


> (gdb) l *(ath_tx_start+0x640)
0xa123 is in ath_tx_start (/home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c:1833).
1828							   bf->bf_state.bfs_paprd);
1829	
1830			if (txctl->paprd)
1831				bf->bf_state.bfs_paprd_timestamp = jiffies;
1832	
1833			if ((vif && vif->type != NL80211_IFTYPE_AP &&
1834			            vif->type != NL80211_IFTYPE_AP_VLAN) ||
1835			    !ieee80211_is_data(hdr->frame_control) ||
1836			    (tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT))
1837				ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, true);


> - Felix


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

