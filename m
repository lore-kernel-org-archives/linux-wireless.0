Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26094 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab0FXE4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 00:56:44 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jun 2010 21:56:44 -0700
Date: Thu, 24 Jun 2010 10:26:36 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Pavel Roskin <proski@gnu.org>
CC: Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Fix the LED behaviour in idle unassociated
	state.
Message-ID: <20100624045636.GA19657@vasanth-laptop>
References: <1277275109-4662-1-git-send-email-vnatarajan@atheros.com> <1277315740.3562.6.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1277315740.3562.6.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 23, 2010 at 11:25:40PM +0530, Pavel Roskin wrote:
> On Wed, 2010-06-23 at 12:08 +0530, Vivek Natarajan wrote:
> > LED should be ON when the radio is put into FULL SLEEP mode during the idle
> > unassociated state.
> 
> Why?  Is there any written policy for the LED behavior?  I think we want
> to conserve power if sleeping, which means turning LEDs off.

There is no written policy for this behaviour, may be the comment
needs to be changed. It makes sense to turn off the LED to save
power but turning off the LED while wireless interface is still up
is kind of misleading, also this one we got as a requirement
internally and did not want to maintain any private patch.

> 
> Or is it a workaround for some quirk in Atheros hardware?

nope.

> 
> In any case, I don't like the new comment.  The comment says "Keep the
> LED on...", but the code is still turning the LED off.

yeah, this comment seems to be implicit. thanks for the review.

Vasanth
