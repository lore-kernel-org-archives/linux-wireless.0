Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:56475 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab0EHBSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 21:18:46 -0400
MIME-Version: 1.0
In-Reply-To: <20100507105059.GE3479@localhost>
References: <20100507105059.GE3479@localhost>
Date: Fri, 7 May 2010 21:18:44 -0400
Message-ID: <p2pb6c5339f1005071818u489804e7ud40fe3feb5459bb8@mail.gmail.com>
Subject: Re: ath5k deadlock w/ blob transfer
From: Bob Copeland <me@bobcopeland.com>
To: Nils Radtke <lkml@think-future.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 7, 2010 at 6:50 AM, Nils Radtke <lkml@think-future.de> wrote:
>  Hi,
>
>  Guess, this is better suited in here:
>>   - ath5k: when starting a blob transfer eg. ssh summer.jpg to the
>>     notebook with the ath5k driver running, the wNIC freezes almost
>>     immediately! Dead device. This is unfortunately too easily reproducible.

> So where should I be posting this?

You're in the right place...

> When both drivers deadlock it's either a common
> base in the wireless driver premisses or yet up the path somewhere in the
> kernel code.

(Or hardware.  madwifi doesn't use mac80211 so it is probably not
common code, but ath5k could have inherited a bug from it.)

> Ideas?

I missed the first email.  What type of machine?  System lockup
or the connection drops?  Do you get any output on the console or
in dmesg? (try switching to a text console before your scp test.)
If not, any output after lockup booting with nmi_watchdog=1?

-- 
Bob Copeland %% www.bobcopeland.com
