Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:61324 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0A0A1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 19:27:03 -0500
Received: by fxm20 with SMTP id 20so1035565fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2010 16:27:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c911001261557q39a17b75oa8d46538144ce12d@mail.gmail.com>
References: <4b5f7e98.WueiIRrKwMIrtoob%Larry.Finger@lwfinger.net>
	 <69e28c911001261557q39a17b75oa8d46538144ce12d@mail.gmail.com>
Date: Wed, 27 Jan 2010 00:27:02 +0000
Message-ID: <3ace41891001261627n79db5e2aw83e1a943809ba567@mail.gmail.com>
Subject: Re: [PATCH] rtl8187: Add callback for get_tsf
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/26 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Wed, Jan 27, 2010 at 12:45 AM, Larry Finger
> <Larry.Finger@lwfinger.net> wrote:
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
>> ===================================================================
>> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
>> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
>> @@ -1265,6 +1265,14 @@ static int rtl8187_conf_tx(struct ieee80
>>        return 0;
>>  }
>>
>> +static u64 rtl8187_get_tsf(struct ieee80211_hw *dev)
>> +{
>> +       struct rtl8187_priv *priv = dev->priv;
>> +
>> +       return rtl818x_ioread32(priv, &priv->map->TSFT[0]) |
>> +              (u64)(rtl818x_ioread32(priv, &priv->map->TSFT[1])) << 32;
>> +}
>> +
>>  static const struct ieee80211_ops rtl8187_ops = {
>>        .tx                     = rtl8187_tx,
>>        .start                  = rtl8187_start,
>> @@ -1276,7 +1284,8 @@ static const struct ieee80211_ops rtl818
>>        .prepare_multicast      = rtl8187_prepare_multicast,
>>        .configure_filter       = rtl8187_configure_filter,
>>        .conf_tx                = rtl8187_conf_tx,
>> -       .rfkill_poll            = rtl8187_rfkill_poll
>> +       .rfkill_poll            = rtl8187_rfkill_poll,
>> +       .get_tsf                = rtl8187_get_tsf
>
> Please put a comma at the end of this line. It doesn't really matter,
> but this is the accepted kernel coding style.

Hmm, interesting - is that written down somewhere? Indeed a quick greb
through the wireless driver source says
most have a "," (but not always). OTOH, I seem to recall that one of
gcc's warning options will complain about empy elements in a list like
that - e.g. {a,b,c,} can trigger a gcc warning message if one of
-W<something> is specified.

>
>>  };
>>
>>  static void rtl8187_eeprom_register_read(struct eeprom_93cx6 *eeprom)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
