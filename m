Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:36473 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab2LAPHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Dec 2012 10:07:43 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so1121253lag.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Dec 2012 07:07:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B946D9.6010902@lwfinger.net>
References: <CAG5aqJX6h7-aOBrq5pTNfBru7zmZji8hO+JqRC3eN0uXthAbLw@mail.gmail.com>
 <CAG5aqJV62_8eFJNQx=8R9gTYCRR4RbiaUks48oPRNm-Pq5DO=A@mail.gmail.com>
 <CAG5aqJWdxLf3X1+DsEiz4cpSnfo7JMsuEsMYPND8TPhUVag-Ww@mail.gmail.com> <50B946D9.6010902@lwfinger.net>
From: =?UTF-8?Q?Cengiz_G=C3=BCnay?= <cengique@users.sf.net>
Date: Sat, 1 Dec 2012 07:07:21 -0800
Message-ID: <CAG5aqJVw8Sw9PWAfG_cr0i9LcFvrJkuCje5G0x_Q8HBuL5XiPg@mail.gmail.com> (sfid-20121201_160747_437845_4FE6047C)
Subject: Re: rtl8723e droping the AP continuously for low signals; is there a
 threshold parameter?
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wlanfae <wlanfae@realtek.com>, linux-wireless@vger.kernel.org,
	lizhaoming <chaoming_li@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks for responding, Larry.

On Fri, Nov 30, 2012 at 3:52 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 11/30/2012 04:19 PM, Cengiz Günay wrote:
>> I did have to comment out IEEE80211_HW_BEACON_FILTER (line 320 in base.c)
>> to be able to compile your kernel driver for my 3.4 kernel, following the
>> description here:
>>
>> http://askubuntu.com/questions/139632/wireless-card-realtek-rtl8723ae-bt-is-not-recognized
>>
>
> That is a matter of the vendor driver. I deal with that driver only in that
> I use it as a starting point for the version built into the Linux kernel.
> Any build problems were fixed several months ago.

Oh, great! I didn't even know there was a newer driver. I should've
checked linux-wireless again.

> The first thing I request is that you try the version that will be added to
> kernel version 3.8 as it is the one I specifically support. It is currently
> available in the 3.7-rc7 versions of the linux-next, wireless-next, and
> wireless-testing git trees.

Ok, I will try this.


> The second thing is to report the signal strength at which the device fails.

Here's an example of the signal strength:
# iwconfig wlan0
wlan0     IEEE 802.11bgn  ESSID:**SD-HOTEL-AP**  [snip]
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:[snip]
          Bit Rate=18 Mb/s   Tx-Power=20 dBm
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=42/70  Signal level=-68 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:7   Missed beacon:0

This is particularly strong, but I have seen the link quality at 22/70
and signal at -88 dBm mostly.

> On my system, the driver runs without disconnection for days at a time;
> however, the signals are quite strong from my APs. Once I know where the
> difficulty happens, I can attenuate the signal.

Yes, I agree the driver works fine with high signal power as I use
this laptop at home without any problems. But it has consistently
failed in public places. There is a similar complaint in the Ubuntu
discussion page as well.

> Have you tried changing the power settings using the module parameters. I do
> not know what those are in the vendor driver, but in the kernel version, the
> pertiment ones are:
>
> parm:   ips:Set to 0 to not use link power save (default 1)
> parm:   swlps:Set to 1 to use SW control power save (default 0)
> parm:   fwlps:Set to 1 to use FW control power save (default 1)
>
> My suggestion is to disable link power saving with the "ips=0" option, or
> whatever the vendor driver uses.

Here's the vendor's parameters:
# modinfo rtl8723e
parm:  swlps:bool
parm:  swenc:using hardware crypto (default 0 [hardware]) (bool)
parm:  ips:using no link power save (default 1 is open) (bool)
parm:  fwlps:using linked fw control power save (default 1 is open) (bool)

I tried setting ips=0
# modprobe -v rtl8723e ips=0
insmod /lib/modules/3.4-trunk-amd64/kernel/drivers/net/wireless/rtlwifi/rtl8723e/rtl8723e.ko
ips=0

I still see drops, but I feel the connections is much more stable (I
was able to see a youtube video without interruption somehow):
# dmesg | grep lost | tail -5
[ 2945.567620] wlan0: Connection to AP [snip] lost.
[ 2949.565782] wlan0: Connection to AP [snip] lost.
[ 2954.555432] wlan0: Connection to AP [snip] lost.
[ 2972.499182] wlan0: Connection to AP [snip] lost.
[ 3156.474054] wlan0: Connection to AP [snip] lost.

Thanks,
-Cengiz
