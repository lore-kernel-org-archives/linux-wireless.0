Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:19696 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbbGJIs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 04:48:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Delay device access after cold reset
References: <1435904142-30295-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Fri, 10 Jul 2015 11:48:51 +0300
In-Reply-To: <1435904142-30295-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Fri, 3 Jul 2015 11:45:42
	+0530")
Message-ID: <87pp40wg7g.fsf@kamboji.qca.qualcomm.com> (sfid-20150710_104902_834294_318A26D2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> It is observed that during cold reset pcie access right
> after a write operation to SOC_GLOBAL_RESET_ADDRESS causes
> Data Bus Error and system hard lockup. The reason
> for bus error is that pcie needs some time to get
> back to stable state for any transaction during cold reset. Add
> delay of 20 msecs after write of SOC_GLOBAL_RESET_ADDRESS
> to fix this issue.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

On what devices did you test this? That should be documented in the
commit log.

-- 
Kalle Valo
