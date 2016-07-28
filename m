Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:47874 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbcG1BW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 21:22:59 -0400
Date: Thu, 28 Jul 2016 02:22:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: alexmcwhirter@triadic.us
Cc: David Miller <davem@davemloft.net>, rlwinm@sdf.org,
	chunkeey@googlemail.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Al Viro <viro@ftp.linux.org.uk>
Subject: Re: PROBLEM: network data corruption (bisected to e5a4b0bb803b)
Message-ID: <20160728012253.GT2356@ZenIV.linux.org.uk> (sfid-20160728_032303_922270_9938C9CC)
References: <201607271032.u6RAWPcS008174@sdf.org>
 <4dbfebe8136bc963b5b51463d6887db4@triadic.us>
 <87c4ed555bcb4229f2334f6f2bb69bcb@triadic.us>
 <20160727.164543.1466564919313003461.davem@davemloft.net>
 <20160728003102.GS2356@ZenIV.linux.org.uk>
 <8b3126f66186015956e0f8090fb70532@triadic.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8b3126f66186015956e0f8090fb70532@triadic.us>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 27, 2016 at 08:26:48PM -0400, alexmcwhirter@triadic.us wrote:

> I'm going to go ahead and say this is where my issue and the op's issue
> begin to branch apart from one another. He's seeing this on all incoming
> data, whereas i am only seeing it on ssl data and not on sun4v.
> 
> At this point i would say data from my issue is only going to cloud this
> issue as they seem to be two completely different issues revolving around
> the same commit. If i come across any relevant data for x86_64 ill be sure
> to post it if this isn't resolved by then, but for now i'm going to refrain
> from submitting anything sparc related.

Which just might mean that we have *three* issues here -
	(1) buggered __copy_to_user_inatomic() (and friends) on some sparcs
	(2) your ssl-only corruption
	(3) Alan's x86_64 corruption on plain TCP read - no ssl *or* sparc
anywhere, and no multi-segment recvmsg().  Which would strongly argue in
favour of some kind of copy_page_to_iter() breakage triggered when handling
a fragmented skb, as in (1).  Except that I don't see anything similar in
x86_64 uaccess primitives...
