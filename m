Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31730 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243AbaLWPrm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 10:47:42 -0500
Date: Tue, 23 Dec 2014 17:47:38 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Christophe Prigent <christophe.prigent@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: Do not crash if platform data is not populated
Message-ID: <20141223154738.GM1314@lahna.fi.intel.com> (sfid-20141223_164758_649892_32D1D06F)
References: <1419346112-173303-1-git-send-email-mika.westerberg@linux.intel.com>
 <54998C31.9090500@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54998C31.9090500@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 23, 2014 at 04:37:21PM +0100, Arend van Spriel wrote:
> On 12/23/14 15:48, Mika Westerberg wrote:
> >The driver looks for pdata->oob_irq_supported to find out if wowl can be
> >supported. However, not all platforms populate pdata in which case we crash
> >the kernel because of NULL pointer dereference.
> 
> Thanks, Mika
> 
> However, this was already reported by Dan Carpenter and I submitted a patch
> for that a couple of days ago: "[PATCH 02/10] brcmfmac: Fix possible
> dereference of NULL pointer." [1].
> 
> Regards,
> Arend
> 
> [1]
> http://mid.gmane.org/1419162233-19492-3-git-send-email-arend@broadcom.com

Oh, good. I didn't notice that one.

Thanks for fixing it :)

BTW, that patch seems to miss brcmf_ops_sdio_resume(), perhaps it is
fixed in another patch?
