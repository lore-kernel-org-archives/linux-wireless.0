Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36310 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab1EJSgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 14:36:45 -0400
Message-ID: <4DC985B9.1040504@candelatech.com> (sfid-20110510_203651_638946_E5284CE7)
Date: Tue, 10 May 2011 11:36:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k and ath9k bugs still in 2.6.39-rc7
References: <4DC968FD.1040906@candelatech.com> <4DC97189.1090105@openwrt.org> <4DC97A85.40109@candelatech.com>
In-Reply-To: <4DC97A85.40109@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 10:48 AM, Ben Greear wrote:
> On 05/10/2011 10:10 AM, Felix Fietkau wrote:
>> On 2011-05-10 6:34 PM, Ben Greear wrote:
>>> As far as I can tell, ath5k is critically broken due to un-initilized
>>> spinlock (fixed in the patch I posted a few days ago), and ath9k
>>> stations
>>> won't work due to PS bugs that Felix posted fixes for yesterday.
>> Did you test my patch for that? I couldn't reproduce the issue, so I
>> couldn't test whether my patch fully fixes it.
>
> Better hold off on that patch..looks like the culprit. Maybe vif is not
> NULL but
> still bogus?
>
>
>> (gdb) l *(ath_tx_start+0x640)
> 0xa123 is in ath_tx_start
> (/home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c:1833).
>
> 1828 bf->bf_state.bfs_paprd);
> 1829
> 1830 if (txctl->paprd)
> 1831 bf->bf_state.bfs_paprd_timestamp = jiffies;
> 1832
> 1833 if ((vif && vif->type != NL80211_IFTYPE_AP &&
> 1834 vif->type != NL80211_IFTYPE_AP_VLAN) ||
> 1835 !ieee80211_is_data(hdr->frame_control) ||
> 1836 (tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT))
> 1837 ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, true);

Well, it seems vif is always, or at least mostly always, wrong in my testing.

I added code like this, and get the printout below:

		printk("vif: %p tx_info: %p control: %p\n",
		       vif, tx_info, &(tx_info->control));
		if ((((unsigned long)(vif) & ~0xff) && vif->type != NL80211_IFTYPE_AP &&
		            vif->type != NL80211_IFTYPE_AP_VLAN) ||

vif: 00000025 tx_info: f2749a98 control: f2749aa0
vif: 00000025 tx_info: f2749b58 control: f2749b60
vif: 00000025 tx_info: f26c8318 control: f26c8320
vif: 000000a1 tx_info: f26c8a98 control: f26c8aa0
vif: 000000a1 tx_info: f26c8c18 control: f26c8c20
vif: 000000a1 tx_info: f0491b58 control: f0491b60
vif: 00000099 tx_info: f0491198 control: f04911a0
vif: 00000025 tx_info: f2749498 control: f27494a0
vif: 000000a1 tx_info: f0491558 control: f0491560
vif: 000000a1 tx_info: f0491b58 control: f0491b60


>
>
>> - Felix
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

