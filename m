Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40442 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab0JRRVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 13:21:40 -0400
Received: by gyg13 with SMTP id 13so571543gyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Oct 2010 10:21:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CBC7725.7050202@gmx.net>
References: <4CB6BE57.8010401@gmx.net> <1287071844.11341.5.camel@gnutoo-laptop>
 <AANLkTikosEtFnWqRVzMBKtNsB=aqOpqQFKDOZS3+pXTE@mail.gmail.com>
 <4CB74759.3030807@gmx.net> <AANLkTi=1Ar-gzRaskHGDLmkaDnr=9+oZnA=qBLCYcUAi@mail.gmail.com>
 <4CB7F7C7.7030804@gmx.net> <AANLkTi=u+mT2Xd0=0vt4uaf9hSnnkPKY+wN6DjAxME3m@mail.gmail.com>
 <4CBABB84.1090100@gmx.net> <4CBC7725.7050202@gmx.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 18 Oct 2010 10:21:05 -0700
Message-ID: <AANLkTincCSBfwa_Y-cy_42HfU5kP1puCbi2-dBwGkkHu@mail.gmail.com>
Subject: Re: Compat-wireless N900
To: George <george.news@gmx.net>, Bob Copeland <me@bobcopeland.com>,
	Luciano Coelho <luciano.coelho@nokia.com>
Cc: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 18, 2010 at 9:34 AM, George <george.news@gmx.net> wrote:
> On 17/10/2010 11:01, George wrote:
>>
>> On 15/10/2010 20:01, Luis R. Rodriguez wrote:
>>>
>>> On Thu, Oct 14, 2010 at 11:42 PM, George<george.news@gmx.net>
>>> wrote:
>>>>
>>>> On 14/10/2010 20:03, Luis R. Rodriguez wrote:
>>>>>
>>>>> On Thu, Oct 14, 2010 at 11:09 AM, George<george.news@gmx.net>
>>>>> wrote:
>>>>>
>>>>>> I have tried using even insmod and the modules load perfectly
>>>>>> but the wlan device doesn't show up.
>>>>>
>>>>> Then that likely means you are not loading the right module.
>>>>>
>>>>>> In dmesg nothing is displayed except for the cfg80211 and
>>>>>> when I rmmod the module wl1251 (wl1251: removed or similar)
>>>>>>
>>>>>> I'm still wondering what the hell I have to do.
>>>>>
>>>>> Are you sure you have the right module?
>>>>
>>>> Yes. The driver is the wl1251 family. As I said in previous posts
>>>> and from what some guys in the IRC channel tried to guess, it
>>>> seems that the problem might be in that the spi interface is
>>>> specific for any device, and in the n900 might be different from
>>>> the one implemented in compat-wireless.
>>>
>>> Heh, nope.
>>>
>>>> I'm a bit suprised about this fact, but they know more than I.
>>>
>>> Or, we had not yet accommodated yet for the fact that the wl1251
>>> driver was split out into its own directory from the original
>>> wl12xx/ directory and no one ever sent a patch to fix this on
>>> compat-wireless. I just fixed this on today's compat-wireless, so
>>> you can try that around noon PST time when the new tarball will be
>>> generated. Ah but there are some pcmcia crap compile issues, we
>>> just have to remove pcmcia support, well not now, I have other
>>> stuff to do.
>
> I have downloaded compat-wireless-2010-10-17.tar.bz2 and have compiled the
> code with no problem. I have seen the changes you've made creating modules
> wl1251, spi and sdio.
>
> I have run modprobe spi to upload the modules (also tried sdio) and no way.
> dmesg doesn't include any message. Below is the one after unloading the
> modules and uploading them again:
> rmmod spi wl1251 mac80211 cfg80211 compat_firmware_class
> modprobe spi
>
>>>
> wl1251: unloaded
> cfg80211: Calling CRDA to update world regulatory domain
>>>
>
> Below is the output for lsmod. As you can see modules are up and running,
> but when I execute ifconfig -a no wlan0 device shows up.
>
> Nokia-N900:~# lsmod | grep spi
> spi                     4352  0
> wl1251                 75840  1 spi
> mac80211              212984  2 spi,wl1251
> crc7                    1216  1 spi
> Nokia-N900:~# lsmod | grep compat
> compat_firmware_class     8896  1 wl1251
> compat                 10496  2 mac80211,cfg80211
> v4l1_compat            12100  1 videodev
> compat_ioctl32           832  1 fmtx_si4713
> Nokia-N900:~# lsmod | grep wl12
> wl1251                 75840  1 spi
> compat_firmware_class     8896  1 wl1251
> mac80211              212984  2 spi,wl1251
> cfg80211              148904  2 wl1251,mac80211
>
> Any help on that? Sorry but I'm somehow desesperate and don't know what to
> do. Actually I'm thinking on not using compat-wireless and nl80211 and get
> back to wireless-extensions.

Does your device use SDIO or SPI?

  Luis
