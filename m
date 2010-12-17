Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51391 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab0LQTkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 14:40:06 -0500
Received: by wyb28 with SMTP id 28so1015255wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 11:40:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D0BADBE.40101@lwfinger.net>
References: <AANLkTikKtc4uiXN+oHwDr8sPFXZCe3HvTfYSvgZ8uYx0@mail.gmail.com>
	<4D0BADBE.40101@lwfinger.net>
Date: Fri, 17 Dec 2010 14:40:04 -0500
Message-ID: <AANLkTimvazto71m6SPMYtSAGuQkNpab+kMZcF4buNqYa@mail.gmail.com>
Subject: Re: rtl8192 does not see N networks in my building
From: Amos Blanton <amos.blanton@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's lspci output:

$ lspci -nn | grep Realtek
01:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
RTL8191SEvB Wireless LAN Controller [10ec:8172] (rev 10)
02:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev
03)
03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev
06)
lightnin@Buford:~$

iwlist:
lightnin@Buford:~$ iwlist scan
lo        Interface doesn't support scanning.

eth1      Interface doesn't support scanning.

eth0      Interface doesn't support scanning.

wlan0     No scan results

Here's iwconfig output, in case that is helpful:
wlan0     802.11bgn  Nickname:"rtl8191SEVA2"
          Mode:Managed  Frequency=2.462 GHz  Access Point: Not-Associated
          Bit Rate:300 Mb/s
          Retry:on   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=10/100  Signal level=0 dBm  Noise level=-100 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0



On Fri, Dec 17, 2010 at 1:36 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 12/17/2010 11:20 AM, Amos Blanton wrote:
>> Greetings. I have a rtl8192 in a Strata 13 laptop from Zareason
>> running Ubuntu 10.10, and I work in an environment with many Wifi
>> networks. With my previous laptop I was often able to see and
>> sometimes login to a local un-encrypted N network, the best we have
>> around here, but this one doesn't seem to find and display that
>> network via Network Manager.
>> I'm told my office has cisco ap1252s running the latest 7.0 code
>> release. There are B/G as well as N networks here, at least 10 that
>> Network manager will recognize.
>>
>> Sorry, I'm not sure what the relevant DMSG info is, so I'll include
>> the latest swath. Please let me know if I should get additional info,
>> and if this is the right place to report these issues.
>> Thanks to everyone here who helps make Linux wireless work!
>
> This is the right place to ask. The driver you are using is from staging, and I
> don't know much about it, but let's see what we can do.
>
> Please provide the output of the command '/sbin/lspci -nn | grep Realtek'.
>
> In addition, please post the output of the command 'sudo /usr/sbin/iwlist scan'.
> I'm guessing at the location of iwlist on your distro. If the command is not
> found, then the patch is wrong - change it to match your system.
>
> Larry
>
