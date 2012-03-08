Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20001 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab2CHMlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 07:41:22 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Message-ID: <20312.43226.814441.345911@gargle.gargle.HOWL> (sfid-20120308_134125_755246_C188D136)
Date: Thu, 8 Mar 2012 18:10:58 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<Mohammed@venema.h4ckr.net>, <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>
Subject: [ath9k-devel] [RFC 1/1] ath9k_hw: Fix enabling of MCI and RTT
In-Reply-To: <1331201325-17706-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1331201325-17706-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> +
> +	if (AR_SREV_9462(ah)) {
> +		ah->ent_mode = REG_READ(ah, AR_ENT_OTP);
> +		if (!(ah->ent_mode & AR_ENT_OTP_49GHZ_DISABLE))
> +			pCap->hw_caps |= ATH9K_HW_CAP_MCI;
> +	}
> +
> +	if (AR_SREV_9462_20(ah))
> +		pCap->hw_caps |= ATH9K_HW_CAP_RTT;

ah->ent_mode is already being updated earlier in ath9k_hw_fill_cap_info(),
so there is no need to read AR_ENT_OTP again.

Sujith
