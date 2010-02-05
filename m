Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41058 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab0BEQ1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 11:27:47 -0500
Received: by bwz19 with SMTP id 19so1610803bwz.28
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2010 08:27:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B6B8F8B.6020908@lwfinger.net>
References: <1265317065-2922-2-git-send-email-zajec5@gmail.com>
	<4B6B8F8B.6020908@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 5 Feb 2010 17:27:25 +0100
Message-ID: <69e28c911002050827x63aa5d3cjda82d8c7a643fd82@mail.gmail.com>
Subject: Re: [RFC][PATCH] b43: LP-PHY: always adjust gain table on channel
	switch
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 5, 2010 at 4:24 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 02/04/2010 02:57 PM, Rafał Miłecki wrote:
>> ---
>> GÃ¡bor: I think you missed specs here. Could you check whole routine just for
>> sure, please? I don't understand whole radio and chanspec magic yet.
>> ---
>>  drivers/net/wireless/b43/phy_lp.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
>> index 185219e..61009ee 100644
>> --- a/drivers/net/wireless/b43/phy_lp.c
>> +++ b/drivers/net/wireless/b43/phy_lp.c
>> @@ -2655,8 +2655,8 @@ static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
>>               if (err)
>>                       return err;
>>               lpphy_set_analog_filter(dev, new_channel);
>> -             lpphy_adjust_gain_table(dev, channel2freq_lp(new_channel));
>>       }
>> +     lpphy_adjust_gain_table(dev, channel2freq_lp(new_channel));
>>
>>       lpphy->channel = new_channel;
>>       b43_write16(dev, B43_MMIO_CHANNEL, new_channel);
>
> Both the lpphy_set_analog_filter() and lpphy_adjust_gain_table() calls should be
> outside the if statement. I changed the spec a little. It used to test "radio
> enabled", but I have found that is always true for our driver.
>
> Larry
>
>

Isn't set_analog_filter() rev0/1-specific?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
