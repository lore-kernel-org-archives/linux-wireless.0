Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50458 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933853AbcLTS7H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 13:59:07 -0500
Date: Tue, 20 Dec 2016 11:59:05 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        justin@kuvee.com, Jaret Cantu <jaret.cantu@timesys.com>
Subject: Re: [PATCH 3/3] nfc: trf7970a: Prevent repeated polling from
 crashing the kernel
Message-ID: <20161220185905.GA5867@animalcreek.com> (sfid-20161220_200232_150396_5935B1D3)
References: <1482250592-4268-1-git-send-email-glansberry@gmail.com>
 <1482250592-4268-3-git-send-email-glansberry@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1482250592-4268-3-git-send-email-glansberry@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 20, 2016 at 11:16:32AM -0500, Geoff Lansberry wrote:
> From: Jaret Cantu <jaret.cantu@timesys.com>
> 
> Repeated polling attempts cause a NULL dereference error to occur.
> This is because the state of the trf7970a is currently reading but
> another request has been made to send a command before it has finished.

How is this happening?  Was trf7970a_abort_cmd() called and it didn't
work right?  Was it not called at all and there is a bug in the digital
layer?  More details please.

> The solution is to properly kill the waiting reading (workqueue)
> before failing on the send.

If the bug is in the calling code, then that is what should get fixed.
This seems to be a hack to work-around a digital layer bug.

Mark
--
