Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46910 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbeH1Orz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 10:47:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wen Gong <wgong@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Add waiting htt tx complete before wow enable
References: <1535442443-22152-1-git-send-email-wgong@codeaurora.org>
Date: Tue, 28 Aug 2018 13:56:45 +0300
In-Reply-To: <1535442443-22152-1-git-send-email-wgong@codeaurora.org> (Wen
        Gong's message of "Tue, 28 Aug 2018 15:47:23 +0800")
Message-ID: <87lg8qg3o2.fsf@kamboji.qca.qualcomm.com> (sfid-20180828_125803_345457_A21F5111)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wen Gong <wgong@codeaurora.org> writes:

> If there have some tx packets pending in firmware, and then system

s/have/are/ but I can fix that.

> enter suspend, firmware will fail for wow enable. This will trigger
> mac80211 to stop ath10k and download firmware again, then it is
> non-wow suspend.
>
> After add the waiting htt tx complete, then firmware will have some
> time window to send or flush the pending tx packets.
>
> Tested with QCA6174 PCI with firmware
> WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
> It's not a regression with new firmware releases.
>
> Signed-off-by: Wen Gong <wgong@codeaurora.org>

-- 
Kalle Valo
