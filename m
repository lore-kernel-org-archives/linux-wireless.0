Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout7.freenet.de ([195.4.92.97]:36014 "EHLO mout7.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab1KNS1B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 13:27:01 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout7.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #5)
	id 1RQ1FC-000450-5M
	for linux-wireless@vger.kernel.org; Mon, 14 Nov 2011 19:26:58 +0100
Received: from localhost ([::1]:43017 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RQ1FB-0005PP-U1
	for linux-wireless@vger.kernel.org; Mon, 14 Nov 2011 19:26:58 +0100
Received: from [195.4.92.28] (port=52563 helo=18.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RQ1D7-0000MY-Nq
	for linux-wireless@vger.kernel.org; Mon, 14 Nov 2011 19:24:49 +0100
Received: from p4fde1186.dip0.t-ipconnect.de ([79.222.17.134]:44725 helo=mail.maya.org)
	by 18.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RQ1D7-00019Q-1j
	for linux-wireless@vger.kernel.org; Mon, 14 Nov 2011 19:24:49 +0100
Message-ID: <4EC15D4F.1010207@dualc.maya.org> (sfid-20111114_192706_365688_AAC838B8)
Date: Mon, 14 Nov 2011 19:26:23 +0100
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: users@rt2x00.serialmonkey.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Try to narrow down the problem with rt2800usb and rt3572 based
 USB WLAN devices
References: <4EBEA616.2020002@01019freenet.de> <CAGXE3d8X8N9VVLZCmyyGrwVhD-3BQJKcnY=nWmE+0h68dnWMBg@mail.gmail.com>
In-Reply-To: <CAGXE3d8X8N9VVLZCmyyGrwVhD-3BQJKcnY=nWmE+0h68dnWMBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Helmut,

Helmut Schaa schrieb:
> On Sat, Nov 12, 2011 at 6:00 PM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
>> Could anybody please try to explain this behavior, or even better, fix
>> it (it looks really broken to me)?
> 
> AFAIK it is possible to aggregate  multiple frames into one URB
> for rt2800 USB devices. However, rt2800usb doesn't make use
> of this yet while the legacy driver does.

Hmm, could this be the reason, why the device gets extremely hot during
operation, especially when used in monitor mode (with airmon-ng)?
Oh, I just remember, that during my "seven more packets" sniffing, the
monitor mode of this device stalled after a few minutes. Probably the
same reason why it doesn't work very well (respectively stalls
completely) during normal mode.

One more thing:
At the moment, the tcp data transfer stalls, no more usb packets can be
seen ... .

> However, I don't think that
> this is the cause for the poor performance you see ...

Is it normal, that the device gets fired up with submits without waiting
for any answers? The usb handling with the legacy driver is absolutely
regular (submit / complete / submit / complete), the handling with the
rt2800usb driver just looks totally messy to me (the urb ids of the
submit / completes don't fit any more, even the "complete" comes before
the "submit" (see package 83056 and 83062) ?!).


Thanks for your explanation,
Andreas
