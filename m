Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54523 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3FFVR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 17:17:57 -0400
Date: Thu, 6 Jun 2013 14:17:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Joe Lawrence <joe.lawrence@stratus.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	stable@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>
Subject: Re: stop_machine lockup issue in 3.9.y.
Message-ID: <20130606211752.GG5045@htj.dyndns.org> (sfid-20130606_231800_888644_69F3503D)
References: <51AF8D4B.4090407@candelatech.com>
 <51AF91F5.6090801@candelatech.com>
 <51AFA677.9010605@candelatech.com>
 <20130605211157.GK10693@mtj.dyndns.org>
 <1370482492.24311.308.camel@edumazet-glaptop>
 <20130606031444.GA12335@mtj.dyndns.org>
 <1370489181.24311.318.camel@edumazet-glaptop>
 <51B004CD.6080007@candelatech.com>
 <20130606205514.GC5045@htj.dyndns.org>
 <51B0FBFC.8040809@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51B0FBFC.8040809@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 06, 2013 at 02:15:40PM -0700, Ben Greear wrote:
> >First of all, kudos for tracking the issue down.  While the removal of
> >looping limit in softirq handling was the direct cause for making the
> >problem visible, it's very bothering that we have softirq runaway.
> >Finding out the perpetrator shouldn't be hard.  Something like the
> >following should work (untested).  Once we know which softirq (prolly
> >the network one), we can dig deeper.
> 
> The patch below assumes my fix is not in the code, right?

Yeap.

> I'll work on this, but it will probably be next week before
> I have time...gotta catch up on some other things first.

Thanks a lot for hunting this down!

-- 
tejun
