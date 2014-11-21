Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46667 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbaKURFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 12:05:46 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath10k: Fix shared WEP
References: <1416492382-18058-1-git-send-email-sujith@msujith.org>
Date: Fri, 21 Nov 2014 19:05:41 +0200
In-Reply-To: <1416492382-18058-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Thu, 20 Nov 2014 19:36:22 +0530")
Message-ID: <87k32obi1m.fsf@kamboji.qca.qualcomm.com> (sfid-20141121_180550_819125_8C788313)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> When static keys are used in shared WEP, when a
> station is associated, message 3 is sent with an
> encrypted payload. But, for subsequent
> authentications that are triggered without a
> deauth, the auth frame is decrypted by the HW. To
> handle this, check if the WEP keys have already
> been set for the peer and if so, mark the
> frame as decrypted.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

[...]

> +		if (peer_key) {
> +			ath10k_dbg(ar, ATH10K_DBG_MAC,
> +				   "wep key present for peer: %pM\n", addr);
> +			status->flag |= RX_FLAG_DECRYPTED;
> +		}
> +	}
> +
> +}

A checkpatch warning:

drivers/net/wireless/ath/ath10k/wmi.c:1141: CHECK: Blank lines aren't necessary before a close brace '}'

-- 
Kalle Valo
