Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:40759 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbbBNGqW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2015 01:46:22 -0500
Message-ID: <54DEEF3B.7060204@erley.org> (sfid-20150214_074659_285395_5A61C169)
Date: Sat, 14 Feb 2015 00:46:19 -0600
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Tim-Hinnerk Heuer <tim@heuer.nz>, linux-wireless@vger.kernel.org
Subject: Re: Fwd: Kernel 3.6.0 works, newer doesn't
References: <CAApG7tYL+9t729-VLiHhb5CqGvw3bxaH4czR+0wWwFF_iOjk_w@mail.gmail.com>	<20150213151910.GA8503@kroah.com> <CAApG7tbt_UDjnzRfCshR7pMMnug=vzdgtCSt8Pi+7dHMpri0aA@mail.gmail.com>
In-Reply-To: <CAApG7tbt_UDjnzRfCshR7pMMnug=vzdgtCSt8Pi+7dHMpri0aA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2015 09:58 PM, Tim-Hinnerk Heuer wrote:
> Hi can someone here help with this issue, please? I'm willing to give
> more info if necessary or help out otherwise. I am a programmer but
> haven't done much with Linux drivers yet.
>

First key is probably defining 'not working'.  Second key is likely to
be a dmesg output of it 'not working'.  Third detail that is likely to
help is what distribution you're running and how how you're attempting
to manage the wifi device(networkmanager/wicd/etc).

>
> Hi there,
>
> Sorry, I'm new to this list, so excuse my newbie question.
>
> I have Linux 3.6.0-030600-generic #201209302035 SMP Mon Oct 1 00:36:01
> UTC 2012 x86_64 x86_64 x86_64 GNU/Linux installed and it works great.
> My WLAN driver works with this version, but not with any newer version
> of the kernel. Am I right that backports can help me with that?
>
> Can I somehow upgrade to a newer version of the kernel and keep my
> WIFI USB driver and maybe even upgrade to newer kernels? Or even
> better, does someone here have the capacity to fix the problem in
> newer kernels?
>
> My Wifi USB Card is the
> Asus USB N13
>
> ```
> lsusb
> Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 006 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
>
> Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 004: ID 0b05:1784 ASUSTek Computer, Inc. USB-N13
> 802.11n Network Adapter (rev. A1) [Ralink RT3072]
>
> Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
>
> Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>
> sudo lsmod|grep rt
> xt_addrtype            12713  2
> x_tables               29846  6
> ip_tables,ipt_MASQUERADE,xt_conntrack,iptable_filter,xt_addrtype,iptable_nat
> rt2800usb              26998  0
> rt2x00usb              20762  1 rt2800usb
> rt2800lib              63557  1 rt2800usb
> rt2x00lib              55527  3 rt2x00usb,rt2800lib,rt2800usb
> mac80211              564631  3 rt2x00lib,rt2x00usb,rt2800lib
> cfg80211              212917  2 mac80211,rt2x00lib
> crc_ccitt              12667  1 rt2800lib
> parport_pc             32866  0
> parport                46562  3 lp,ppdev,parport_pc
> ```
>
> Running Ubuntu 14.04.
>
> Thanks for your patience.
> Tim
>
>
> ---------- Forwarded message ----------
> From: Greg KH <greg@kroah.com>
> Date: 14 February 2015 at 04:19
> Subject: Re: Kernel 3.6.0 works, newer doesn't
> To: Tim-Hinnerk Heuer <tim@heuer.nz>
> Cc: linux-usb@vger.kernel.org
>
>
> On Fri, Feb 13, 2015 at 11:20:33PM +1300, Tim-Hinnerk Heuer wrote:
>> Hi there,
>>
>> Sorry, I'm new to this list, so excuse my newbie question.
>>
>> I have Linux 3.6.0-030600-generic #201209302035 SMP Mon Oct 1 00:36:01
>> UTC 2012 x86_64 x86_64 x86_64 GNU/Linux installed and it works great.
>> My WLAN driver works with this version, but not with any newer version
>> of the kernel. Am I right that backports can help me with that?
>
> I suggest working with the driver authors of that driver to fix it to
> work with the latest kernel version.  It is merged into the main
> kernel.org repo, right?  Which one is it?
>
> The networking mailing list should be able to help you out the best, try
> sending this to the linux-wireless@vger.kernel.org
>
> hope this helps,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

