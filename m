Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52593 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab2JJP1J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 11:27:09 -0400
Message-ID: <507593CA.3060501@openwrt.org> (sfid-20121010_172713_958589_3F5D546E)
Date: Wed, 10 Oct 2012 17:27:06 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.7] mac80211: use ieee80211_free_txskb to fix possible
 skb leaks
References: <1349699973-90027-1-git-send-email-nbd@openwrt.org>  <507570E3.9000107@openwrt.org> <1349879153.4683.51.camel@jlt4.sipsolutions.net>
In-Reply-To: <1349879153.4683.51.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-10 4:25 PM, Johannes Berg wrote:
> On Wed, 2012-10-10 at 14:58 +0200, Felix Fietkau wrote:
>> On 2012-10-08 2:39 PM, Felix Fietkau wrote:
>> > A few places free skbs using dev_kfree_skb even though they're called
>> > after ieee80211_subif_start_xmit might have cloned it for tracking tx
>> > status. Use ieee80211_free_txskb here to prevent skb leaks.
>> > 
>> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> > Cc: stable@vger.kernel.org
>> Found a few more places that should use ieee80211_free_txskb, will send
>> a v2.
> 
> John already applied this, no?
Oh right, missed that. Will send an incremental patch then.

- Felix

