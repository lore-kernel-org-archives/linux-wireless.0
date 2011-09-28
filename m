Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44731 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab1I1Qte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 12:49:34 -0400
Message-ID: <4E8332E4.2060902@qca.qualcomm.com> (sfid-20110928_184938_287836_EC0DA5F9)
Date: Wed, 28 Sep 2011 20:14:52 +0530
From: mohammed <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Wilson Tsao <wtsao@qca.qualcomm.com>,
	"Hu, Russell" <rhu@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k_hw: extend GPIO pin select mask for rfkill
References: <1317215987-5952-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1317215987-5952-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, please drop this patch will resend a proper v2 patch, as its 
better to have a unique GPIO rfkill selection mask for AR5416 family of 
chip sets and AR93XX.

On Wednesday 28 September 2011 06:49 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>
> this extends the bits for rf kill GPIO selection to [7:2] from [4:2] as
> we use GPIO pin 11 as rfkill for AR9480 and also remove few unused macros
>
> Cc: Wilson Tsao<wtsao@qca.qualcomm.com>
> Cc: "Hu, Russell"<rhu@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath9k/eeprom.h |    7 +------
>   1 files changed, 1 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
> index a3c7d0c..9bde45c 100644
> --- a/drivers/net/wireless/ath/ath9k/eeprom.h
> +++ b/drivers/net/wireless/ath/ath9k/eeprom.h
> @@ -104,16 +104,11 @@
>   #define OLC_FOR_AR9287_10_LATER (AR_SREV_9287_11_OR_LATER(ah)&&  \
>   				 ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
>
> -#define AR_EEPROM_RFSILENT_GPIO_SEL     0x001c
> -#define AR_EEPROM_RFSILENT_GPIO_SEL_S   2
> -#define AR_EEPROM_RFSILENT_POLARITY     0x0002
> -#define AR_EEPROM_RFSILENT_POLARITY_S   1
> -
>   #define EEP_RFSILENT_ENABLED        0x0001
>   #define EEP_RFSILENT_ENABLED_S      0
>   #define EEP_RFSILENT_POLARITY       0x0002
>   #define EEP_RFSILENT_POLARITY_S     1
> -#define EEP_RFSILENT_GPIO_SEL       0x001c
> +#define EEP_RFSILENT_GPIO_SEL       0x00fc
>   #define EEP_RFSILENT_GPIO_SEL_S     2
>
>   #define AR5416_OPFLAGS_11A           0x01

