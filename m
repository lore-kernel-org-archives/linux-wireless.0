Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14474 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab0JMFOn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 01:14:43 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 22:14:34 -0700
Date: Wed, 13 Oct 2010 10:50:31 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 3/3] ath9k: add missing locking around
 ath9k_hw_proc_mib_event
Message-ID: <20101013052030.GA9021@vmraj-lnx.users.atheros.com>
References: <1286892483-71182-1-git-send-email-nbd@openwrt.org>
 <1286892483-71182-2-git-send-email-nbd@openwrt.org>
 <1286892483-71182-3-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1286892483-71182-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 12, 2010 at 07:38:03PM +0530, Felix Fietkau wrote:
> +		spin_lock(&common->cc_lock);
>  		ath9k_hw_proc_mib_event(ah);
> +		spin_unlock(&common->cc_lock);
>  		ath9k_hw_set_interrupts(ah, ah->imask);
>  	}
>
shouldn't we lock ath9k_ani_reset which also restarts ani?

- Rajkumar
> -- 
> 1.7.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
