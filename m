Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4183 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbbGXIL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 04:11:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Extend struct htt_mgmt_tx_dec for qca99x0
References: <1437456121-7800-1-git-send-email-rmani@qti.qualcomm.com>
Date: Fri, 24 Jul 2015 11:11:20 +0300
In-Reply-To: <1437456121-7800-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Tue, 21 Jul 2015 10:52:00 +0530")
Message-ID: <871tfyf00n.fsf@kamboji.qca.qualcomm.com> (sfid-20150724_101131_916276_BFE5B90D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> HTT_H2T_MSG_TYPE_MGMT_TX msg in 10.4 firmware carries additional
> 4 byte in htt_mgmt_tx_desc where it tells to firmware that at what
> rate mgmt frame has to go out in the air. It's an optional parameter,
> setting this field to zero will force firmware to choose auto rate
> and send the frame out.
>
> Those 4 byte info is missed out in the current code and 10.4 firmware
> ended up reading some junk in those 4 byte and sometime malfunctioning.
>
> Fix it by adding 4 byte in struct htt_mgmt_tx_desc. Non 10.4 firmware
> will not process those four byte. So, adding 4 byte at the end of
> struct htt_mgmt_tx_desc will not create any impact on other chipset.
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo
