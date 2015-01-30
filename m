Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37441 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbbA3SFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 13:05:30 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH V2 5/6] rtlwifi: btcoexist: Add routines for RTL8812AE kernel socket communications
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <54CBA0CE.8030800@lwfinger.net>
Date: Fri, 30 Jan 2015 10:05:24 -0800
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Troy Tan <troy_tan@realsil.com.cn>, netdev@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Message-Id: <B814EF26-CBC9-43E4-A6C9-761A013F85C1@holtmann.org> (sfid-20150130_190538_034930_6BAC627D)
References: <1422304934-9239-1-git-send-email-Larry.Finger@lwfinger.net> <1422304934-9239-6-git-send-email-Larry.Finger@lwfinger.net> <87h9v8zkuh.fsf@kamboji.qca.qualcomm.com> <EC423C22-AEA0-4232-A452-7A131C41780A@holtmann.org> <54CBA0CE.8030800@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

>>> I'm adding bluetooth list to the discussion. Full patch is available
>>> here:
>>> 
>>> https://patchwork.kernel.org/patch/5712591/

<snip>

>>> So the wireless driver communicates with the bluetooth driver (which is
>>> not in upstream) via a localhost UDP connection?
>> 
>> I think the first order of business should be to get the Bluetooth driver upstream. Until that has happened this is all kinda pointless discussion.
> 
> I agree with this; however, the last time I tried to submit a BT driver for Realtek, I was told that this driver should use some (as yet included) feature. I have watched the driver development, and if that feature was ever included, it was in a form that I did not recognize. I'm sorry that this is vague, but this happened a long time ago.

if the Bluetooth side is running over USB, then it should be driven from the existing btusb.ko module with a vendor specific ->setup() callback. However nothing materialized that I could merge it.

>>> I know there's a general need for something similar like this, but it
>>> needs to properly discussed and designed.
>> 
>> This is just insane. Clear NAK.
>> 
>> Two kernel modules will not use UDP ports over the loopback interface to communicate with each other.
> 
> I will work on combining the latest BT drivers from Realtek with btusb to see if I can achieve a patch that will both work with the Realtek hardware, and get approval from the reviewers.
> 
> What would be an approved method of communicating between two kernel modules? Is there some example in the kernel that I could study?

We need a btcoex subsystem that both WiFi and Bluetooth can register to and communicate with.

Regards

Marcel

