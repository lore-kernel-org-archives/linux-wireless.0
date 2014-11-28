Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li271-223.members.linode.com ([178.79.152.223]:35127 "EHLO
	mail.mleia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaK1APH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 19:15:07 -0500
Message-ID: <5477BE85.70503@mleia.com>
Date: Fri, 28 Nov 2014 02:15:01 +0200
From: Vladimir Zapolskiy <vz@mleia.com>
MIME-Version: 1.0
To: =?UTF-8?B?SGFubm8gQsO2Y2s=?= <hanno@hboeck.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: firmware loading fails (iwl 7260)
References: <20141128004032.441c4670@pc>
In-Reply-To: <20141128004032.441c4670@pc>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28.11.2014 01:40, Hanno Böck wrote:
> Hi,
> 
> I have an X1 Carbon laptop with an intel 7260 chip.
> 
> The automatic firmware loading doesn't work (kernel 3.17.2). I get this
> in dmesg:
> [    1.615155] iwlwifi 0000:03:00.0: Direct firmware load for
> iwlwifi-7260-10.ucode failed with error -2
> 
> The firmware then gets loaded by the userspace helper, however as far
> as I understand it (and the description of the kernel option) this is
> deprecated and shouldn't be used. Also, it takes quite a while
> (minutes) till the wifi is available after boot which is quite annoying.
> 
> Any idea what I should do to debug/fix this? Is this a bug? (firmware
> is the latest from intel's page, 23.10.10.0)
> 

Most probably your rootfs is not yet mounted, when the driver attempts
to load the firmware file.

As a workaround try to compile iwlwifi as a module. When rootfs is
mounted, the module is loaded and the driver should pick up firmware.

--
With best wishes,
Vladimir
