Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 27.mail-out.ovh.net ([91.121.30.210]:50541 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754782Ab0BOHbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 02:31:34 -0500
Message-ID: <4B78F6C3.9030006@free.fr>
Date: Mon, 15 Feb 2010 08:24:51 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: dsd@gentoo.org, linux-wireless@vger.kernel.org,
	zd1211-devs@lists.sourceforge.net, kune@deine-taler.de
Subject: Re: [zd1211-devs] [PATCH 1/2] zd1211rw: Experimental change to add
 proper monitor support
References: <1266190499-2387-1-git-send-email-benoit.papillault@free.fr> <69e28c911002141628w76dc0419r43c7d753c16962da@mail.gmail.com>
In-Reply-To: <69e28c911002141628w76dc0419r43c7d753c16962da@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik a écrit :
> On Mon, Feb 15, 2010 at 12:34 AM, Benoit Papillault
> <benoit.papillault@free.fr> wrote:
>   
>> Without this patch, monitor mode does not returns all frames. With this patch,
>> the performance are quite poor if we create a monitor interface. Note :
>> creating a monitor interface with the "cook" flag has no impact on performance.
>>
>> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
>> ---
>>  drivers/net/wireless/zd1211rw/zd_mac.c |   20 +++++++++++++++++++-
>>  1 files changed, 19 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
>> index 2d555cc..9cb6cbc 100644
>> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
>> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
>> @@ -904,8 +904,26 @@ static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
>>  {
>>        struct zd_mac *mac = zd_hw_mac(hw);
>>        struct ieee80211_conf *conf = &hw->conf;
>> +       int ret;
>>
>> -       return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
>> +       if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
>> +               /*
>> +                * Warning : enabling this register kills RX & TX
>> +                * performance
>> +                */
>> +               u32 cr_sniffer = !!(conf->flags & IEEE80211_CONF_MONITOR);
>> +               ret = zd_iowrite32(&mac->chip, CR_SNIFFER_ON, cr_sniffer);
>> +               if (!ret)
>> +                       return ret;
>>     
>
> Your logic is the wrong way around. You should return if nonzero, not if zero.
>
>   
>> +       }
>> +
>> +       if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
>> +               ret = zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
>> +               if (!ret)
>> +                       return ret;
>> +       }
>> +
>> +       return 0;
>>  }
>>
>>  static void zd_process_intr(struct work_struct *work)
>> --
>> 1.5.6.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
>
>
>
>   
You are right. I will resend a patch.

Regards,
Benoit

