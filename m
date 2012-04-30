Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29968 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab2D3JPj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 05:15:39 -0400
Date: Mon, 30 Apr 2012 11:15:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: joseph daniel <josephdanielwalter@gmail.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/nfc: Fix the compilation warning
Message-ID: <20120430091536.GB31528@sortiz-mobl> (sfid-20120430_111554_792970_163BBA1D)
References: <1335771795-18961-1-git-send-email-josephdanielwalter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1335771795-18961-1-git-send-email-josephdanielwalter@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joseph,

On Mon, Apr 30, 2012 at 01:43:15PM +0600, joseph daniel wrote:
> the nfc_llcp_general_bytes is defined in nfc/core.c as
>     static inline u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, size_t *gb_len).
> 
> as in nfc/nfc.h:
>     static inline u8 *nfc_llcp_general_bytes(struct nfc_dev *dev, u8 *gb_len), as
>     CONFIG_NFC_LLCP is not defined.
> 
> so we got some warnings,
> net/nfc/core.c:207:2: warning: passing argument 2 of ‘nfc_llcp_general_bytes’ from incompatible pointer type [enabled by default]
> net/nfc/nfc.h:87:19: note: expected ‘u8 *’ but argument is of type ‘size_t *’
> 
> Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
Thanks, patch applied to my nfc-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
