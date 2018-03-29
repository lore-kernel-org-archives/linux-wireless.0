Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55842 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeC2Ixw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 04:53:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Suppress "Unknown eventid: 36925" warnings
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522049641-19521-1-git-send-email-murugana@codeaurora.org>
References: <1522049641-19521-1-git-send-email-murugana@codeaurora.org>
To: Sathishkumar Muruganandam <murugana@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>
Message-Id: <20180329085352.1C183602FC@smtp.codeaurora.org> (sfid-20180329_105356_440809_C717F5CE)
Date: Thu, 29 Mar 2018 08:53:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sathishkumar Muruganandam <murugana@codeaurora.org> wrote:

> FW has Smart Logging feature enabled by default for detecting failures
> and processing FATAL_CONDITION_EVENTID (36925 - 0x903D) back to host.
> 
> Since ath10k doesn't implement the Smart Logging and FATAL CONDITION
> EVENT processing yet, suppressing the unknown event ID warning by moving
> this under ATH10K_DBG_WMI.
> 
> Simulated the same issue by having associated STA powered off when
> ping flood was running from AP backbone. This triggerd STA KICKOUT
> in AP followed by FATAL CONDITION event 36925.
> 
> Issue was reproduced and verified in below DUT
> ------------------------------------------------
> AP mode of OpenWRT QCA9984 running 6.0.8 with FW ver 10.4-3.5.3-00053
> 
> Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

606204bb863f ath10k: suppress "Unknown eventid: 36925" warnings

-- 
https://patchwork.kernel.org/patch/10307269/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
