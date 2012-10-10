Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab2JJOZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 10:25:20 -0400
Message-ID: <1349879153.4683.51.camel@jlt4.sipsolutions.net> (sfid-20121010_162523_314342_C66D87EF)
Subject: Re: [PATCH 3.7] mac80211: use ieee80211_free_txskb to fix possible
 skb leaks
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 10 Oct 2012 16:25:53 +0200
In-Reply-To: <507570E3.9000107@openwrt.org>
References: <1349699973-90027-1-git-send-email-nbd@openwrt.org>
	 <507570E3.9000107@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-10 at 14:58 +0200, Felix Fietkau wrote:
> On 2012-10-08 2:39 PM, Felix Fietkau wrote:
> > A few places free skbs using dev_kfree_skb even though they're called
> > after ieee80211_subif_start_xmit might have cloned it for tracking tx
> > status. Use ieee80211_free_txskb here to prevent skb leaks.
> > 
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > Cc: stable@vger.kernel.org
> Found a few more places that should use ieee80211_free_txskb, will send
> a v2.

John already applied this, no?

johannes

