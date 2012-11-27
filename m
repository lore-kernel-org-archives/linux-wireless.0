Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab2K0I14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 03:27:56 -0500
Message-ID: <1354004901.9576.4.camel@jlt4.sipsolutions.net> (sfid-20121127_092800_741246_3EE9785C)
Subject: Re: A weird rfkill problem after rebooting the system
From: Johannes Berg <johannes@sipsolutions.net>
To: AceLan Kao <acelan.kao@canonical.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Corentin Chary <corentin.chary@gmail.com>,
	linux-wireless@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	acpi4asus-user@lists.sourceforge.net
Date: Tue, 27 Nov 2012 09:28:21 +0100
In-Reply-To: <CAMz9Wg8y3JaJiEhsOz94viqpC4XXhQeE-eruBUGkXdY78-G=4A@mail.gmail.com> (sfid-20121127_073525_960060_6A8BC0D2)
References: <CAMz9Wg8y3JaJiEhsOz94viqpC4XXhQeE-eruBUGkXdY78-G=4A@mail.gmail.com>
	 (sfid-20121127_073525_960060_6A8BC0D2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 14:35 +0800, AceLan Kao wrote:
> Hi,
> 
> I encountered a strange rfkill problem on the ASUS laptop.
> But it's more like an rfkill issue to me, so I mail to the
> linux-wireless mailing list and
> CC'd to the maintainer of the asus-wmi driver.

This totally sounds like a platform driver issue, adding that mailing
list (left full text intact below). Nothing I can help you with.

johannes

> I attached 2 rfkill event log files.
> 1. The first one(rfkill.0.log) is the driver we use currently,
> you can see that I can soft block/unblock the devices by hitting the hotkey.
> But the behavior is abnormal if I reboot the system with the devices blocked.
> They are blocked after reboot is as expected.
> But while I'm trying to unblock them, the phy0(the one keeps changing
> its index) will become blocked.
> So, there is no way to unblock the bt device by hitting hotkey.
> 
> 2. The second log file is I try to remove the line from asus-wmi.c
>    rfkill_init_sw_state(*rfkill, !result);
> Then, it works after rebooting.
> I suspect the problem comes from the line in rfkill_init_sw_state() function
>    rfkill->persistent = true;
> While calling rfkill_register() with persistent is false, then it'll
> call rfkill_sync_work()
> to set device block state, so that it prevents this issue.
> But I'm not sure if my guess is correct and have no idea why it
> doesn't need to this if persistent is true.
> The persistent value seems doesn't affect the rfkill state that much
> after reboot, the rfkill state is correct all the time.
> 
> BTW, the BIOS of this ASUS machine doesn't set the rfkill state while
> we hit the hotkey.
> 
> Best regards,
> AceLan Kao.
> 


