Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58699 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1DEARS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 20:17:18 -0400
Received: by qwk3 with SMTP id 3so3686081qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 17:17:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104011933.57597.chunkeey@googlemail.com>
References: <AANLkTi=pWrS9jK1obHLiXu+oLK6YS00fG-YQqzUieYH7@mail.gmail.com>
 <201104010951.42502.chunkeey@googlemail.com> <AANLkTinKzC66WUwPZBhuuVgyCEPrfd-9tv36QoP4s60F@mail.gmail.com>
 <201104011933.57597.chunkeey@googlemail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 5 Apr 2011 02:16:58 +0200
Message-ID: <BANLkTim51mYCDf-BRbR_GQd+E3DbUWDWYw@mail.gmail.com>
Subject: Re: bad packets in monitor mode with ar9170 devices
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Realman Namingston <realname1776@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/1 Christian Lamparter <chunkeey@googlemail.com>:
> On Friday 01 April 2011 18:54:29 Gábor Stefanik wrote:
>> On Fri, Apr 1, 2011 at 9:51 AM, Christian Lamparter
>> <chunkeey@googlemail.com> wrote:
>> > On Friday 01 April 2011 05:12:45 Realman Namingston wrote:
>> >> ar9170-based devices record a fair amount of bad packets in monitor
>> >> mode both with the old ar9170usb and new carl9170 drivers. The packets
>> >> contain random BSSIDs, some measure of additional random data, and
>> >> seem to scale proportional to the amount of traffic occurring on the
>> >> observed channel. This behavior makes the devices rather unattractive
>> >> for use in Kismet and site survey applications.
>> >>
>> >> I assume this is due to a shortcoming of the hardware.. but is there
>> >> any potential fix possible?
>> > no, you misunderstood that completely: it's a shortcoming of kismet!
>> >
>> > quote:
>> > "Usually the wireless adapter is unable to transmit in monitor mode and
>> > is restricted to a single wireless channel, though this is dependent on
>> > the wireless adapter's driver, its firmware, and its chip set's features.
>> > Also, in monitor mode the adapter does not check to see if the cyclic
>> > redundancy check (CRC) values are correct for packets captured, so some
>> > captured packets may be corrupted."
>> >
>> > http://en.wikipedia.org/wiki/Monitor_mode
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>> Isn't ar9170 the wireless-N version of zd1211? Because zd1211
>> also had this problem with ZD_SNIFFER_ON. See
>> http://patches.aircrack-ng.org/zd1211rw_inject_2.6.26.patch
>
> inject? ???

The patch is misnamed.

>
> quote from include/net/mac80211.h:
>
> "enum ieee80211_filter_flags - hardware filter flags
>
> These flags determine what the filter in hardware should be
> programmed to let through and what should not be passed to the
> stack. >>>>> It is always safe to pass more frames than requested,
> but this has negative impact on power consumption. <<<<<"
>
> so, if you don't want the garbage then don't enable monitor mode.
> OR set the appropriate FIF_ filter flags and hope the mntr setting
> doesn't affect the way how the hardware/firmware/driver/stack
> marks "bad" frames.

IIRC in zd1211, the garbage was not simply PLCP-failed frames - the HW
returns completely bogus frames with ZD_SNIFFER_ON, even if placed in
an RF isolation chamber. Not sure about ar9170, but AFAIK ar9170
inherits quite a bit from zd1211.

>
> Regards,
>        Chr
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
