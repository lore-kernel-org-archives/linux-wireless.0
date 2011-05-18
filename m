Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46271 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab1EROdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 10:33:15 -0400
Received: by vxi39 with SMTP id 39so1131768vxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 07:33:14 -0700 (PDT)
Message-ID: <4DD3D8A7.7040605@lwfinger.net> (sfid-20110518_163319_351595_51E3D3F4)
Date: Wed, 18 May 2011 09:33:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Huijgen <mark.sf.net@huijgen.tk>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtlwifi rtl8192se kernel crash on link ready
References: <4DD37DF2.7060204@huijgen.tk>
In-Reply-To: <4DD37DF2.7060204@huijgen.tk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/18/2011 03:06 AM, Mark Huijgen wrote:
> Hi Larry,
>
> I tried the new rtlwifi/rtl8192se driver you recently added to wireless testing
> via compat-wireless-2011-05-16 on ubuntu 11.04.
>
> It loads fine and scanning works also. However as soon as I connect to an AP the
> kernel locks up and the system reboots.
> I tried ubuntu's linux crashdump tool to obtain the vmcore, but it seems to be
> broken (https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/710733).
>
> I was able to capture the crash output with my mobile phone's camera, quality is
> not great, but its readable.
>
> Its a kernel NULL pointer dereference in by the looks of it an IRQ handler.
>
> Kernel used is stock ubuntu 2.6.38-8-generic-pae, but I get a similar crash on
> older maverick kernel too (2.6.35-22-generic-pae).
>
> I hope this info is usefull enough to find the cause. If there is anything I can
> do to obtain more info let me know. Also happy to test any patches etc.

Mark,

This problem has to do with backporting of some rcu-handling code to 
compat-wireless, and is affecting a number of drivers. See the thread at 
http://marc.info/?l=linux-wireless&m=130570674417145&w=2 for some details. I 
added the linux-wireless mailing list to the Cc.

I'll let you know when a fix is available.

Larry
