Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:37179 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751931AbdDAWL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Apr 2017 18:11:27 -0400
Date: Sun, 2 Apr 2017 00:11:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Vincent Cuissard <cuissard@marvell.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] NFC: nfcmrvl: double free on error path
Message-ID: <20170401221117.GD22034@zurbaran.ger.intel.com> (sfid-20170402_001136_166111_47D95906)
References: <20170308052237.GA14542@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170308052237.GA14542@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Wed, Mar 08, 2017 at 08:22:37AM +0300, Dan Carpenter wrote:
> The nci_spi_send() function calls kfree_skb(skb) on both error and
> success so this extra kfree_skb() is a double free.
> 
> Fixes: caf6e49bf6d0 ("NFC: nfcmrvl: add spi driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static analysis.  Not tested.
Applied to nfc-next, thanks.

Cheers,
Samuel.
