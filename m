Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:59792 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbZAPS7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 13:59:43 -0500
Received: by bwz14 with SMTP id 14so5510246bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 10:59:41 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: garbaged AP mac address in dmesg in wireless-testing?
References: <3ace41890901160907w2d04da91r61744477ac64e018@mail.gmail.com>
	<20090116183826.GC10037@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 16 Jan 2009 20:59:38 +0200
In-Reply-To: <20090116183826.GC10037@tuxdriver.com> (John W. Linville's message of "Fri\, 16 Jan 2009 13\:38\:27 -0500")
Message-ID: <87ocy7xejp.fsf@litku.valot.fi> (sfid-20090116_195949_273331_4E44E426)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Fri, Jan 16, 2009 at 05:07:50PM +0000, Hin-Tak Leung wrote:
>> Since a few days ago, my dmesg is looking like this - instead of the
>> older AA:BB:CC:DD:EE:FF form
>> with the mac address of the AP.
>> That ffff88* looks like a pointer/address to me? Is this change intentional?
>> 
>> --------------
>> wlan2 direct probe responded
>> wlan2: authenticate with AP ffff880070995aa0
>> wlan2: authenticated
>> wlan2: associate with AP ffff880070995aa0
>> wlan2: RX ReassocResp from ffff88001431f01a (capab=0x431 status=0 aid=1)
>> wlan2: associated

Works for me:

[37125.111672] wlan0: authenticate with AP 00:12:17:e7:98:de
[37125.113509] wlan0: authenticated
[37125.113514] wlan0: associate with AP 00:12:17:e7:98:de
[37125.115875] wlan0: RX AssocResp from 00:12:17:e7:98:de (capab=0x11 status=0 aid=1)
[37125.115881] wlan0: associated

This is on x86 32bit with iwl3945 and latest wireless-testing.

> Odd...some problem with the "%pM" printk conversion?  What kernel
> are you running?

And on what architecture?

-- 
Kalle Valo
