Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751031AbcL1IKq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 03:10:46 -0500
Date: Wed, 28 Dec 2016 16:10:39 +0800
From: Peter Xu <peterx@redhat.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Intel Wireless 7260 failed to work
Message-ID: <20161228081039.GA3874@pxdev.xzpeter.org> (sfid-20161228_091114_247738_845D216C)
References: <20161227091706.GA20895@pxdev.xzpeter.org>
 <871swtkvdc.fsf@purkki.adurom.net>
 <20161228035959.GB3924@pxdev.xzpeter.org>
 <1482910035.8602.3.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1482910035.8602.3.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 28, 2016 at 09:27:15AM +0200, Luca Coelho wrote:

[...]

> > > > Is this a known issue? Please let me know if anyone wants more info or
> > > > logs, since this error triggers easily (everytime I boot).
> > > 
> > > The error message isn't really telling much to the user (hint hint) but
> > > I suspect this is by design:
> > > 
> > > "iwlwifi: remove support for fw older than -17 and -22
> 
> Right, we only maintain support for a certain number of firmware
> versions.  The FW APIs change with time and we don't want to keep all
> legacy code supporting old firmwares in the driver forever.
> 
> I agree that "no suitable firmware found!" is a bit scarce.  I'll see
> if we can improve that with something: "no suitable firmware found! You
> need iwlwifi-7260-17.ucode (<link to git>)".

That'll be great if we can have this info in the log. Maybe no need
for a full URL, the firmware name would suffice at least for me.

[...]

> I don't think we are very aggressive, we have been supporting -17 since
> v4.3:
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=5865f3658ba37c54e346b0fdee08a1c7a152681b
> 
> And we have published the firmware about half a year ago:
> 
> http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/commit/iwlwifi-7260-17.ucode?id=f2cf4d67e8eced29c8a473d3a27057aa2df57c42
> 
> I understand your concern, but if you want to be on the bleeding-edge
> kernel, you should be on the bleeding-edge linux-firmware as well. ;)

Fair enough. :-)

> 
> But as I said, I'll try to improve the error message, as that should
> make it easier to figure out.

Thank you!

-- peterx
