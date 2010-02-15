Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 26.mail-out.ovh.net ([91.121.27.225]:60648 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756594Ab0BOW05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 17:26:57 -0500
Message-ID: <4B79CA2C.9090201@free.fr>
Date: Mon, 15 Feb 2010 23:26:52 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: dsd@gentoo.org, kune@deine-taler.de,
	linux-wireless@vger.kernel.org, zd1211-devs@lists.sourceforge.net
Subject: Re: [PATCH v2] zd1211rw: Set hardware BSSID and set hardware IBSS
 	mode
References: <1266190499-2387-1-git-send-email-benoit.papillault@free.fr> 	<1266219191-19332-1-git-send-email-benoit.papillault@free.fr> <69e28c911002150342k510befdbr3f1ae4f7dcf6c56@mail.gmail.com>
In-Reply-To: <69e28c911002150342k510befdbr3f1ae4f7dcf6c56@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik a écrit :
> On Mon, Feb 15, 2010 at 8:33 AM, Benoit Papillault
> <benoit.papillault@free.fr> wrote:
>   
>> Both changes allow for proper TSF synchronisation in STA and IBSS mode.
>>
>> v2: Fix error handling logic
>>
>> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
>> ---
>>  drivers/net/wireless/zd1211rw/zd_chip.c |   21 ++++++++++++++++++++-
>>  drivers/net/wireless/zd1211rw/zd_chip.h |    1 +
>>  drivers/net/wireless/zd1211rw/zd_mac.c  |    8 +++++---
>>  3 files changed, 26 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
>> index 7ca95c4..f525459 100644
>> --- a/drivers/net/wireless/zd1211rw/zd_chip.c
>> +++ b/drivers/net/wireless/zd1211rw/zd_chip.c
>> @@ -397,6 +397,25 @@ int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr)
>>        return r;
>>  }
>>
>> +int zd_write_bssid(struct zd_chip *chip, const u8 *bssid)
>> +{
>> +       struct zd_ioreq32 ioreqs[] = {
>> +               { CR_BSSID_P1, 0 },
>> +               { CR_BSSID_P2, 0 }
>> +       };
>> +
>> +       if (bssid) {
>> +               ioreqs[0].value = (bssid[3] << 24)
>> +                               | (bssid[2] << 16)
>> +                               | (bssid[1] <<  8)
>> +                               |  bssid[0];
>> +               ioreqs[1].value = (bssid[5] <<  8)
>> +                               |  bssid[4];
>> +       }
>> +
>> +       return zd_iowrite32a(chip, ioreqs, ARRAY_SIZE(ioreqs));
>> +}
>> +
>>  int zd_read_regdomain(struct zd_chip *chip, u8 *regdomain)
>>  {
>>        int r;
>> @@ -806,7 +825,7 @@ static int hw_init_hmac(struct zd_chip *chip)
>>                { CR_AFTER_PNP,                 0x1 },
>>                { CR_WEP_PROTECT,               0x114 },
>>                { CR_IFS_VALUE,                 IFS_VALUE_DEFAULT },
>> -               { CR_CAM_MODE,                  MODE_AP_WDS},
>> +               { CR_CAM_MODE,                  MODE_IBSS},
>>        };
>>
>>        ZD_ASSERT(mutex_is_locked(&chip->mutex));
>> diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
>> index f8bbf7d..7b0c58c 100644
>> --- a/drivers/net/wireless/zd1211rw/zd_chip.h
>> +++ b/drivers/net/wireless/zd1211rw/zd_chip.h
>> @@ -881,6 +881,7 @@ static inline u8 _zd_chip_get_channel(struct zd_chip *chip)
>>  u8  zd_chip_get_channel(struct zd_chip *chip);
>>  int zd_read_regdomain(struct zd_chip *chip, u8 *regdomain);
>>  int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr);
>> +int zd_write_bssid(struct zd_chip *chip, const u8 *bssid);
>>  int zd_chip_switch_radio_on(struct zd_chip *chip);
>>  int zd_chip_switch_radio_off(struct zd_chip *chip);
>>  int zd_chip_enable_int(struct zd_chip *chip);
>> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
>> index 9cb6cbc..0de176b 100644
>> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
>> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
>> @@ -913,13 +913,13 @@ static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
>>                 */
>>                u32 cr_sniffer = !!(conf->flags & IEEE80211_CONF_MONITOR);
>>                ret = zd_iowrite32(&mac->chip, CR_SNIFFER_ON, cr_sniffer);
>> -               if (!ret)
>> +               if (ret)
>>                        return ret;
>>        }
>>     
>
>
> Crosstalk from your other patch?
>
>   
Oops .. I did something wrong with git rebase I guess. Will resent.

Regards,
Benoit

