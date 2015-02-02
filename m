Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38918 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbbBBW0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 17:26:37 -0500
Received: by mail-ig0-f169.google.com with SMTP id hl2so20450518igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2015 14:26:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21708.14493.458370.65799@gargle.gargle.HOWL>
References: <1422311118-11320-1-git-send-email-poh@qca.qualcomm.com>
	<20150127213349.GA24933@localhost>
	<54C824DC.5080804@qca.qualcomm.com>
	<20150128043005.GB24933@localhost>
	<54C875FD.3070101@qca.qualcomm.com>
	<1422430643.1973.1.camel@sipsolutions.net>
	<54CC0B71.9050301@codeaurora.org>
	<21708.11481.380046.994311@gargle.gargle.HOWL>
	<54CC3640.2090209@codeaurora.org>
	<21708.14493.458370.65799@gargle.gargle.HOWL>
Date: Mon, 2 Feb 2015 14:26:36 -0800
Message-ID: <CAJ-Vmok9X7Zu67A3xnTKkBbLYPhrxqxRkv7EzKpPAnTOw6baVQ@mail.gmail.com> (sfid-20150202_232640_953290_7A7E1191)
Subject: Re: [PATCH] ath10k: Replace ioread with wmb for data sync
From: Adrian Chadd <adrian@freebsd.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Peter Oh <poh@codeaurora.org>, Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Peter Oh <poh@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 January 2015 at 18:06, Sujith Manoharan <sujith@msujith.org> wrote:
> Peter Oh wrote:
>> Please refer the email thread that I mentioned about other architectures.
>> (dsb is for ARM and other platforms have the equivalent instruction such
>> as sfence, sync, mf, and dcs).
>
> Ok.
>
>> Also the patch is updated with 2nd patch set replacing wmb to mb.
>
> Would be good to test this on a MIPS platform...
>

The Atheros mips74k stuff I have here does /not/ flush all the writes
out to the device and guarantee the device has seen everything with a
memory barrier. Just saying. Various drivers ended up needing
ioread()s in my experiments; mips sync operations weren't enough.

So I'd suggest abstracting it out like the linux dri i915 code has -
they define a "posting read" macro which they use whenever they need
to ensure it's definitely made it all the way out to the hardware and
through internal FIFOs so internal hardware has seen the state change.
Then you can redefine that to your hearts content based on platform.



-adrian
