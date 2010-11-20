Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33922 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab0KTCZr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 21:25:47 -0500
Received: by iwn34 with SMTP id 34so264890iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 18:25:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CE720A1.3090408@candelatech.com>
References: <4CE720A1.3090408@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 19 Nov 2010 18:25:25 -0800
Message-ID: <AANLkTikybBepddauBrtJzPmdRB1E7Qqsy9y+Xxz08k6+@mail.gmail.com>
Subject: Re: ath9k very unstable and kills file-system.
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 19, 2010 at 5:13 PM, Ben Greear <greearb@candelatech.com> wrote:
> It's been another frustrating week for using ath9k.
>
> With a patched wpa_supplicant (found here:
> https://github.com/greearb/hostap-ct/tree/)
> I can reliably cause ath9k to spew all sorts of DMA warnings
> and evidently crash the hard-drive controller and/or corrupt the
> file system so bad that fsck cannot fix it.  (Back up anything you
> want to keep before attempting to reproduce this.)
>
> The test case is simply create 30 or so STA interfaces, run one instance
> of the patched wpa_supplicant to control the 30 interfaces, and send
> a bit of traffic across the interfaces.  It's not even needed to send
> any significant data...probably just the supplicant associate logic
> is enough.
>
> You'll want the xmit locking patch Felix posted or it will likely spew
> lockdep warnings and/or lockup before it gets a chance to crash your
> hard drive.
>
> There are no other /n NICs that can do virtual stations, so I must
> either get ath9k functional or give up on that feature set entirely.
>
> If anyone wants to help with this and cannot easily reproduce it,
> please let me know and I'll furnish scripts etc to make it easier
> to reproduce.
>
> I'm also happy to help test patches.

If you can provide scripts it will help. The easier it is to reproduce
the easier it can get fixed.

 Luis
