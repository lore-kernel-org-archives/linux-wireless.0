Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61958 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0K1QKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Nov 2010 11:10:32 -0500
Received: by fxm15 with SMTP id 15so1803778fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Nov 2010 08:10:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101126040742.GA5238@monopoli.naic.edu>
References: <20101122024208.GA13377@monopoli.naic.edu>
	<AANLkTikc9w+w8o=ZQBTnTD1=C0+yDVfq=jSfEFQ16dbm@mail.gmail.com>
	<20101125014511.GA1683@monopoli.naic.edu>
	<AANLkTi=nkayyyzECi6MO87ZO-CUpZeNP007_hMp8LiPV@mail.gmail.com>
	<20101126040742.GA5238@monopoli.naic.edu>
Date: Sun, 28 Nov 2010 16:10:30 +0000
Message-ID: <AANLkTim=P+QejCObCH1=5cPBDR6BpEXxuqHGZj3JBKbE@mail.gmail.com>
Subject: Re: orinoco_cs module and WPA not working
From: Dave Kilroy <kilroyd@gmail.com>
To: Giacomo Comes <comes@naic.edu>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 26, 2010 at 4:07 AM, Giacomo Comes <comes@naic.edu> wrote:
> On Thu, Nov 25, 2010 at 07:12:28PM +0000, Dave Kilroy wrote:
>>
>> > Attached you will find the wpa_supplicant.log created with the
>> > following command line:
>> > wpa_supplicant -ieth1 -c wpa_supplicant.conf -f wpa_supplicant.log -dd
>>
>> <paste>
>> Initializing interface 'eth1' conf 'wpa_supplicant.conf' driver
>> 'default' ctrl_interface 'N/A' bridge 'N/A'
>> ...
>> WEXT: cfg80211-based driver detected
>> ...
>> Driver did not support SIOCSIWENCODEEXT
>> </paste>
>>
>> eh? This looks like the problem. The driver should definitely support
>> this via the cfg80211 wrappers.
>>
>> You might try explicitly forcing wpa_supplicant to use the WEXT driver
>> with -Dwext, though I think the netlink interface ought to work as
>> well.
>
> Done. wpa_supplicant.log looks exactly the same except the line:
> Initializing interface 'eth1' conf 'wpa_supplicant.conf' driver 'default' ctrl_interface 'N/A' bridge 'N/A'
> is replaced with:
> Initializing interface 'eth1' conf 'wpa_supplicant.conf' driver 'wext' ctrl_interface 'N/A' bridge 'N/A'
> as it should be.
>
> One thing that I forgot to mention is that when I run wpa_supplicant,
> on the standard error are printed the following messages:
> ioctl[SIOCSIWENCODEEXT]: Invalid argument
> ioctl[SIOCSIWENCODEEXT]: Invalid argument
> ioctl[SIOCGIWSCAN]: Resource temporarily unavailable
> ioctl[SIOCSIWSCAN]: Device or resource busy
> ioctl[SIOCSIWSCAN]: Device or resource busy
> ioctl[SIOCSIWSCAN]: Device or resource busy
> and so on until I interrupt wpa_supplicant.
>
>>
>> Check whether CONFIG_CFG80211_WEXT is configured in your kernel (it should be).
>
> It is.
>
>>
>> Also ensure that you're not trying to use CCMP. orinoco only supports
>> WPA with TKIP encryption.
>
> wpa_supplicant.conf contains:
> network={
>        ssid="Comes"
>        psk="<password>"
>        key_mgmt=WPA-PSK
>        priority=5
>        proto=WPA
> }

Just had a closer look at your log. wpa_supplicant is clearing keys 4
and 5, which is why you're getting invalid arguments reported. This
shouldn't affect driver behaviour.

After that, something seems to go wrong with scanning. Try a plain
scan with wpa_supplicant turned off. Do you get any results?

iw dev eth1 scan
iwlist eth1 scan


Dave.
