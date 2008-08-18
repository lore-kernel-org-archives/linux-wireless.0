Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:46637 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYHROxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 10:53:32 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2177185fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2008 07:53:30 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [rt2x00] rt2800 progress update
Date: Mon, 18 Aug 2008 16:53:26 +0200
Cc: linux-wireless@vger.kernel.org
References: <200808181526.16974.IvDoorn@gmail.com>
In-Reply-To: <200808181526.16974.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808181653.27080.IvDoorn@gmail.com> (sfid-20080818_165335_471064_1B0EB977)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 18 August 2008, Ivo van Doorn wrote:
> Hi,
> 
> Just a small information mail regarding the current status of the rt2800 drivers,
> The initial schedule was that last week or at the latest this week, the initial
> version of the rt2800 drivers would be released.
> 
> But as you might have noticed, this has not happened, which means the project
> is behind schedule. The current status is that rt2800usb is capable of
> receiving frames (only when using the legacy driver first), and rt2800pci isn't
> capable of anything yet.
> 
> I am currently putting all focus on rt2800usb because the queue management
> is the easiest for that driver, and having that driver working will help in debugging
> rt2800pci later.
> 
> The fact that rt2800usb is capable of receiving frames after the legacy driver
> has been loaded first, means that I am missing one or two instructions which
> must be send to the hardware before it will kick in. Unfortunately I have made
> little progress in tracking that required instruction. :(

Well found it. Apparently the frames are only received when the BSSID is
written to the device. I currently get only 1 scan result now (the BSSID written
to the register), but in monitor mode I can see 2 AP's and a bunch of data going
through the air.

Well this is at least a start in the right direction, hopefully TX will work soon
as well.

Ivo
