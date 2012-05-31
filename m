Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51867 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab2EaOjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 10:39:36 -0400
Received: by gglu4 with SMTP id u4so850352ggl.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 07:39:35 -0700 (PDT)
Message-ID: <4FC782A3.5040206@lwfinger.net> (sfid-20120531_163946_956502_D2F079F3)
Date: Thu, 31 May 2012 09:39:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Daniel Ackwonu <daniel.ackwonu@gmx.net>
CC: NetworkManager-list@gnome.org,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: WLAN
References: <4FC4944F.6080301@gmx.net> <4FC6A3B2.7030309@lwfinger.net> <4FC7487A.5050308@gmx.net>
In-Reply-To: <4FC7487A.5050308@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2012 05:31 AM, Daniel Ackwonu wrote:
> Thank you for answering!
>
> The Output of lspci -nn is:
>
> daniel@linzuntu:~$ lspci -nn
> 00:00.0 Host bridge [0600]: Advanced Micro Devices [AMD] Device [1022:1705]
> 00:01.0 VGA compatible controller [0300]: ATI Technologies Inc Device [1002:9647]
> 00:01.1 Audio device [0403]: ATI Technologies Inc Device [1002:1714]
> 00:02.0 PCI bridge [0604]: Advanced Micro Devices [AMD] Device [1022:1707]
> 00:04.0 PCI bridge [0604]: Advanced Micro Devices [AMD] Device [1022:1709]
> 00:05.0 PCI bridge [0604]: Advanced Micro Devices [AMD] Device [1022:170a]
> 00:06.0 PCI bridge [0604]: Advanced Micro Devices [AMD] Device [1022:170b]
> 00:10.0 USB Controller [0c03]: Advanced Micro Devices [AMD] Device [1022:7812]
> (rev 03)
> 00:10.1 USB Controller [0c03]: Advanced Micro Devices [AMD] Device [1022:7812]
> (rev 03)
> 00:11.0 SATA controller [0106]: Advanced Micro Devices [AMD] Device [1022:7804]
> 00:12.0 USB Controller [0c03]: Advanced Micro Devices [AMD] Device [1022:7807]
> (rev 11)
> 00:12.2 USB Controller [0c03]: Advanced Micro Devices [AMD] Device [1022:7808]
> (rev 11)
> 00:13.0 USB Controller [0c03]: Advanced Micro Devices [AMD] Device [1022:7807]
> (rev 11)
> 00:13.2 USB Controller [0c03]: Advanced Micro Devices [AMD] Device [1022:7808]
> (rev 11)
> 00:14.0 SMBus [0c05]: Advanced Micro Devices [AMD] Device [1022:780b] (rev 13)
> 00:14.1 IDE interface [0101]: Advanced Micro Devices [AMD] Device [1022:780c]
> (rev 40)
> 00:14.2 Audio device [0403]: Advanced Micro Devices [AMD] Device [1022:780d]
> (rev 01)
> 00:14.3 ISA bridge [0601]: Advanced Micro Devices [AMD] Device [1022:780e] (rev 11)
> 00:14.4 PCI bridge [0604]: Advanced Micro Devices [AMD] Device [1022:780f] (rev 40)
> 00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] Device [1022:1700] (rev
> 43)
> 00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] Device [1022:1701]
> 00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] Device [1022:1702]
> 00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] Device [1022:1703]
> 00:18.4 Host bridge [0600]: Advanced Micro Devices [AMD] Device [1022:1704]
> 00:18.5 Host bridge [0600]: Advanced Micro Devices [AMD] Device [1022:1718]
> 00:18.6 Host bridge [0600]: Advanced Micro Devices [AMD] Device [1022:1716]
> 00:18.7 Host bridge [0600]: Advanced Micro Devices [AMD] Device [1022:1719]
> 01:00.0 VGA compatible controller [0300]: ATI Technologies Inc Device [1002:6741]
> 02:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev 06)
> 03:00.0 Network controller [0280]: RaLink Device [1814:5390]
> 04:00.0 Class [ff00]: Realtek Semiconductor Co., Ltd. Device [10ec:5209] (rev 01)
> 04:00.1 SD Host controller [0805]: Realtek Semiconductor Co., Ltd. Device
> [10ec:5209] (rev 01)

Two points of mailing list etiquette:

(1) ALWAYS use the "Reply All" button - NEVER drop any list or individual. If 
your mailer does not have that feature, get a new mailer. People like me do what 
we can to help, but only if our exchange of information is in the public record. 
If you want private consulting, you need to pay for it.

(2) Do not top post. By placing your reply at the bottom, everyone can read in 
natural order. With your reply at the top, one has to scroll down an up.

Your wireless device is the one described by:
 > 03:00.0 Network controller [0280]: RaLink Device [1814:5390]

The appropriate driver for newer kernels is rt2800pci. As you did not provide 
any information regarding kernel or distro information, I have no idea if that 
driver is included in the configuration, or if your kernel is too old to have 
support for the 5390.

I suggest that you contact the mailing list for your distro and find out what it 
takes to support this device on their system. The latest versions of 
compat-wireless should work, but I have no idea if a precompiled version is 
available for your distro.

Larry
