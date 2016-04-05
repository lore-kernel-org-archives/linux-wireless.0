Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37248 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932787AbcDENc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 09:32:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 05 Apr 2016 19:02:56 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] ath10k: fix calibration init sequence of qca99x0
In-Reply-To: <871t6kcjoo.fsf@kamboji.qca.qualcomm.com>
References: <1459352551-11773-1-git-send-email-rmanohar@qti.qualcomm.com>
 <871t6kcjoo.fsf@kamboji.qca.qualcomm.com>
Message-ID: <4d0be6a7b9bf219f751a2f64a18e8553@codeaurora.org> (sfid-20160405_153301_991465_E4702BFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-04-05 18:10, Valo, Kalle wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
>> pre-calibration is meant for qca4019 which contains only caldata
>> whereas calibration file is used by ar9888 and qca99x0 that contains
>> both board data and caldata. So by definition both pre-cal-file and
>> cal-file can not coexist. Keeping them in shared memory (union), is
>> breaking boot sequence of qca99x0. Fix it by storing both binaries
>> in separate memories. This issue is reported in ipq8064 platform which
>> includes caldata in flash memory.
>> 
>> Reported-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> 
> I added the fixes line in the pending branch:
> 
> Fixes: 3d9195ea19e4 ("ath10k: incorporate qca4019 cal data download 
> sequence")

Thanks.

-Rajkumar
