Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40828 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1DEA2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 20:28:30 -0400
Received: by qyg14 with SMTP id 14so4187152qyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 17:28:29 -0700 (PDT)
Message-ID: <4D9A6229.2060403@gmail.com>
Date: Mon, 04 Apr 2011 20:28:25 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	Realman Namingston <realname1776@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: bad packets in monitor mode with ar9170 devices
References: <AANLkTi=pWrS9jK1obHLiXu+oLK6YS00fG-YQqzUieYH7@mail.gmail.com> <201104010951.42502.chunkeey@googlemail.com> <AANLkTinKzC66WUwPZBhuuVgyCEPrfd-9tv36QoP4s60F@mail.gmail.com> <201104011933.57597.chunkeey@googlemail.com> <BANLkTim51mYCDf-BRbR_GQd+E3DbUWDWYw@mail.gmail.com>
In-Reply-To: <BANLkTim51mYCDf-BRbR_GQd+E3DbUWDWYw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/04/11 20:16, Gábor Stefanik wrote:
> 2011/4/1 Christian Lamparter <chunkeey@googlemail.com>:
>> On Friday 01 April 2011 18:54:29 Gábor Stefanik wrote:
>>> On Fri, Apr 1, 2011 at 9:51 AM, Christian Lamparter
>>> <chunkeey@googlemail.com> wrote:
>>>> On Friday 01 April 2011 05:12:45 Realman Namingston wrote:
>>>>> ar9170-based devices record a fair amount of bad packets in monitor
>>>>> mode both with the old ar9170usb and new carl9170 drivers. The packets
>>>>> contain random BSSIDs, some measure of additional random data, and
>>>>> seem to scale proportional to the amount of traffic occurring on the
>>>>> observed channel. This behavior makes the devices rather unattractive
>>>>> for use in Kismet and site survey applications.
>>>>>
>>>>> I assume this is due to a shortcoming of the hardware.. but is there
>>>>> any potential fix possible?
>>>> no, you misunderstood that completely: it's a shortcoming of kismet!
>>>>
>>>> quote:
>>>> "Usually the wireless adapter is unable to transmit in monitor mode and
>>>> is restricted to a single wireless channel, though this is dependent on
>>>> the wireless adapter's driver, its firmware, and its chip set's features.
>>>> Also, in monitor mode the adapter does not check to see if the cyclic
>>>> redundancy check (CRC) values are correct for packets captured, so some
>>>> captured packets may be corrupted."
>>>>
>>>> http://en.wikipedia.org/wiki/Monitor_mode
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>> Isn't ar9170 the wireless-N version of zd1211? Because zd1211
>>> also had this problem with ZD_SNIFFER_ON. See
>>> http://patches.aircrack-ng.org/zd1211rw_inject_2.6.26.patch
>> inject? ???
> The patch is misnamed.
>
>> quote from include/net/mac80211.h:
>>
>> "enum ieee80211_filter_flags - hardware filter flags
>>
>> These flags determine what the filter in hardware should be
>> programmed to let through and what should not be passed to the
>> stack. >>>>> It is always safe to pass more frames than requested,
>> but this has negative impact on power consumption. <<<<<"
>>
>> so, if you don't want the garbage then don't enable monitor mode.
>> OR set the appropriate FIF_ filter flags and hope the mntr setting
>> doesn't affect the way how the hardware/firmware/driver/stack
>> marks "bad" frames.
> IIRC in zd1211, the garbage was not simply PLCP-failed frames - the HW
> returns completely bogus frames with ZD_SNIFFER_ON, even if placed in
> an RF isolation chamber. Not sure about ar9170, but AFAIK ar9170
> inherits quite a bit from zd1211.
>
zd1211 sent garbage constantly, things were actually added to kismet
because of that failure.

While I personally have no such issues with chr's most excellent driver,
I can still point you to kismet's readme and suggest you search for
'fcs'.  Assuming the card has a similar issue to the zydas it passes bad
frames but validating the fcs drops the bad packets.

-Zero_Chaos

>> Regards,
>>        Chr
>>
>
>

