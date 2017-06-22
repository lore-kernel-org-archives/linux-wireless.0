Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14324 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753906AbdFVWf4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 18:35:56 -0400
Date: Fri, 23 Jun 2017 00:35:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: add NULL checks to avoid potential NULL pointer
 dereference
Message-ID: <20170622223553.GH21214@zurbaran.ger.intel.com> (sfid-20170623_003621_979374_9D01020B)
References: <20170530204307.GA3931@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170530204307.GA3931@embeddedgus>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 30, 2017 at 03:43:07PM -0500, Gustavo A. R. Silva wrote:
> NULL checks at line 457: if (!link0 || !link1) {, implies that both
> pointers link0 and link1 might be NULL.
> Function nfcsim_link_free() dereference pointers link0 and link1.
> Add NULL checks before calling nfcsim_link_free() to avoid a
> potential NULL pointer dereference.
> 
> Addresses-Coverity-ID: 1364857
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> ---
>  drivers/nfc/nfcsim.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
Applied, thanks.

Cheers,
Samuel.
