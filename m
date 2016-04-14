Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14252 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbcDNNLT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 09:11:19 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/8] ath10k: remove deprecated firmware API 1 support
Date: Thu, 14 Apr 2016 13:11:12 +0000
Message-ID: <874mb4s5cg.fsf@kamboji.qca.qualcomm.com> (sfid-20160414_151122_742100_75D32829)
References: <20160406144355.28399.23733.stgit@potku.adurom.net>
	<20160406144445.28399.74306.stgit@potku.adurom.net>
In-Reply-To: <20160406144445.28399.74306.stgit@potku.adurom.net> (Kalle Valo's
	message of "Wed, 6 Apr 2016 17:44:45 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> This has ben deprecated years ago, I haven't heard anyone using it since and
> most likely it won't even work anymore. So just remove all of it.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -35,8 +35,6 @@
>  #define QCA988X_HW_2_0_VERSION		0x4100016c
>  #define QCA988X_HW_2_0_CHIP_ID_REV	0x2
>  #define QCA988X_HW_2_0_FW_DIR		ATH10K_FW_DIR "/QCA988X/hw2.0"
> -#define QCA988X_HW_2_0_FW_FILE		"firmware.bin"
> -#define QCA988X_HW_2_0_OTP_FILE		"otp.bin"
>  #define QCA988X_HW_2_0_BOARD_DATA_FILE	"board.bin"
>  #define QCA988X_HW_2_0_PATCH_LOAD_ADDR	0x1234

I missed to remove all the other references to "firmware.bin" or
"otp.bin", for example:

#define QCA6174_HW_2_1_FW_FILE		"firmware.bin"
#define QCA6174_HW_2_1_OTP_FILE		"otp.bin"

Will send v2.

-- 
Kalle Valo