Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48107 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0KBROB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 13:14:01 -0400
Message-ID: <4CD046D2.4080703@openwrt.org>
Date: Tue, 02 Nov 2010 18:13:54 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: fix tx queue selection
References: <alpine.DEB.2.00.1011021655080.23045@vtdt3>
In-Reply-To: <alpine.DEB.2.00.1011021655080.23045@vtdt3>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-02 5:13 PM, Björn Smedman wrote:
> Hi all,
> 
> The following patch attempts to fix some problems with ath9k tx queue 
> selection:
> 
> 1. There was a posible mismatch between the queue selected for QoS packets 
> (on which locking, queue start/stop and statistics where performed) and 
> the queue actually used for TX. This is fixed by selecting the tx queue 
> based on the TID of the 802.11 header for this type of packet.
This should not be necessary. mac80211 should take care of queue
selection properly for QoS frames. If it doesn't, then that is the bug
that needs to be fixed...

> 2. Even with the above fix there was still a risk of mac80211 queue 
> "deadlock" because the queue to stop was selected on the basis of the skb 
> queue mapping whereas the queue to start was selected based on the hardware
> tx queue to mac80211 queue mapping. These may not in all situations be one 
> and the same.
Instead of working around this, we need to make sure that those are
always identical.

> This patch is against latest wireless-testing but I've only tested it 
> against compat-wireless-2010-10-19 with openwrt patches on top (including 
> Luis latest pcu lock patch) and some other patches I'm working on. If you 
> can run wireless-testing directly, please give it a spin. For me it's a 
> big improvement in stability under high tx/rx load. 
> 
> Any thoughts?
Let's do a thorough review of the tx path and figure out where the
mismatch is actually coming from.

- Felix
