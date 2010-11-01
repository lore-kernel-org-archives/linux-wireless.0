Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62855 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab0KAUtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 16:49:22 -0400
Received: by ywc21 with SMTP id 21so1160913ywc.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 13:49:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288617770.20937.8.camel@chilepepper>
References: <1288181398-2358-1-git-send-email-eliad@wizery.com>
	<1288617770.20937.8.camel@chilepepper>
Date: Mon, 1 Nov 2010 22:49:21 +0200
Message-ID: <AANLkTi=Uo2uFZfg5rVjOopTPML49aHgwfFeStTDZbCk1@mail.gmail.com>
Subject: Re: [PATCH 1/2] wl1271: handle HW watchdog interrupt
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Luca,

On Mon, Nov 1, 2010 at 3:22 PM, Luciano Coelho <luciano.coelho@nokia.com> wrote:
>> unmask the WL1271_ACX_INTR_WATCHDOG interrupt.
>> when getting it - enqueue a recovery work and bail out.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> This looks good.  Just to clarify, the hardware is going to send this
> event when something goes wrong? What kind of situation triggers this
> event?
>

the WD is a simple timer that runs backward. when it gets to 0, the WD
interrupt is triggered.

normally, the firmware resets the timer when it's idle (every 500 msec
in the worst case).
thus, the WD will be triggered if the firmware is stuck (ASSERT /
endless loop) for about 2 seconds.

Eliad.
