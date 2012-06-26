Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48903 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab2FZUel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 16:34:41 -0400
Received: by ghrr11 with SMTP id r11so364515ghr.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 13:34:41 -0700 (PDT)
Message-ID: <4FEA1CD9.4090307@lwfinger.net> (sfid-20120626_223445_913407_33870EA3)
Date: Tue, 26 Jun 2012 15:34:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Juho-Mikko Pellinen <juho-mikko.pellinen@iki.fi>
CC: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: Kernel Oops with 3.5-rc4 and zd1211rw (regression)
References: <4FE9FC2C.6040205@iki.fi>
In-Reply-To: <4FE9FC2C.6040205@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/26/2012 01:15 PM, Juho-Mikko Pellinen wrote:
> Hi!
>
> I just got this kernel oops the first time I compiled and booted 3.5-rc4
> . Oops message: http://i.imgur.com/oyIhy.jpg
> 3.4.x-series work just fine.
>
> The Oops happens when I log in to gdm. At that time Network Manager is
> already up and connected to network because I can ssh to the computer.
> Naturally after the crash wlan goes down and the computer is unreachable.
>
> The zd1211rw is an usb network card. I have also wlan card with the chip
> 'rtl8192ce' installed, but not activated because I'm experiencing
> problems with it.
>
> Attached are lspci, lsusb and dmesg from kernel 3.4.3.
> I will investigate later on the possibility of setting up netconsole and
> logging dmesg just before the crash.

This crash may be more general that the zd1211rw. I am also getting kernel 
panics in __netif_schedule with b43legacy for kernels 3.4.0 and 3.5-rc3 from 
wireless-testing. On this box, an RTL8187B works fine.

As reported here, the connection is OK until a heavy load is started. In my 
case, it was a package update command for my openSUSE distro.

Is there a possibility that this is still related to the single output queue 
problem, or does the zd1211rw have multiple queues?

Larry

