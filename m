Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:45828 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaF2WLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 18:11:17 -0400
Received: by mail-ob0-f170.google.com with SMTP id uz6so7962820obc.29
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2014 15:11:16 -0700 (PDT)
Message-ID: <53B08F07.3000308@lwfinger.net> (sfid-20140630_001120_707134_8542B0C6)
Date: Sun, 29 Jun 2014 17:11:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Talbut <jt@dpets.co.uk>, linux-wireless@vger.kernel.org
Subject: Re: Firmware loading with static kernel and initramfs
References: <53B049A3.7000803@dpets.co.uk> <53B05B72.1010502@lwfinger.net> <53B066A5.4070003@dpets.co.uk>
In-Reply-To: <53B066A5.4070003@dpets.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2014 02:19 PM, John Talbut wrote:
> I originally had the problem with a Broadcom BCM43225 wireless.  This was with a
> 3.8 kernel.  This was solved by a patch to the kernel brcmsmac driver and this
> is still working with a 3.14 kernel.

What sort of patch was that? Driver brcmsmac is still using request_firmware().

> Currently I have the problem with an Intel Centrino Wireless-N 130.  The problem
> was present with a 3.11 kernel and currently with a 3.14 kernel.  udev version
> 204-5linuxmint.

The current Intel drivers all use request_firmware_nowait(), but I'm not sure 
when they were changed.

> A friend seems to have the problem with a Realtek 8129se wireless but we are
> still checking out that this is the problem.

To my knowledge, there is no Realtek 8129se driver. Do you mean rtl8192se? If 
so, that one has used request_firmware_nowait() for some time.

Larry

