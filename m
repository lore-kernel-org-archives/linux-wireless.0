Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dmz4.indranet.co.nz ([203.97.93.68]:64744 "EHLO
	mail.indranet.co.nz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0DQVd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Apr 2010 17:33:28 -0400
Date: Sun, 18 Apr 2010 09:33:24 +1200 (NZST)
From: Derek Smithies <derek@indranet.co.nz>
To: Pavel Roskin <proski@gnu.org>
cc: Benoit Papillault <benoit.papillault@free.fr>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH] ath5k/ath9k: Fix 64 bits TSF reads
In-Reply-To: <1271452384.16507.16.camel@mj>
Message-ID: <alpine.DEB.2.00.1004180914300.4114@monster>
References: <1271369246-6892-1-git-send-email-benoit.papillault@free.fr> <1271452384.16507.16.camel@mj>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
  The original code was wrong, and there must have been occasions when the 
TSF was read incorrectly. Those occasions were infrequent, and would have 
show up in large networks that were operational on the month timescale.

Benoit's code tries 10 times to read the TSF, looking for when two 
consecutive upper TSF values that are the same. I can think of no physical 
scenario that would cause the 10 consecutive reads to not terminate.

If this fails to happen, then the TSF counter on the radio board is 
busted. If the TSF counter (or the reading of the TSF counter) is busted, 
then you have a bad situation, and something seriously wrong is happening.
We need to know about this - so the kernel warnings are good.

> The problem with overengineered code is that it doesn't break when it's
> better to break and expose the problem :-)
Yes, but the problem with underengineered code is that it doesn't break, 
and the users of the code are blissfully unaware of serious problems.

I would not call this overengineered. I would call this the appropriate 
level of peer review to get stable code that is acceptably reliable.

Benoit's patch is good.
ACK.

Derek.
========================================================================
On Fri, 16 Apr 2010, Pavel Roskin wrote:

> On Fri, 2010-04-16 at 00:07 +0200, Benoit Papillault wrote:
>
>> It follows the logic mentionned by Derek, with only 2 register reads
>> needed at each additional steps instead of 3 (the minimum number of
>> register reads is still 3).
>
> I would prefer an approach whereas tsf_upper2 or tsf_upper1 is chosen
> based on whether tsf_lower is more or less than 0x80000000 if
> (tsf_upper2 - tsf_upper1) is 1.  If the difference is not 0 or 1, either
> the hardware is broken or the kernel was stuck for so long (71 minutes!)
> that getting the exact tsf should be the least worry.  That's when
> WARN_ON would be appropriate.
>
> The problem with overengineered code is that it doesn't break when it's
> better to break and expose the problem :-)
>
> But it's just a suggestion, not a NACK.  It's better to have some fix
> than no fix at all.
>
>

-- 
Derek Smithies Ph.D.
IndraNet Technologies Ltd.
Email: derek@indranet.co.nz
ph +64 3 365 6485
Web: http://www.indranet-technologies.com/

