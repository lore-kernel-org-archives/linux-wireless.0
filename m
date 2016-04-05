Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47464 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086AbcDEMqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 08:46:52 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
CC: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 3/3] ath10k: fix unconditional num_mpdus_ready subtraction
Date: Tue, 5 Apr 2016 12:46:37 +0000
Message-ID: <87wpocb4ur.fsf@kamboji.qca.qualcomm.com> (sfid-20160405_144712_224367_8FB0F27C)
References: <1459352551-11773-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1459352551-11773-3-git-send-email-rmanohar@qti.qualcomm.com>
	<56FD71D3.5090103@candelatech.com>
	<73a1d6a04908fe060559d1a6e9afb128@codeaurora.org>
In-Reply-To: <73a1d6a04908fe060559d1a6e9afb128@codeaurora.org> (Rajkumar
	Manoharan's message of "Fri, 01 Apr 2016 10:49:05 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2016-04-01 00:22, Ben Greear wrote:
>> On 03/30/2016 08:42 AM, Rajkumar Manoharan wrote:
>>> Decrement num_mpdus_ready only when rx amsdu is processed
>>> successfully.
>>> Not doing so, will result in leak and impact stabilty under low memory
>>> cases.
>>
>> Should this patch be rebased on top of the "ath10k: process htt rx
>> indication as batch mode" patch?
>>
> It should be on top of "ath10k: speedup htt rx descriptor processing
> for rx_ind". Instead of sending next version of original series, i
> sent it as follow up.

Should this commit log have a fixes line like this:

Fixes: 59465fe46ef1 ("ath10k: speedup htt rx descriptor processing for tx completion")

-- 
Kalle Valo