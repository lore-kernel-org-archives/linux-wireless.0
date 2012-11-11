Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:36165
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753160Ab2KKQLS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 11:11:18 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20639.52359.988935.16158@gargle.gargle.HOWL> (sfid-20121111_171121_456784_082C9061)
Date: Sun, 11 Nov 2012 21:34:23 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_hw: Fix wrong peak detector DC offset
In-Reply-To: <1352452890-9512-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1352452890-9512-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> diff --git a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
> index 58f30f6..ccc42a7 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
> +++ b/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
> @@ -78,7 +78,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
>  	{0x0000a284, 0x00000000, 0x00000000, 0x00000150, 0x00000150},
>  	{0x0000a288, 0x00000110, 0x00000110, 0x00000110, 0x00000110},
>  	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
> -	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
> +	{0x0000a2c4, 0x00058d18, 0x00058d18, 0x00058d18, 0x00058d18},
>  	{0x0000a2d0, 0x00041981, 0x00041981, 0x00041981, 0x00041982},
>  	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
>  	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},

Can you also update the initvals for AR9462 and AR9565 in the initvals tool ?

Sujith
