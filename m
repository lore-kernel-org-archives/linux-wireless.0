Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39626 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936193AbeFONPE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 09:15:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 6/6] ath10k: Add QMI message handshake for wcn3990 client
References: <20180605123732.1993-1-govinds@codeaurora.org>
Date: Fri, 15 Jun 2018 16:14:59 +0300
In-Reply-To: <20180605123732.1993-1-govinds@codeaurora.org> (Govind Singh's
        message of "Tue, 5 Jun 2018 18:07:32 +0530")
Message-ID: <871sd86vjg.fsf@kamboji.qca.qualcomm.com> (sfid-20180615_151508_954131_A8FFCD68)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> writes:

> Add WCN3990 QMI client handshakes for Q6 integrated WLAN connectivity
> subsystem. This layer is responsible for communicating qmi control
> messages to wifi fw QMI service using QMI messaging protocol.
>
> Qualcomm MSM Interface(QMI) is a messaging format used to communicate
> between components running between application processor and remote
> processors with underlying transport layer based on integrated
> chipset(shared memory) or discrete chipset(PCI/USB/SDIO/UART).
>
> With this patch-set basic functionality(STA/SAP) can be tested
> with WCN3990 chipset. The changes are verified with the firmware
> WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1 and SDM845 MTP device.
>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>

I applied this patchset to the pending branch to get some build testing:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=59ff1228bc7ecec5ed2558e0e6d33423da443180

Just FYI I noticed this patch has few simple conflicts due to patches I
have applied earlier this week:

Hunk #1 FAILED at 41.
1 out of 1 hunk FAILED -- saving rejects to file drivers/net/wireless/ath/ath10k/Kconfig.rej
patching file drivers/net/wireless/ath/ath10k/Makefile
patching file drivers/net/wireless/ath/ath10k/core.c
Hunk #1 succeeded at 1145 (offset 11 lines).
Hunk #2 succeeded at 1154 (offset 11 lines).
Hunk #3 succeeded at 1466 (offset 11 lines).
Hunk #4 succeeded at 1504 (offset 11 lines).
patching file drivers/net/wireless/ath/ath10k/core.h
Hunk #1 succeeded at 1167 (offset 2 lines).
patching file drivers/net/wireless/ath/ath10k/qmi.c
patching file drivers/net/wireless/ath/ath10k/qmi.h
patching file drivers/net/wireless/ath/ath10k/snoc.c
Hunk #1 succeeded at 68 (offset 1 line).
Hunk #2 succeeded at 193 (offset 1 line).
Hunk #3 succeeded at 896 (offset 1 line).
Hunk #4 succeeded at 1124 (offset 1 line).
Hunk #5 succeeded at 1538 (offset 1 line).
Hunk #6 succeeded at 1549 (offset 1 line).
Hunk #7 succeeded at 1570 (offset 1 line).
patching file drivers/net/wireless/ath/ath10k/snoc.h
Hunk #1 FAILED at 20.
Hunk #2 succeeded at 81 (offset -1 lines).
Hunk #3 succeeded at 91 (offset -1 lines).
1 out of 3 hunks FAILED -- saving rejects to file drivers/net/wireless/ath/ath10k/snoc.h.rej

-- 
Kalle Valo
