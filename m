Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48555 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759900Ab1CDRKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 12:10:07 -0500
Subject: Re: [PATCH 1/3] iwlwifi: move rx handlers code to iwl-rx.c
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
References: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 08:52:41 -0800
Message-ID: <1299257561.5082.145.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-04 at 08:51 -0800, Stanislaw Gruszka wrote:
> Put generic rx_handlers (except iwlagn_rx_reply_compressed_ba) to
> iwl-rx.c . Make functions static and change prefix from iwlagn_ to
> iwl_ . Beautify iwl_setup_rx_handlers and do some other minor coding
> style changes.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c |  235 -------------
>  drivers/net/wireless/iwlwifi/iwl-agn.c     |  176 ----------
>  drivers/net/wireless/iwlwifi/iwl-agn.h     |   13 +-
>  drivers/net/wireless/iwlwifi/iwl-core.c    |   63 ----
>  drivers/net/wireless/iwlwifi/iwl-core.h    |   18 +-
>  drivers/net/wireless/iwlwifi/iwl-rx.c      |  523 ++++++++++++++++++++++++++--
>  6 files changed, 500 insertions(+), 528 deletions(-)

> --
We want to do the minimum change during driver split, so after the
driver split, the iwlagn driver has the mixed iwl-agn-xxx and iwl-xxx
files. We need to do the clean up again. this patch is ok for now, but
we are planning to unify the filename and function name for iwlagn
driver soon.

Wey

Wey


