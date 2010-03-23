Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:41396 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755094Ab0CWAmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 20:42:20 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-074054936
	for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 09:42:18 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Michael Stahn <m1kes@web.de>
Subject: Re: [Proposal]TX flags
Date: Tue, 23 Mar 2010 09:42:15 +0900
Cc: linux-wireless@vger.kernel.org
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com> <loom.20100322T194108-874@post.gmane.org>
In-Reply-To: <loom.20100322T194108-874@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003230942.15718.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 23 March 2010 04:32:21 Michael Stahn wrote:
> Regarding to this proposal I suggest this additional Radiotap feature
> to be standardised:
> 
> - Duration field shall not be recalculated ("No-Dur").
> 
> The approbiate mask for the Radiotap-Header would be 0x0020.
> The No-Dur flag is used when sending frames from the userspace
> to indicate that the frame already has its duration time
> preconfigured and should not be recalculated by low-level.
> This is useful for testing porpuses or tools like
> aireplay which trust on the "send out what you put in"-behaviour,
> especialliy on RTS-Frames, where duration-fields are reset to 0.
> If fragmentation is set (Bit 1, mask 0x08), duration-recalculation
> should be done after all because this would imply the given
> duration is reused for every subsequent fragment and there
> isn't an easy way to set different durations for all of them.

similar to this we would also need to be able to specify that the beacon TSF 
should not be overwritten. maybe a general flag like "do not change" would do?

bruno
