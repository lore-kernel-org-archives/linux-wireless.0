Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:57264 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbdHIVQY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 17:16:24 -0400
Date: Wed, 9 Aug 2017 14:16:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [v6] wlcore: add missing nvs file name info for wilink8
Message-ID: <20170809211620.GF3934@atomide.com> (sfid-20170809_231638_357760_ABB226EA)
References: <1502264840-10569-1-git-send-email-eyalr@ti.com>
 <8665E2433BC68541A24DFFCA87B70F5B36420E5A@DFRE01.ent.ti.com>
 <20170809172651.GA3934@atomide.com>
 <ngx9scofrw0qb2vkesion8v9.1502300336052@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ngx9scofrw0qb2vkesion8v9.1502300336052@email.android.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [170809 10:40]:
> Hi Tony,
> 
> Sorry for top posting (mobile...)
> I have verified with system design and the data sheet that every wilink 6/7 chip has a mac address in fuse so probably the board you have (pretty old, right?) has this mac address in fuse. Maybe it was from very early batches? Anyway I see no reason to change it.
> Anyway the calibrator can be used to store a different one into the nvs file that will overide it.

Well clearly at least this one does not have any valid hardware
mac address, the hardware mac address is broken with all zeroes.

It seems that you can easily add a check for empty mac address, no?
And you already showed a version that falls back to a random mac
address.

The fact that is old does not change a thing, we still need to
support it no matter what the data sheet and your system design
says. A fix that breaks other things is not really a fix :)

> I have verified using a couple of com6 modules with an am335x-evm and they had mac addresses read ok.

Sounds like there are multiple variants of the wl12xx
available then.

Regards,

Tony
