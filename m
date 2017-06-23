Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:34475 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbdFWSeO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 14:34:14 -0400
Date: Fri, 23 Jun 2017 13:34:11 -0500
From: Rob Herring <robh@kernel.org>
To: Mark Greer <mgreer@animalcreek.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] Revert "NFC: trf7970a: Handle extra byte in response
 to Type 5 RMB commands"
Message-ID: <20170623183411.tkwc2iuw7bmymkds@rob-hp-laptop> (sfid-20170623_203417_250303_C21E49EE)
References: <20170615174617.1817-1-mgreer@animalcreek.com>
 <20170615174617.1817-4-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170615174617.1817-4-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 15, 2017 at 10:46:17AM -0700, Mark Greer wrote:
> This reverts commit ab714817d7e891608d31f6996b1e4c43cf2bf342.
> 
> The original commit was designed to handle a bug in the trf7970a NFC
> controller where an extra byte was returned in Read Multiple Blocks (RMB)
> command responses.  However, it has become less clear whether it is a bug
> in the trf7970a or in the tag.  In addition, it was assumed that the extra
> byte was always returned but it turns out that is not always the case. The
> result is that a byte of good data is trimmed off when the extra byte is
> not present ultimately causing the neard deamon to fail the read.
> 
> Since the trf7970a driver does not have the context to know when to trim
> the byte or not, remove the code from the trf7970a driver all together
> (and move it up to the neard daemon).  This has the added benefit of
> simplifying the kernel driver and putting the extra complexity into
> userspace.
> 
> CC: Rob Herring <robh@kernel.org>
> CC: devicetree@vger.kernel.org
> Signed-off-by: Mark Greer <mgreer@animalcreek.com>
> ---
>  .../devicetree/bindings/net/nfc/trf7970a.txt       |  4 ----
>  drivers/nfc/trf7970a.c                             | 25 ++++------------------
>  2 files changed, 4 insertions(+), 25 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
