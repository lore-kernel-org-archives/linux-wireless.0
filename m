Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42914 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbbAMOWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 09:22:38 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH RESEND] ath10k: Fix potential Rx ring corruption
References: <1420823986-29503-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Tue, 13 Jan 2015 16:22:26 +0200
In-Reply-To: <1420823986-29503-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Fri, 9 Jan 2015 22:49:46
	+0530")
Message-ID: <878uh669r1.fsf@kamboji.qca.qualcomm.com> (sfid-20150113_152241_497452_B3D83990)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> When replenishing Rx buffers driver updates the address of the
> buffer and the index of rx buffer in rx ring to the firmware.
> Change in order by CPU can cause rx ring corruption. Add memory
> barrier before updating rx buffer index to guarantee the order.
>
> This could fix some instances of rx ring corruption due to done
> bit in rx attention flag not set.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Thanks, applied to ath.git.

-- 
Kalle Valo
