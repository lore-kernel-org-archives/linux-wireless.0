Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41906 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751085AbcLXGBo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Dec 2016 01:01:44 -0500
Date: Fri, 23 Dec 2016 23:01:41 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        justin@kuvee.com, Jaret Cantu <jaret.cantu@timesys.com>
Subject: Re: [PATCH v3 3/3] nfc: trf7970a: Prevent repeated polling from
 crashing the kernel
Message-ID: <20161224060141.GA9069@animalcreek.com> (sfid-20161224_070219_509304_6C5079C4)
References: <1482380314-16440-1-git-send-email-geoff@kuvee.com>
 <1482380314-16440-3-git-send-email-geoff@kuvee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1482380314-16440-3-git-send-email-geoff@kuvee.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2016 at 11:18:34PM -0500, Geoff Lansberry wrote:
> From: Jaret Cantu <jaret.cantu@timesys.com>
> 
> Repeated polling attempts cause a NULL dereference error to occur.
> This is because the state of the trf7970a is currently reading but
> another request has been made to send a command before it has finished.
> 
> The solution is to properly kill the waiting reading (workqueue)
> before failing on the send.
> 
> Signed-off-by: Geoff Lansberry <geoff@kuvee.com>
> ---

You've still provided virtually no information on the actual problem(s)
nor justified why you think this is the best solution.  You're adding
code to a section of code that should _never_ be executed so the only
reasonable things I can infer is that there are, at least, two problems:

1) There is a bug causing execution to get into this block of code.

2) Once in this block of code, there is another bug.

You seem to be attempting to fix 2) and completely ignoring 1).
1) is the first bug that needs to be root-caused and fixed.

Also, what exactly is the "NULL dereference error" you mention?
Is this the neard crash you talked about in another thread or is
this a kernel crash?  If it is the kernel crash, please post the
relevant information.  If this is the neard crash - which seems
unlikely - then how can changing a section of kernel code that
shouldn't be executed in the first place fix that?

Mark
--
