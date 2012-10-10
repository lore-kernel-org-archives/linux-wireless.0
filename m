Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58275 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab2JJM6O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 08:58:14 -0400
Message-ID: <507570E3.9000107@openwrt.org> (sfid-20121010_145817_471287_CB9BEBF5)
Date: Wed, 10 Oct 2012 14:58:11 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net
Subject: Re: [PATCH 3.7] mac80211: use ieee80211_free_txskb to fix possible
 skb leaks
References: <1349699973-90027-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1349699973-90027-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-08 2:39 PM, Felix Fietkau wrote:
> A few places free skbs using dev_kfree_skb even though they're called
> after ieee80211_subif_start_xmit might have cloned it for tracking tx
> status. Use ieee80211_free_txskb here to prevent skb leaks.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@vger.kernel.org
Found a few more places that should use ieee80211_free_txskb, will send
a v2.

- Felix

