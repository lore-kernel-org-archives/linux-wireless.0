Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:3694 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846Ab2GDMDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 08:03:37 -0400
Message-ID: <1341403410.1758.11.camel@x61.thuisdomein> (sfid-20120704_140341_085391_DD9BBD61)
Subject: Re: [PATCH] iwlegacy: don't mess up the SCD when removing a key
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 04 Jul 2012 14:03:30 +0200
In-Reply-To: <20120704114029.GC2570@redhat.com>
References: <1341228681-19358-1-git-send-email-emmanuel.grumbach@intel.com>
	 <20120704112208.GB2570@redhat.com>
	 <CANUX_P2gvyRejAmvW-BSxKaA7TG1s=KcRczwShb8+WtT9==L5w@mail.gmail.com>
	 <20120704114029.GC2570@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 13:40 +0200, Stanislaw Gruszka wrote:
> On Wed, Jul 04, 2012 at 02:33:48PM +0300, Emmanuel Grumbach wrote: 
> > Ok, but doest it solve the bug ?
> 
> CCing Poul.

Well I didn't see the queue-2-is-stuck error while testing that patch
for a few days (mostly by disconnecting and reconnecting to my wlan
through clicking a GUI applet).

That being said, since a day or two I'm again running without that patch
and also haven't noticed that error. So perhaps the jury's still out on
this patch ...

Maybe I should again try suspending and resuming in a loop. But that
raises the chance of suspend/resume bugs influencing the results.
Testing bugs like these (in network code, only triggered every now and
then) apparently isn't easy.

> But even if not, we still probably need that patch, right? Or is
> possible that 4965 firmware do not corrupt memory when we provide
> wrong key offset to it? Or maybe for 4965 key offset 0xff is something
> that is expected and needed to invalidate the key?


Paul Bolle

