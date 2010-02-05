Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40491 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0BETT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 14:19:58 -0500
Received: by bwz19 with SMTP id 19so93988bwz.28
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2010 11:19:55 -0800 (PST)
Message-ID: <4B6C6F56.2060401@lwfinger.net>
Date: Fri, 05 Feb 2010 13:19:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC][PATCH] b43: LP-PHY: always adjust gain table on channel
 	switch
References: <1265317065-2922-2-git-send-email-zajec5@gmail.com> 	<4B6B8F8B.6020908@lwfinger.net> <69e28c911002050841x20053c6jbe768c19e983ef50@mail.gmail.com> 	<4B6C5EF3.5060006@lwfinger.net> <69e28c911002051046s64c69462k9a43bcb1db704476@mail.gmail.com>
In-Reply-To: <69e28c911002051046s64c69462k9a43bcb1db704476@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2010 12:46 PM, Gábor Stefanik wrote:
> On Fri, Feb 5, 2010 at 7:09 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 02/05/2010 10:41 AM, Gábor Stefanik wrote:
>>> On Fri, Feb 5, 2010 at 4:24 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>>> On 02/04/2010 02:57 PM, Rafał Miłecki wrote:
>>>>> ---
>>>>> GÃ¡bor: I think you missed specs here. Could you check whole routine just for
>>>>> sure, please? I don't understand whole radio and chanspec magic yet.
>>>>> ---
>>>>>  drivers/net/wireless/b43/phy_lp.c |    2 +-
>>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
>>>>> index 185219e..61009ee 100644
>>>>> --- a/drivers/net/wireless/b43/phy_lp.c
>>>>> +++ b/drivers/net/wireless/b43/phy_lp.c
>>>>> @@ -2655,8 +2655,8 @@ static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
>>>>>               if (err)
>>>>>                       return err;
>>>>>               lpphy_set_analog_filter(dev, new_channel);
>>>>> -             lpphy_adjust_gain_table(dev, channel2freq_lp(new_channel));
>>>>>       }
>>>>> +     lpphy_adjust_gain_table(dev, channel2freq_lp(new_channel));
>>>>>
>>>>>       lpphy->channel = new_channel;
>>>>>       b43_write16(dev, B43_MMIO_CHANNEL, new_channel);
>>>>
>>>> Both the lpphy_set_analog_filter() and lpphy_adjust_gain_table() calls should be
>>>> outside the if statement. I changed the spec a little. It used to test "radio
>>>> enabled", but I have found that is always true for our driver.
>>>>
>>>> Larry
>>>>
>>>>
>>>
>>> Isn't set_analog_filter() rev0/1-specific?
>>
>> It was in the 4.174.64.19 driver that I RE'd when you wrote the LP PHY code.
>> That as changed in 5.10.56.46, which I am now doing. It will take me a while to
>> complete the new routine "LP PHY TX Filter Init" and a routine that it calls.
>>
>> Certainly, there is no hurry that these changes be made. Whenever you or Rafał
>> have time. There is no guarantee that these changes will have any effect on the
>> LP PHY operations. Hitting a moving target is not easy.
>>
>> Larry
>>
> 
> Just out of curiosity, is 5.10.56.46 available anywhere (for firmware reasons)?

I'm not sure what the driver version is, but a file with 508 ucode dated 6/26/09
is found at:

http://www.linksysbycisco.com/gpl/wrt610n_v2.00.00.05_us.tar.gz

The binaries are in directory wrt610n_v2.00.00.05_us/release/src/wl/linux/. I
used Daniel Lenski's script names b43_fwcutter.py can extract the firmware from
wl_apsta.o. Included are ucode_2w20 - Rev 20 802.11 cores have an SSLPN PHY.

I'm still looking for a file with 5XX firmware that is not a huge download. This
file contains everything needed to build the firmware for a WRT610N AP and is
356 MB. If anyone knows of a smaller file, please let me know.

Larry
