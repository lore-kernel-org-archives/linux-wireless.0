Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54784 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761984Ab2FIADl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 20:03:41 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20434.37522.581625.203653@gargle.gargle.HOWL> (sfid-20120609_020345_916996_DFA397B5)
Date: Sat, 9 Jun 2012 05:32:26 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/9] ath9k_hw: Fix AR9462 power consumption on idle associated
In-Reply-To: <1339177148-21672-3-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339177148-21672-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1339177148-21672-3-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> +	if (!AR_SREV_9462_20(ah))
> +		goto skip_btcoex;
> +
> +	for (i = 0; i < AH_WAIT_TIMEOUT; i++) {
> +		btcoex_ctrl2 = REG_READ(ah, AR_BTCOEX_CTRL2);
> +		if (btcoex_ctrl2 != 0xdeadbeef)
> +			break;
> +		udelay(AH_TIME_QUANTUM);
> +	}
> +	REG_WRITE(ah, AR_BTCOEX_CTRL2, (btcoex_ctrl2 | BIT(23)));
> +
> +	for (i = 0; i < AH_WAIT_TIMEOUT; i++) {
> +		diag_sw = REG_READ(ah, AR_DIAG_SW);
> +		if (diag_sw != 0xdeadbeef)
> +			break;
> +		udelay(AH_TIME_QUANTUM);
> +	}
> +	REG_WRITE(ah, AR_DIAG_SW, (diag_sw | BIT(27) | BIT(19) | BIT(18)));
> +	lna_ctrl = REG_READ(ah, AR_OBS_BUS_CTRL) & 0x3;
> +	bt_sleep = REG_READ(ah, AR_MCI_RX_STATUS) & AR_MCI_RX_REMOTE_SLEEP;
> +
> +	REG_WRITE(ah, AR_BTCOEX_CTRL2, btcoex_ctrl2);
> +	REG_WRITE(ah, AR_DIAG_SW, diag_sw);
> +
> +	if (bt_sleep && (lna_ctrl == 2)) {
> +		REG_SET_BIT(ah, AR_BTCOEX_RC, 0x1);
> +		REG_CLR_BIT(ah, AR_BTCOEX_RC, 0x1);
> +		udelay(50);
> +	}
> +
> +skip_btcoex:

It would be cleaner to use a helper function for this and also check
whether MCI/BTCOEX is actually enabled.

Sujith
