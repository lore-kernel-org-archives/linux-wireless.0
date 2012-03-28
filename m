Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53311 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab2C1J0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:26:55 -0400
Message-ID: <1332926813.3479.21.camel@jlt3.sipsolutions.net> (sfid-20120328_112658_843921_9490785F)
Subject: Re: [RFC 2/2] mac80211: add improved HW queue control
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 28 Mar 2012 11:26:53 +0200
In-Reply-To: <20120328091811.239916419@sipsolutions.net> (sfid-20120328_111845_094703_FD6905EC)
References: <20120328091346.442543219@sipsolutions.net>
	 <20120328091811.239916419@sipsolutions.net>
	 (sfid-20120328_111845_094703_FD6905EC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-28 at 11:13 +0200, Johannes Berg wrote:
> plain text document attachment (028-mac80211-hw-queue-mgmt.patch)
> From: Johannes Berg <johannes.berg@intel.com>
> 
> 
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Oh my, I forgot to write the commit log, great ... Let's try that
now :-)


mac80211 currently only supports one hardware queue
per AC. This is already problematic for off-channel
uses since if we go off channel while the BE queue 
is full and then try to send an off-channel frame 
the frame will never go out. This will become worse
when we support multi-channel since then a queue on 
one channel might be full, but we have to stop the
software queue for all channels. That is obviously 
not desirable.

To address this problem allow drivers to register
more hardware queues, and allow them to map them to
virtual interfaces. When they stop a hardware queue
the corresponding AC software queues on the correct
interfaces will be stopped as well. Additionally,    
there's an off-channel queue to solve that problem
and a per-interface after-DTIM beacon queue. This
allows drivers to manage software queues closer to
how the hardware works.

Currently, there's a limit of 16 hardware queues.
This may or may not be sufficient, we can adjust it
as needed.



johannes

