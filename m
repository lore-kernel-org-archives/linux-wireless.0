Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:17022 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab0JMMkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 08:40:10 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 05:40:01 -0700
Date: Wed, 13 Oct 2010 18:09:56 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 3/3] ath9k: add missing locking around
 ath9k_hw_proc_mib_event
Message-ID: <20101013123956.GA7503@senthil-lnx.users.atheros.com>
References: <1286892483-71182-1-git-send-email-nbd@openwrt.org>
 <1286892483-71182-2-git-send-email-nbd@openwrt.org>
 <1286892483-71182-3-git-send-email-nbd@openwrt.org>
 <20101013052030.GA9021@vmraj-lnx.users.atheros.com>
 <4CB5838B.3010105@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CB5838B.3010105@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 13, 2010 at 03:31:47PM +0530, Felix Fietkau wrote:
> On 2010-10-13 7:20 AM, Rajkumar Manoharan wrote:
> > On Tue, Oct 12, 2010 at 07:38:03PM +0530, Felix Fietkau wrote:
> >> +		spin_lock(&common->cc_lock);
> >>  		ath9k_hw_proc_mib_event(ah);
> >> +		spin_unlock(&common->cc_lock);
> >>  		ath9k_hw_set_interrupts(ah, ah->imask);
> >>  	}
> >>
> > shouldn't we lock ath9k_ani_reset which also restarts ani?
> No, cc_lock is not an ANI lock, it's only for the cycle counters, which
> are not touched by ath9k_ani_reset at all.
yes. cc_lock is meant for cycle counters. the confusion is that whether
ani_reset uses cc_conter. It's obviously not. so there is no need for
for locking ani_reset with the current code.

However I am wondering where are we resetting cc counters except
ath_hw_get_listen_time() which is obviously called after
ath_hw_cycle_counters_update(). There are plenty of cases where ani_reset
is called and shouldn't we reset these counters somewhere ???.
> 
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
