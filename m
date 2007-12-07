Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51305 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbXLGBjc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 20:39:32 -0500
Subject: Re: [PATCH] iwlwifi3945/4965 - fix rate control algo reference leak
From: Zhu Yi <yi.zhu@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>,
	"John W.Linville" <linville@tuxdriver.com>
Cc: Thomas Tuttle <linux-kernel@ttuttle.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Wu <flamingice@sourmilk.net>,
	LWML <linux-wireless@vger.kernel.org>
In-Reply-To: <20071206093922.GA7356@cvg>
References: <20071206093922.GA7356@cvg>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 09:39:33 +0800
Message-Id: <1196991573.3170.43.camel@debian.sh.intel.com> (sfid-20071207_013937_263680_EE4114BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2007-12-06 at 12:39 +0300, Cyrill Gorcunov wrote:
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Subject: [PATCH] iwlwifi3945/4965 - fix rate control algo reference leak
> 
> This patch does fix rate control algo reference leak in case
> if network device has been failed to register. In this case
> special flag priv->mac80211_registered is not set and the
> rate algo reference is not freeing on module unload. That leads
> to OOPs in further ieee80211 rate register/unregister procedure
> (by any callee).
> 
> It should fix the bug #9470
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=9470
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
>  drivers/net/wireless/iwlwifi/iwl4965-base.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)

ACK. Thanks for the fix.

John, I think it should be in 2.6.24.

Thanks,
-yi
