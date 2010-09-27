Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64545 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618Ab0I0X2r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 19:28:47 -0400
Received: by bwz11 with SMTP id 11so3764826bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 16:28:46 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ignacy Gawedzki <i@lri.fr>
Subject: Re: A few questions about modifications in carl9170
Date: Tue, 28 Sep 2010 01:28:22 +0200
Cc: linux-wireless@vger.kernel.org
References: <20100927132957.GA2977@qubit.lri.fr> <201009271936.22261.chunkeey@googlemail.com> <20100927230137.GA5702@qubit.lri.fr>
In-Reply-To: <20100927230137.GA5702@qubit.lri.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009280128.23207.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 28 September 2010 01:01:37 Ignacy Gawedzki wrote:
> On Mon, Sep 27, 2010 at 07:36:21PM +0200, thus spake Christian Lamparter:
> > Sure, but why when you have a monotonic 40 MHz timer?
> 
> Glad to know there is such a thing, then. =)
or was it 80Mhz? Nevermind, the docs are not very specific.
 
> > > OK, I'll stick with the latest wireless-testing then.  BTW, I noticed that the
> > > FW API is 1.8.8.2, while driver API in wireless-testing is still 1.8.8.1.
> > Actually, the firmware is already at 1.8.8.3-pre. But it shouldn't matter if
> > what API "version" you are using, as long as the firmware descriptors and
> > command interface structs are the same.
> 
> Okay, I thought these API versions were there to be checked by the driver
> somehow for conformance.

They are... But only at the "highest" level ;)
Anyway, there's a bitfield which describe what commands, operation modes
and features are support by the firmware image.

> > > Having some stability issues with this combination, I reverted the last few
> > > commits in the FW's git back to API 1.8.8.1.  Are these different numbers
> > > nevertheless compatible with each other?
> > "Stability issues"? Again, a "vague" and stretchy term. Do you have "Oops" -
> > reports or something like that? 
> 
> Yeah, sorry for the vagueness, I promise I'll grab as much info as possible
> upon next encounter of such a thing.  As I remember it, it's mainly a matter
> of the module getting suck somehow (and attempts to unload it getting stuck as
> well) and the card not being detected upon subsequent insertions anymore.
I posted a few patches two hours ago. you should check out
"[PATCH] carl9170: fix hung workqueue", because it may be fixes the bug.

> I just tried the whole setup with the latest wireless-testing sources and your
> patch on the firmware.  So far, so good, the problems I had previously are not
> showing up.  I'm now just adapting your proposition to support rollover and
> conversion of the measurement to nanoseconds.
Rollover checks? Can you please tell me where you exactly see a potential rollover
problem in the proposal?
 
> One last question about your patch.  If a frame transmission fails altogether,
> i.e. the maximum attempts have been made and no ACK has been received
> whatsoever, will the driver get a tx_status with the overall timer spent
> serving that frame anyway (read: that's what I actually want)?
Currently not, but this can be achieved by moving the tsfl = get_clock_counter();
from __wlan_tx to _wlan_tx() and kill the one in wlan_tx_status.

Regards,
	Christian
