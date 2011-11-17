Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37808 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab1KQTUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 14:20:23 -0500
Received: by bke11 with SMTP id 11so2434210bke.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 11:20:21 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: users@rt2x00.serialmonkey.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Re: Try to narrow down the problem with rt2800usb and rt3572 based USB WLAN devices
Date: Thu, 17 Nov 2011 20:20:13 +0100
Message-ID: <4540730.yCbFJVVBHk@helmutmobil.site> (sfid-20111117_202026_707040_74C56E62)
In-Reply-To: <4EC15D4F.1010207@dualc.maya.org>
References: <4EBEA616.2020002@01019freenet.de> <CAGXE3d8X8N9VVLZCmyyGrwVhD-3BQJKcnY=nWmE+0h68dnWMBg@mail.gmail.com> <4EC15D4F.1010207@dualc.maya.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 14. November 2011, 19:26:23 schrieb Andreas Hartmann:
> Hello Helmut,
> 
> Helmut Schaa schrieb:
> > On Sat, Nov 12, 2011 at 6:00 PM, Andreas Hartmann
> > <andihartmann@01019freenet.de> wrote:
> >> Could anybody please try to explain this behavior, or even better, fix
> >> it (it looks really broken to me)?
> > 
> > AFAIK it is possible to aggregate  multiple frames into one URB
> > for rt2800 USB devices. However, rt2800usb doesn't make use
> > of this yet while the legacy driver does.
> 
> Hmm, could this be the reason, why the device gets extremely hot during
> operation, especially when used in monitor mode (with airmon-ng)?

Interesting, maybe this is related, yes. Not sure though.

> Oh, I just remember, that during my "seven more packets" sniffing, the
> monitor mode of this device stalled after a few minutes. Probably the
> same reason why it doesn't work very well (respectively stalls
> completely) during normal mode.
> 
> One more thing:
> At the moment, the tcp data transfer stalls, no more usb packets can be
> seen ... .
> 
> > However, I don't think that
> > this is the cause for the poor performance you see ...
> 
> Is it normal, that the device gets fired up with submits without waiting
> for any answers? The usb handling with the legacy driver is absolutely
> regular (submit / complete / submit / complete), the handling with the
> rt2800usb driver just looks totally messy to me (the urb ids of the
> submit / completes don't fit any more, even the "complete" comes before
> the "submit" (see package 83056 and 83062) ?!).

Unfortunately I don't know the rt2800 USB code very well but the tx status
handling was changed some time ago to read the TX_STA_FIFO register
asynchronously ...

Helmut

> 
> Thanks for your explanation,
> Andreas
