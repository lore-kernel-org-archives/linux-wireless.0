Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:39149 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3KSLj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 06:39:26 -0500
Received: by mail-oa0-f52.google.com with SMTP id h16so2661969oag.39
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 03:39:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABGE7dsTzYESpxfO8WL9JP1BR1QdrTNv5+EszuZm225R2pA=Zw@mail.gmail.com>
References: <CABGE7dsDtL0ZPAmOTW=G=hMdA-6r=yT0DtQx_-H6Yi6cGa6Udw@mail.gmail.com>
 <CABGE7dur4pM4vLz_iLx7u-g5ohKhXkwKAOmjJ86PE62mYwGPJw@mail.gmail.com>
 <CAG6hwVOOvKfZcv-J70EMeHM3pmx-ieeAF2-6UtbrmoN3xC=SLw@mail.gmail.com> <CABGE7dsTzYESpxfO8WL9JP1BR1QdrTNv5+EszuZm225R2pA=Zw@mail.gmail.com>
From: Gustavo Azambuja <gazambuja+hostapd@gmail.com>
Date: Tue, 19 Nov 2013 09:39:05 -0200
Message-ID: <CABGE7ds77Ea9YeGBLCCYYDfTFEm0MqjRA03aF=vpv9Y+=Z47oA@mail.gmail.com> (sfid-20131119_123929_838522_AAB63D82)
Subject: Re: NL80211_CMD_NEW_STATION result: -105 (No buffer space available)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank,
you know where i can find one list of devices (usb dongle) with more
ram, or without this limit (I need provide Internet at less to 30
stations)?

Another question, how I can find this limit in others dongles? (some
command to know this limit)

On Tue, Nov 19, 2013 at 7:25 AM, Gustavo Azambuja
<gazambuja+hostapd@gmail.com> wrote:
> Thank,
> you know where i can find one list of devices (usb dongle) with more ram, or
> without this limit (I need provide Internet at less to 30 stations)?
>
> Gustavo Azambuja
>
> El nov 19, 2013 2:12 a.m., "Thomas Pedersen" <thomas@cozybit.com> escribió:
>
>> Hi Gustavo,
>>
>> On Mon, Nov 18, 2013 at 6:20 PM, Gustavo Azambuja
>> <gazambuja+hostapd@gmail.com> wrote:
>> > Hi, I recently installed in my raspberry pi Raspbian with hostapd 1.0, I
>> > want to make my own Hotspot, but follow all tutorials, I can only get up
>> > to
>> > 6 stations connected at the same time.
>> >
>> > The next error apper with the #7 client try to connect:
>> > *NL80211_CMD_NEW_STATION result: -105 (No buffer space available)*
>> >
>> > How I can resize this and make more clients can connect to my device?
>> >
>> > Im using TL-WN722N dongle.
>>
>> That devices contains an AR9271, which uses the ath9k_htc driver. The
>> number of stations you can maintain is limited by the device RAM.
>> Luckily the AR9271 firmware is now GPL [1] so you can hack on this
>> yourself I'm not quite sure what the upper limit is, but we've raised
>> it to 16 without seeing any obvious breakage.
>>
>> Try modifying ATH9K_HTC_MAX_STA in the ath9k_htc driver and
>> ATH_NODE_MAX [2] in the firmware.
>>
>> [1] https://github.com/qca/open-ath9k-htc-firmware
>> [2]
>> https://github.com/qca/open-ath9k-htc-firmware/blob/master/target_firmware/wlan/include/wlan_hdr.h#L99
>>
>> --
>> Thomas
