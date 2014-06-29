Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:55684 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaF2SbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 14:31:11 -0400
Received: by mail-oa0-f51.google.com with SMTP id j17so7812462oag.24
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2014 11:31:11 -0700 (PDT)
Message-ID: <53B05B72.1010502@lwfinger.net> (sfid-20140629_203116_212788_AA7A2293)
Date: Sun, 29 Jun 2014 13:31:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Talbut <jt@dpets.co.uk>, linux-wireless@vger.kernel.org
Subject: Re: Firmware loading with static kernel and initramfs
References: <53B049A3.7000803@dpets.co.uk>
In-Reply-To: <53B049A3.7000803@dpets.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2014 12:15 PM, John Talbut wrote:
> There seems to be a general problem when using a static kernel and initramfs in
> that the wireless drivers try to load firmware before the disks are mounted and
> the /lib/firmware folder is available.  Various people seem to have come across
> problems with firmware not loading, some of which seem to relate to this
> problem, which they have approached as if it is a problem with their particular
> driver.  However it seems to be a general problem and I have had it with three
> different drivers.
>
> There seems to be a number of possible approaches to this: loading the firmware
> in an initramfs; changing the sequence in which wireless drivers start so that
> they wait until the disks are mounted; compiling the firmware into the kernel
> and loading the firmware as part of ifup. I see that the latter has been done
> for one driver (http://thread.gmane.org/gmane.linux.kernel.wireless.general/3390).
>
> What is the current situation with this problem and what needs doing?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

What kernel version, and what wireless drivers have this problem?

At one point, there was a timeout of 30 seconds for request_firmware() calls, 
and that led to problems even when the drivers were built as modules. That 
situation was handled in a number of wireless drivers by using 
request_firmware_nowait(); however, my understanding was that user space was 
fixed to avoid the timeout. I think udev was the component that changed. What 
version of that are you using?

Larry

