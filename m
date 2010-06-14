Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:27916 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab0FNWdC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 18:33:02 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1298626fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 15:33:00 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "David H. Lynch Jr." <dhlii@dlasys.net>
Subject: Re: CARL9170
Date: Tue, 15 Jun 2010 00:32:53 +0200
Cc: linux-wireless@vger.kernel.org
References: <4C169610.5020907@dlasys.net>
In-Reply-To: <4C169610.5020907@dlasys.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006150032.54095.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 June 2010 22:50:24 David H. Lynch Jr. wrote:
>      Many routines are coded to look like interrupt handlers, but the 
> code seems to be entirely polled ?
Hardware design decision.
(See "AR9170 STA Programming Guide" - Paragraph 3-3.)

>      Am I correct there ? If so do you know if the AR9170-fw code or 
> something else might show an example of interrupt handling for the 
> AR9170. I must have tx complete interrupts.
Well you have to "poll" the MAC's WLAN Status Registers (0x1c3510?) for
BIT(0)=TX COMP (and BIT(2) = TX FAIL) changes...
Or, if you are only sending one frame at a time, you might be able to poll
0x1c36d4 instead. Also you could decrease the maximum pending tx "interrupt"
timeout in 0x1c3d7c etc...

But if that does not satisfy your need for "real-time responsiveness", you
should contact Stephen Chen @ Atheros directly, maybe he knows a undocumented
feature register which enables real-time interrupt processing.

> Next there are remarks throught the driver and firmware regarding 
> cookies.
>      I think a cookie is a u8 that uniquely identifies a packet - is 
> that correct ?
>
>      In the firmware there is a remark somewhere that suguests that the 
> cookie AND something else are needed - is that correct or is the cookie 
> sufficient ?

This is because of historic reasons. In ar9170usb the driver had
use dirty tricks to get the AC_ID into the firmware's tx report.
So it could do some primitive frame lookup.

carl9170 driver still needs the AC_ID (but now) to reduce the frame lookup cost.
This is somewhat necessary because tx feedback is usually processed in a
critical section and when aggregation is enabled, it can be up to 16 frames
at any time...

regards,
	Chr
