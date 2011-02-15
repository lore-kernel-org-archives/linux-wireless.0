Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43249 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1BORVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 12:21:05 -0500
Received: by eye27 with SMTP id 27so255693eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 09:21:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D5AAC7C.6060509@lwfinger.net>
References: <AANLkTi=-KJ+OSvDGuxYvDYQZ2ZdS8G8obbvodOXd9zQD@mail.gmail.com>
 <AANLkTimTecR-W7iGzRWB_DxNVJoovK5SCuWfCmt8SUJo@mail.gmail.com>
 <AANLkTimx7=kYdWfe8FKL6oMyErE=3=GpXa-YrxkVVBG3@mail.gmail.com> <4D5AAC7C.6060509@lwfinger.net>
From: Ben Ruijl <benruyl@gmail.com>
Date: Tue, 15 Feb 2011 18:20:43 +0100
Message-ID: <AANLkTikKsjmKeNdi9ugiNX-1W5qBKdxw-KexEYLnZJ1p@mail.gmail.com>
Subject: Re: r8712u: packet loss
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

Thanks for your response. I didn't really know where to post the
issue. I won't be able to post the output of iwconfig to you until
Friday, since I don't have the usb stick right now. I can give you the
output of ifconfig, though:

wlan0     Link encap:Ethernet  HWaddr 00:0C:F6:9E:31:6B
          inet addr:192.168.1.3  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:f6ff:fe9e:316b/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:2848 errors:0 dropped:419 overruns:0 frame:0
          TX packets:2597 errors:0 dropped:119 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:2130344 (2.0 Mb)  TX bytes:527557 (515.1 Kb)

ben@PC_ONDER ~ $ ifconfig
wlan0     Link encap:Ethernet  HWaddr 00:0C:F6:9E:31:6B
          inet addr:192.168.1.3  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:f6ff:fe9e:316b/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:4415 errors:0 dropped:580 overruns:0 frame:0
          TX packets:3460 errors:0 dropped:119 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:4356319 (4.1 Mb)  TX bytes:635028 (620.1 Kb)

ben@PC_ONDER ~ $ ifconfig
wlan0     Link encap:Ethernet  HWaddr 00:0C:F6:9E:31:6B
          inet addr:192.168.1.3  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::20c:f6ff:fe9e:316b/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:4424 errors:0 dropped:582 overruns:0 frame:0
          TX packets:3468 errors:0 dropped:119 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:4358105 (4.1 Mb)  TX bytes:636067 (621.1 Kb)

I posted this in a topic on the arch linux forum
(https://bbs.archlinux.org/viewtopic.php?id=112120). There is also
another user with the same problems and he posted his ifconfig too.
lsusb -v recognizes the chipset as RTL8191su.

I hope this helps!

Ben

2011/2/15 Larry Finger <Larry.Finger@lwfinger.net>:
> On 02/15/2011 06:58 AM, Ben Ruijl wrote:
>>
>> I am experiencing packet loss of about 12 percent with the r8712u
>> staging driver with my WL-352v2 device. I'm not the only one with this
>> problem (https://bbs.archlinux.org/viewtopic.php?id=112120). I haven't
>> done a git bisect yet, but I know the problem is in both the 2.6.37
>> version and the latest version.
>
> Normally, you should not expect to get much help in this mailing list with a
> driver from staging. I assume that you have seen the warning that is placed
> in the dmesg output when you load a staging driver. You are fortunate in
> this case as I was the one that pushed this driver into staging.
>
> A bisection would not do much good as there have been few changes to the
> driver since it was included.
>
> Please describe your case more completely. List the output of iwconfig. I
> need this info as my device gets a ping packet loss of about 1%.
>
> Larry
>



-- 
Ben Ruijl
PGP 825472FC
