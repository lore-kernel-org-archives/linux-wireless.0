Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:33650 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751010AbbGJEuS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 00:50:18 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Arend van Spriel <arend@broadcom.com>,
	Vineet Gupta <Vineet.Gupta1@synopsys.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Ingo Molnar" <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Daniel Kim <dekim@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/3] brcmfmac: dhd_sdio.c: use existing atomic_or
 primitive
Date: Fri, 10 Jul 2015 04:49:04 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075665AD26A@IN01WEMBXB.internal.synopsys.com> (sfid-20150710_065042_327577_4A9D397F)
References: <1436429599-10762-1-git-send-email-vgupta@synopsys.com>
 <1436429599-10762-3-git-send-email-vgupta@synopsys.com>
 <559EBC91.2070600@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 July 2015 11:55 PM, Arend van Spriel wrote:
> On 07/09/2015 10:13 AM, Vineet Gupta wrote:
>> > There's already a generic implementation so use that instead.
> There is or there was? If there is now I am fine with this patch, but if 
> it already was there the author might have had a reason for adding a 
> local function and I would like to hear that reason.
>

atomic_orr() was introduced to this driver with

2014-03-06 5cbb9c285bdc brcmfmac: Use atomic functions for intstatus update. 

as it seems atomic_set_mask() was not available cross arch. And atomic_or() in
generic code was indeed introduced after that

2014-04-23 560cb12a4080 locking,arch: Rewrite generic atomic support 

Hence likely the reason author went with home grown atomic_orr()

-Vineet
