Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55700 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab1HJS7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 14:59:42 -0400
Message-ID: <4E42D50E.2000608@openwrt.org> (sfid-20110810_205945_610760_45805686)
Date: Wed, 10 Aug 2011 12:59:26 -0600
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCHv2] ath9k: remove eeprom txgain override for minor version
 < 19
References: <1312359372-5586-1-git-send-email-lindner_marek@yahoo.de> <1312382116-27257-1-git-send-email-lindner_marek@yahoo.de> <20110810175826.GB25266@tuxdriver.com>
In-Reply-To: <20110810175826.GB25266@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-10 11:58 AM, John W. Linville wrote:
> On Wed, Aug 03, 2011 at 04:35:16PM +0200, Marek Lindner wrote:
>>  ath9k_hw_4k_get_eeprom() overrides the eeprom value for txgain if the
>>  minor version is not 19 or above with a value of 0.
>>  ar9002_hw_init_mode_gain_regs() relies on this information to
>>  determine whether this is a high power wifi card or not. The override
>>  caused the driver to always use the 'normal' power tables even for
>>  high power devices if their minor version was not high enough. Thus
>>  leading to reduced power output.
>>
>>  This isn't needed for the AR9285; the check originated with the
>>  AR9280 setup code which requires the EEPROM version check.
>>
>>  Signed-off-by: Marek Lindner<lindner_marek@yahoo.de>
>>  ---
>>   drivers/net/wireless/ath/ath9k/eeprom_4k.c |    5 +----
>>   1 files changed, 1 insertions(+), 4 deletions(-)
>>
>>  diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
>>  index 5b1e894..10f3072 100644
>>  --- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
>>  +++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
>>  @@ -237,10 +237,7 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
>>   	case EEP_ANT_DIV_CTL1:
>>   		return pModal->antdiv_ctl1;
>>   	case EEP_TXGAIN_TYPE:
>>  -		if (ver_minor>= AR5416_EEP_MINOR_VER_19)
>>  -			return pBase->txGainType;
>>  -		else
>>  -			return AR5416_EEP_TXGAIN_ORIGINAL;
>>  +		return pBase->txGainType;
>>   	default:
>>   		return 0;
>>   	}
>
> Any chance for an ACK from someone from Atheros on the ath9k team?
Acked-by: Felix Fietkau <nbd@openwrt.org>
