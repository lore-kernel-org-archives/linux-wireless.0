Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55749 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab1CJSye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 13:54:34 -0500
Received: by vxi39 with SMTP id 39so1804047vxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 10:54:33 -0800 (PST)
Message-ID: <4D791E57.1080003@lwfinger.net>
Date: Thu, 10 Mar 2011 12:54:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Chen, Xianwen" <xianwen.chen@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Status of Broadcom 4353?
References: <AANLkTimrW002Q86KWOdh0SYsZ5xLDve+gxmwehe4tc6N@mail.gmail.com>
In-Reply-To: <AANLkTimrW002Q86KWOdh0SYsZ5xLDve+gxmwehe4tc6N@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/10/2011 12:37 PM, Chen, Xianwen wrote:
> Hi there,
>
> Thanks for keeping up good work on wireless support in Linux all these
> years. I can still recall the joy when Realtek 8187 became part of
> kernel supported driver a few years ago -- it actually was the main
> reason I switched from NetBSD to Linux.
>
> I now have a laptop from my employer, on which I sneaked Linux in. The
> issue is that the wireless adapter seems not to be recognized:
>
> lspci -vnn | grep 14e4
>>> 02:00.0 Network controller [0280]: Broadcom Corporation Device [14e4:4353] (rev 01)
>
> Though the new Broadcom driver seems to be more appropriate, I
> actually compiled both the old and the new drivers. Further reading on
>    http://linuxwireless.org/en/users/Drivers/brcm8021
> and
>    http://wireless.kernel.org/en/users/Drivers/b43
> suggests that 4353 is not currently supported! :-(
>
> What is the current status of Broadcom 4353? I'm curious and actually
> eager to know. Any information will be appreciated!
>
> Have a good day fellas!

There are two ways that Broadcom chips are connected to a PCIe interface - one 
uses the SSB interconnect, and the other does not. In b43, only chips with SSB 
are supported. As the 4353 device does not use SSB, b43 does not work with it. 
Whether it ever will is being discussed.

You should use either the brcm80211 driver from compat-wireless or kernels 
2.6.37, or later. You may also use the wl driver from Broadcom if you are 
willing to run closed-source software. That driver does not use mac80211.

Larry
