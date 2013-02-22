Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59558 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab3BVEut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 23:50:49 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20774.63702.208829.602903@gargle.gargle.HOWL> (sfid-20130222_055054_194283_04A8276C)
Date: Fri, 22 Feb 2013 10:19:26 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [RFC] ath9k:  Detect and work-around tx-queue hang.
In-Reply-To: <5126F732.6040007@candelatech.com>
References: <1361498797-14361-1-git-send-email-greearb@candelatech.com>
	<20774.62475.588131.344540@gargle.gargle.HOWL>
	<5126F732.6040007@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> I'll be happy to test patches, but I'm not sure how to go about
> debugging the real problem on my own.  Maybe some stats could
> be added to the xmit debugfs file to help diagnose the problem,
> or maybe some other debugfs info will help?
> 
> I can't reproduce the problem with ath9k debugging set at the
> previous suggested level, so it would have to be something
> less invasive.
> 
> As for just stations going out of range, it remains locked up
> even with signal level goes back to -20, so it's not just a simple
> station-out-of range issues..

Sure, but I think that filtered frames are not handled properly,
especially with aggregation, since the debugfs stats from your earlier email
showed a large counter (from a private patch ?):

TXERR Filtered:            224          0         0         0

Sujith
