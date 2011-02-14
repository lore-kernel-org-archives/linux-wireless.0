Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47355 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755622Ab1BNPxh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 10:53:37 -0500
Subject: Re: [PATCH v2] iwlwifi: fix dma mappings and skbs leak
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1297693947-15310-1-git-send-email-sgruszka@redhat.com>
References: <1297693947-15310-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 07:51:36 -0800
Message-ID: <1297698696.4723.16.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-14 at 06:32 -0800, Stanislaw Gruszka wrote:
> Since commit commit 470058e0ad82fcfaaffd57307d8bf8c094e8e9d7
> "iwlwifi: avoid Tx queue memory allocation in interface down" we do
> not unmap dma and free skbs when down device and there is pending
> transfer. What in consequence may cause that system hung when
> performing shutdown at iptables module unload.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> v1 -> v2: do not claim patch fixes warning, which is still
> observable with patch applied
> 
>  drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   12 +++++-
>  drivers/net/wireless/iwlwifi/iwl-core.h   |    2 +
>  drivers/net/wireless/iwlwifi/iwl-tx.c     |   61 ++++++++++++++++++++--------
>  3 files changed, 56 insertions(+), 19 deletions(-)

Are you still seeing the "warning"

Wey

