Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:37273 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab0JMKCE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 06:02:04 -0400
Message-ID: <4CB5838B.3010105@openwrt.org>
Date: Wed, 13 Oct 2010 12:01:47 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 3/3] ath9k: add missing locking around ath9k_hw_proc_mib_event
References: <1286892483-71182-1-git-send-email-nbd@openwrt.org> <1286892483-71182-2-git-send-email-nbd@openwrt.org> <1286892483-71182-3-git-send-email-nbd@openwrt.org> <20101013052030.GA9021@vmraj-lnx.users.atheros.com>
In-Reply-To: <20101013052030.GA9021@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-13 7:20 AM, Rajkumar Manoharan wrote:
> On Tue, Oct 12, 2010 at 07:38:03PM +0530, Felix Fietkau wrote:
>> +		spin_lock(&common->cc_lock);
>>  		ath9k_hw_proc_mib_event(ah);
>> +		spin_unlock(&common->cc_lock);
>>  		ath9k_hw_set_interrupts(ah, ah->imask);
>>  	}
>>
> shouldn't we lock ath9k_ani_reset which also restarts ani?
No, cc_lock is not an ANI lock, it's only for the cycle counters, which
are not touched by ath9k_ani_reset at all.

- Felix
