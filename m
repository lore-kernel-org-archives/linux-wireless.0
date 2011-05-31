Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55205 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab1EaDPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 23:15:35 -0400
Received: by vxi39 with SMTP id 39so2991384vxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 20:15:34 -0700 (PDT)
Message-ID: <4DE45D54.9050301@lwfinger.net> (sfid-20110531_051603_190710_52E73DDA)
Date: Mon, 30 May 2011 22:15:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	Mike McCormack <mikem@ring3k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192se replacing rtl8192e?
References: <1306791271.4277.39.camel@localhost>
In-Reply-To: <1306791271.4277.39.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/30/2011 04:34 PM, Ben Hutchings wrote:
> I'm happy to see rtl8192se in Linux 3.0-rc1.  I noticed that it claims
> PCI device ID 10ec:8192, which is already claimed by staging driver
> rtl8192e.  Is it intended to replace that driver, or are there two
> different devices with that ID which they will distinguish in their
> probe functions?
>
> If is intended to replace rtl8192e, shouldn't it also claim these device
> IDs?
>
> 	/* Corega */
> 	{ PCI_DEVICE(0x07aa, 0x0044) },
> 	{ PCI_DEVICE(0x07aa, 0x0047) },

The RTL8192E is a different device than the RTL8192SE, thus rtl8192se will not 
replace rtl8192e. The way to tell them apart is the PCIe revision id. At 
present, I don't have a method to use that info to load the correct driver, but 
I will be working on it. In addition, I need to acquire an RTL8192E.

No, rtl8192se should not claim those Corega devices.

Larry
