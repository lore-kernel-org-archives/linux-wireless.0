Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57444 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2ABRrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 12:47:48 -0500
Message-ID: <4F01E141.1020903@qca.qualcomm.com> (sfid-20120102_184751_183806_9F5A30B5)
Date: Mon, 2 Jan 2012 18:54:25 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: send TCMD response through testmode events
References: <1325239020-6698-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1325239020-6698-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/30/2011 11:57 AM, Thomas Pedersen wrote:
> From: Thomas Pedersen <twpedersen@qca.qualcomm.com>
> 
> ath6kl no longer knows what it is transmitting through
> cfg80211_testmode, and simply passes opaque buffers between userspace
> and the firmware. Leave the CONT_RX enum for backwards compatibility.
> 
> Signed-off-by: Thomas Pedersen <twpedersen@qca.qualcomm.com>
> 
> v2:
> 	ath6kl_warn not _dbg, GFP_KERNEL, and misc. (Kalle)
> ---
>  drivers/net/wireless/ath/ath6kl/testmode.c |  104 +++++-----------------------
>  drivers/net/wireless/ath/ath6kl/testmode.h |    6 +-
>  drivers/net/wireless/ath/ath6kl/wmi.c      |    6 +-
>  3 files changed, 24 insertions(+), 92 deletions(-)

Please add the changelog after the "---" line, that way git does include
it to the commit log.

Thanks, patch applied with a minor change to return EOPNOTSUPP for
ATH6KL_TM_CMD_RX_REPORT. There's no need to support that command
anymore, keeping the entry in enum is enough.

Kalle
