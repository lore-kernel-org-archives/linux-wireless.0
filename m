Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0060.outbound.protection.outlook.com ([104.47.0.60]:53472
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750941AbeBZTRo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 14:17:44 -0500
Subject: Re: [PATCH] Revert "ath10k: send (re)assoc peer command when NSS
 changed"
To: Karthikeyan Periyasamy <periyasa@codeaurora.org>,
        ath10k@lists.infradead.org
References: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <80c73674-7508-9804-fa5b-12afcc296353@bowerswilkins.com> (sfid-20180226_201748_686484_B5D2294A)
Date: Mon, 26 Feb 2018 11:17:31 -0800
MIME-Version: 1.0
In-Reply-To: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> This reverts commit 55884c045d31a29cf69db8332d1064a1b61dd159.
>
> When Ath10k is in AP mode and an unassociated STA sends a VHT action frame
> (Operating Mode Notification for the NSS change) periodically to AP this causes
> ath10k to call ath10k_station_assoc() which sends WMI_PEER_ASSOC_CMDID during
> NSS update. Over the time (with a certain client it can happen within 15 mins
> when there are over 500 of these VHT action frames) continuous calls of
> WMI_PEER_ASSOC_CMDID cause firmware to assert due to resource exhaust.
Can you include the FW assert message in this commit?

Thanks,
Peter
