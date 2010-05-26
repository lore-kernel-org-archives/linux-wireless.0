Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56322 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab0EZSMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 14:12:47 -0400
Received: by pwi7 with SMTP id 7so321749pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 11:12:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BFD63F0.9020905@nets.rwth-aachen.de>
References: <4BFD04A4.4000403@nets.rwth-aachen.de> <AANLkTik5BnKa7eP4U2Qq6uDYiRk_uc47IpslpFeC0l9r@mail.gmail.com>
	<4BFD63F0.9020905@nets.rwth-aachen.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 11:12:26 -0700
Message-ID: <AANLkTim60i_JX589TDco2kzh9oT2UFHZbLj0kPyClExS@mail.gmail.com>
Subject: Re: regulatory problems with ath5k
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: David Quan <David.Quan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 11:09 AM, Arnd Hannemann
<hannemann@nets.rwth-aachen.de> wrote:
> Am 26.05.2010 19:11, schrieb Luis R. Rodriguez:
>> On Wed, May 26, 2010 at 4:23 AM, Arnd Hannemann
>> <hannemann@nets.rwth-aachen.de> wrote:
>>
>>> Hi,
>>>
>>> I'm trying to use 802.11a channels in AP mode with my ath5k nics with kernel 2.6.34.
>>> And after setting up crda, udev and wireless regdb,
>>>
>> Which release of wireless-regdb?
>>
>>
> This morning's git tree. I just copied the regulatory.bin from there.
> Last commit was:
>
> commit f3ba942f073358d1bca82a389da9f7da6e8fe81f
> Author: John W. Linville <linville@tuxdriver.com>
> Date:   Fri Feb 5 13:47:41 2010 -0500
>
>    wireless-regdb: update sha1sum.txt in Makefile and fix REGDB_CHANGED
>
>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
>
>
>
>>> "iw list" still shows flags
>>> "passive scanning, no IBSS" for most of the 802.11a channels (see below.)
>>>
>>> I wonder what I'm doing wrong here?
>>>
>> Lets take a look.
>>
>>
>>>        Band 2:
>>>                Frequencies:
>>>                        * 5180 MHz [36] (20.0 dBm) (radar detection)
>>>                        * 5200 MHz [40] (20.0 dBm) (radar detection)
>>>                        * 5220 MHz [44] (20.0 dBm) (radar detection)
>>>                        * 5240 MHz [48] (20.0 dBm) (radar detection)
>>>                        * 5260 MHz [52] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5280 MHz [56] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5300 MHz [60] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5320 MHz [64] (20.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5500 MHz [100] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5520 MHz [104] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5540 MHz [108] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5560 MHz [112] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5580 MHz [116] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5600 MHz [120] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5620 MHz [124] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5640 MHz [128] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5660 MHz [132] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5680 MHz [136] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>>>                        * 5700 MHz [140] (26.0 dBm) (passive scanning, no IBSS, radar detection)
>>>
>>
>> Please do: 'iw reg get' and paste the output here, the above channels
>> should not be passive scan/no-ibss for 'DE'.
>>
>
> hannemann@mrouter46:~ $ sudo iw reg get
> country DE:
>       (2400 - 2483 @ 40), (N/A, 20)
>       (5150 - 5350 @ 40), (N/A, 20), NO-OUTDOOR, DFS
>       (5470 - 5725 @ 40), (N/A, 26), NO-OUTDOOR, DFS
>
>
>>> hannemann@mrouter46:~ $ sudo iw reg get
>>> country DE:
>>>        (2400 - 2483 @ 40), (N/A, 20)
>>>        (5150 - 5350 @ 40), (N/A, 20), NO-OUTDOOR, DFS
>>>        (5470 - 5725 @ 40), (N/A, 26), NO-OUTDOOR, DFS
>>>
>>> dmesg snippet:
>>>
>>> May 26 12:10:36 mrouter46 kernel: [   30.023089] console [netcon0] enabled
>>> May 26 12:10:36 mrouter46 kernel: [   30.023103] netconsole: network logging started
>>> May 26 12:10:36 mrouter46 kernel: [   30.314702] cfg80211: Calling CRDA to update world regulatory domain
>>> May 26 12:10:37 mrouter46 kernel: [   30.555745] ath5k 0000:00:0c.0: registered as \'phy0\'
>>> May 26 12:10:37 mrouter46 kernel: [   31.039151] ath: EEPROM regdomain: 0x8114
>>>
>> WTF your EEPROM has 0x8114 set on the regulatory domain. David, have
>> you ever seen such a thing? This kernel (2.6.34) should already have
>> an ath5k EEPROM checksum check so the EEPROM should be valid. Lets
>> figure this out first before digging more into this.
>>
>> Some more notes below though.
>>
>
> You got me, I hacked this up:
>
> --- linux-2.6.34/drivers/net/wireless/ath/regd.c    2010-05-16
> 23:17:36.000000000 +0200
> +++ linux-2.6.34.x-um/drivers/net/wireless/ath/regd.c    2010-05-26
> 19:57:44.000000000 +0200
> @@ -501,7 +501,7 @@ ath_regd_init(struct ath_regulatory *reg
>         return -EINVAL;
>
>     ath_regd_sanitize(reg);
> -
> +    reg->current_rd = CTRY_GERMANY | COUNTRY_ERD_FLAG;
>     printk(KERN_DEBUG "ath: EEPROM regdomain: 0x%0x\n", reg->current_rd);
>
>     if (!ath_regd_is_eeprom_valid(reg)) {
>
>
> Do you think this is the cause?

You won't get support if you hack that stuff, you should be using only
what your EEPROM is configured for, otherwise good luck, you're on
your own.

Provide the logs with that change removed to receive more review,
otherwise I consider this thread dead.

  Luis
