Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62235 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758458Ab2K0Is1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 03:48:27 -0500
MIME-Version: 1.0
In-Reply-To: <1354004901.9576.4.camel@jlt4.sipsolutions.net>
References: <CAMz9Wg8y3JaJiEhsOz94viqpC4XXhQeE-eruBUGkXdY78-G=4A@mail.gmail.com>
	<1354004901.9576.4.camel@jlt4.sipsolutions.net>
Date: Tue, 27 Nov 2012 08:48:25 +0000
Message-ID: <CAHR064jC1rkHumt898XrfaFieu8PShRM7c_o6dxkPrp3Jb2W6A@mail.gmail.com> (sfid-20121127_094836_661004_3978BA64)
Subject: Re: A weird rfkill problem after rebooting the system
From: Corentin Chary <corentin.chary@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: AceLan Kao <acelan.kao@canonical.com>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>,
	acpi4asus-user <acpi4asus-user@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 27, 2012 at 8:28 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-11-27 at 14:35 +0800, AceLan Kao wrote:
>> Hi,
>>
>> I encountered a strange rfkill problem on the ASUS laptop.
>> But it's more like an rfkill issue to me, so I mail to the
>> linux-wireless mailing list and
>> CC'd to the maintainer of the asus-wmi driver.
>
> This totally sounds like a platform driver issue, adding that mailing
> list (left full text intact below). Nothing I can help you with.
>
> johannes
>
>> I attached 2 rfkill event log files.
>> 1. The first one(rfkill.0.log) is the driver we use currently,
>> you can see that I can soft block/unblock the devices by hitting the hotkey.
>> But the behavior is abnormal if I reboot the system with the devices blocked.
>> They are blocked after reboot is as expected.
>> But while I'm trying to unblock them, the phy0(the one keeps changing
>> its index) will become blocked.
>> So, there is no way to unblock the bt device by hitting hotkey.
>>
>> 2. The second log file is I try to remove the line from asus-wmi.c
>>    rfkill_init_sw_state(*rfkill, !result);
>> Then, it works after rebooting.
>> I suspect the problem comes from the line in rfkill_init_sw_state() function
>>    rfkill->persistent = true;

Well, persistent means:
"Whether the soft blocked state is initialised from non-volatile
storage at startup."
So if we call rfkill_init_sw_state(), that makes some sense

>> While calling rfkill_register() with persistent is false, then it'll
>> call rfkill_sync_work()
>> to set device block state, so that it prevents this issue.
>> But I'm not sure if my guess is correct and have no idea why it
>> doesn't need to this if persistent is true.
>> The persistent value seems doesn't affect the rfkill state that much
>> after reboot, the rfkill state is correct all the time.
>
>> BTW, the BIOS of this ASUS machine doesn't set the rfkill state while
>> we hit the hotkey.

We are missing some context here. What is the hotkey doing in userspace ?
Who owns this phy0 rfkill ? The asus platform driver, or the wireless driver ?
If it's the asus platform driver, why is it different from bluetooth ?
Something special done by the BIOS ? or the driver ?

--
Corentin Chary
http://xf.iksaif.net
