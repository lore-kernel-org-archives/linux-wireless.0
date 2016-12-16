Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49190 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753132AbcLPBSZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 20:18:25 -0500
Date: Thu, 15 Dec 2016 18:18:23 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        justin@kuvee.com, Jaret Cantu <jaret.cantu@timesys.com>
Subject: Re: [PATCH 3/3] nfc: trf7970a: Prevent repeated polling from
 crashing the kernel
Message-ID: <20161216011823.GC25227@animalcreek.com> (sfid-20161216_021851_393303_1B11258A)
References: <1481841044-4314-1-git-send-email-glansberry@gmail.com>
 <1481841044-4314-3-git-send-email-glansberry@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1481841044-4314-3-git-send-email-glansberry@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2016 at 05:30:44PM -0500, Geoff Lansberry wrote:
> From: Jaret Cantu <jaret.cantu@timesys.com>
> 
> Repeated polling attempts cause a NULL dereference error to occur.
> This is because the curent state of the trf7970a is reading but
> a request has been made to send a command.
> 
> The solution is to properly kill the waiting reading (workqueue)
> before failing on the send.

Maybe its just me but I find this description a little hard to grok.
Mind reworking it?

The patch itself looks fine.

Thanks,

Mark
--
