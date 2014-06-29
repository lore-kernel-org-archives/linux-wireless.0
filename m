Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mdfmta010.mxout.tch.inty.net ([91.221.169.51]:45116 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751920AbaF2TTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 15:19:05 -0400
Message-ID: <53B066A5.4070003@dpets.co.uk> (sfid-20140629_211910_106093_C0F6ABC3)
Date: Sun, 29 Jun 2014 20:19:01 +0100
From: John Talbut <jt@dpets.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Firmware loading with static kernel and initramfs
References: <53B049A3.7000803@dpets.co.uk> <53B05B72.1010502@lwfinger.net>
In-Reply-To: <53B05B72.1010502@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 29/06/14 19:31, Larry Finger wrote:
> On 06/29/2014 12:15 PM, John Talbut wrote:
>> There seems to be a general problem when using a static kernel and
>> initramfs in
>> that the wireless drivers try to load firmware before the disks are
>> mounted and
>> the /lib/firmware folder is available.  Various people seem to have
>> come across
>> problems with firmware not loading, some of which seem to relate to this
>> problem, which they have approached as if it is a problem with their
>> particular
>> driver.  However it seems to be a general problem and I have had it
>> with three
>> different drivers.
>>
>> There seems to be a number of possible approaches to this: loading the
>> firmware
>> in an initramfs; changing the sequence in which wireless drivers start
>> so that
>> they wait until the disks are mounted; compiling the firmware into the
>> kernel
>> and loading the firmware as part of ifup. I see that the latter has
>> been done
>> for one driver
>> (http://thread.gmane.org/gmane.linux.kernel.wireless.general/3390).
>>
>> What is the current situation with this problem and what needs doing?
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> What kernel version, and what wireless drivers have this problem?
>
> At one point, there was a timeout of 30 seconds for request_firmware()
> calls, and that led to problems even when the drivers were built as
> modules. That situation was handled in a number of wireless drivers by
> using request_firmware_nowait(); however, my understanding was that user
> space was fixed to avoid the timeout. I think udev was the component
> that changed. What version of that are you using?
>
> Larry
>
I originally had the problem with a Broadcom BCM43225 wireless.  This 
was with a 3.8 kernel.  This was solved by a patch to the kernel 
brcmsmac driver and this is still working with a 3.14 kernel.

Currently I have the problem with an Intel Centrino Wireless-N 130.  The 
problem was present with a 3.11 kernel and currently with a 3.14 kernel. 
  udev version 204-5linuxmint.

A friend seems to have the problem with a Realtek 8129se wireless but we 
are still checking out that this is the problem.

John
