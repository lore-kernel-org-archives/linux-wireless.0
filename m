Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57122 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab0JDMvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 08:51:47 -0400
Message-ID: <4CA9CDDC.4000302@openwrt.org>
Date: Mon, 04 Oct 2010 14:51:40 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/4] ath9k_hw: merge codepaths that access the cycle	counter
 registers
References: <1286125639-15137-1-git-send-email-nbd@openwrt.org> <1286125639-15137-2-git-send-email-nbd@openwrt.org> <20101004063446.GA16078@vasanth-laptop> <4CA9BC4B.4010503@openwrt.org> <20101004122432.GA25423@vasanth-laptop>
In-Reply-To: <20101004122432.GA25423@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-04 2:24 PM, Vasanthakumar Thiagarajan wrote:
>> >> +	/* unfreeze counters */
>> >> +	REG_WRITE(ah, AR_MIBC, 0);
>> > 
>> > Please configure the relevant bit to unfreeze the counters.
>> What do you mean?
> 
> AR_MIBC does more than just freeze/unfreeze the counters, though I
> dont see any issues with setting the whole register to zero, it
> looks buggy. Please configure only the relevant bit to
> freeze/unfreeze the counters.
Other places in the code set it to zero as well, though sometimes
written in a weird way. I also checked the specs, there is no bit that's
supposed to be active at this point.

- Felix
