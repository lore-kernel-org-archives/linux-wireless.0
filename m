Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3800 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab1KYN0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 08:26:52 -0500
Message-ID: <4ECF9789.2090703@broadcom.com> (sfid-20111125_142655_986894_61C0759A)
Date: Fri, 25 Nov 2011 14:26:33 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Haohui Liao" <liaohaohui@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Wireless stalled after a few minutes with Linux Kernel 3.1
References: <CAHW5WCL2V=wh43YYbiMo+rnh=-g4fobKEZHrCLvW03Q73=gzYA@mail.gmail.com>
 <4EC7E739.4080404@broadcom.com>
 <CAHW5WCLUefvgvRkgz7Nr+Rwu6_96t7EVVB33U0ED5g9a0cHFXw@mail.gmail.com>
In-Reply-To: <CAHW5WCLUefvgvRkgz7Nr+Rwu6_96t7EVVB33U0ED5g9a0cHFXw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/25/2011 02:18 PM, Haohui Liao wrote:
> Dear Arend van Spriel,
> 
> Sorry for my late reply.  I have attached my dmesg outout
> from Linux 3.0.7 (I am using Arch Linux 64 bit), the lsmod
> output for Linux 3.0.7, the lsmod output for Linux 3.1-4
> (the package for Arch Linux.  I believe the `-4' is just
> minor changes to configuration and compilation.  I have
> install the `-3' and `-4' and all of the have the stall problem)
> and the lspci output.
> 
>> Provide hardware info.
> 
> I am not sure if the attached files provide enough hardware
> information, please advise.
> 
>> Actually, this trace looks fine. The last message means
>> that no IPv6 capable network equipment has been
>> detected. Did you do unplug a USB device?
> 
> Yes, I have unplug the USB thumbdrive.  But I don't think
> unpluging a USB device.  Let me explain how the stall will
> happen.
> 
> The following is a portion of my wpa_supplicant.conf
> 
>     ssid="LINUX-LINK"
>     proto=WPA2
>     key_mgmt=WPA-PSK
>     pairwise=TKIP
>     group=TKIP
>     wpa_ptk_rekey=600
> 
> I didn't realise that `wpa_ptk_rekey=600' will actually change
> the wifi key every 10 minutes.  I just copy from the default
> wpa_supplicant.conf.  Later I read the description and I found
> that it is for the paranoid user who want really secure
> connection.  So I remove the wpa_ptk_rekey=600 and the
> connection will last longer for ath9k.  Sometimes a
> disconnection happened.  I found from Internet that nearby
> wifi interference can cause this problem.
> 
> This is fine with Linux 3.0.7.   However, during the
> wpa_ptk_rekey or during interference, the Linux 3.1 will
> stalled.  The only solution for me is to kill wpa_supplicant
> and restart it again.  I can always produce this phenomena
> with Linux 3.1, so I dare not install the Linux 3.1.1 kernel.
> I heard that Linux 3.2 has some improvements for ath9k
> but it is not available for ArchLinux yet, so I can't inform you
> if Linux 3.2 has a similar problem.
> 
> I understand that kernel debugging is an extremely
> difficult task.  Please advise me on what to do to provide
> useful info to you.
> 
> Thanks.
> 
> 
> Best Regards,
> Liao Haohui

Now I am confused. Looking in the lspci output I see you have an atheros
card, ie.:

02:00.0 Network controller: Atheros Communications Inc. AR928X Wireless
Network Adapter (PCI-Express) (rev 01)

So probably you are better off talking to someone at Atheros.

Gr. AvS

