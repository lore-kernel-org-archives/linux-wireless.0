Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab3AIQbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 11:31:49 -0500
Message-ID: <1357749133.9757.16.camel@jlt4.sipsolutions.net> (sfid-20130109_173152_787978_53ADDD5B)
Subject: Re: [PATCH] mac80211: fix delayed ADDBA response
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 09 Jan 2013 17:32:13 +0100
In-Reply-To: <50ED94F7.9000709@ti.com>
References: <1357654597-8493-1-git-send-email-victorg@ti.com>
	 <1357735100.9757.9.camel@jlt4.sipsolutions.net> <50ED94F7.9000709@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-09 at 18:04 +0200, Victor Goldenshtein wrote:
> On 09/01/13 14:38, Johannes Berg wrote:
> > Do we really want to allow arbitrary changes to the interfaces while
> > scanning? This could process a deauth frame for example, I'm worried
> > that might break things.
> >
> 
> Can you please elaborate why we shouldn't process deauth frames during 
> HW scan ? This fix was tested with our 18xx, don't see how it can break 
> things, but it's up to you whether to take it..

But did you test disassociating in the middle of the scan? I suspect
that some devices at least might have trouble with reprogramming the
device completely while it's scanning.

Maybe you can make this behaviour opt-in with a hardware flag?

johannes

