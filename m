Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3DKIWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 04:22:35 -0400
Message-ID: <1365668549.8272.9.camel@jlt4.sipsolutions.net> (sfid-20130411_102241_230797_BB58DA15)
Subject: Re: [Patch] mac80211: SMPS for AP Mode
From: Johannes Berg <johannes@sipsolutions.net>
To: vivekanandah@posedge.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 11 Apr 2013 10:22:29 +0200
In-Reply-To: <403b23c5df64cb4e0d6ffbabb7ca804f@posedge.com>
References: <516541FD.9050109@posedge.com>
	 <1365592730.8388.8.camel@jlt4.sipsolutions.net>
	 <403b23c5df64cb4e0d6ffbabb7ca804f@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vivek,

No worries.

> i have outlined three requirements based on my understanding for SMPS 
> code and have also incorporated a code snippet. if you are okay with the 
> code snippet, i will provide a patch for the same.
> 
> 1) check if the receiving station has Dynamic SMPS on
> 2) check if the current MCS rate is greater than a single stream rate 
> for the first rate

Note that MCS 32 is also single-stream. I'm not sure any driver supports
it, and I think minstrel_ht probably also doesn't support it, so I guess
you don't have to worry about it, but you may want to check.

> 3) if conditions 1 and 2 are true, set the RTS_CTS flag for the first 
> rate that will be attempted to be transmitted

No, you don't just need the first rate, you need any rate that's
multi-stream. Otherwise a retransmission at a lower rate would never
work.

johannes

