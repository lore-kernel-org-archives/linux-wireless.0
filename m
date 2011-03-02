Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37333 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756459Ab1CBUPm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 15:15:42 -0500
Subject: Re: [PATCH v3 5/5] iwlwifi: move remaining iwl-agn-rx.c code into
 iwl-rx.c
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1298899997-2372-5-git-send-email-sgruszka@redhat.com>
References: <1298899997-2372-1-git-send-email-sgruszka@redhat.com>
	 <1298899997-2372-5-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 12:00:09 -0800
Message-ID: <1299096009.5082.127.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Mon, 2011-02-28 at 05:33 -0800, Stanislaw Gruszka wrote:
> There is no need to have separate iwl-agn-rx.c file after iwlegacy
> split.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/Makefile     |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-agn-rx.c |  264 -----------------------------
>  drivers/net/wireless/iwlwifi/iwl-core.h   |    2 -
>  drivers/net/wireless/iwlwifi/iwl-rx.c     |  226 ++++++++++++++++++++++++-
>  4 files changed, 225 insertions(+), 269 deletions(-)
>  delete mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-rx.c
> 
I got the following warning:

drivers/net/wireless/iwlwifi/iwl-rx.c:506:6: warning: symbol
'iwl_rx_statistics' was not declared. Should it be static?
drivers/net/wireless/iwlwifi/iwl-rx.c:575:6: warning: symbol
'iwl_reply_statistics' was not declared. Should it be static?
drivers/net/wireless/iwlwifi/iwl-rx.c:600:6: warning: symbol
'iwl_rx_missed_beacon_notif' was not declared. Should it be static?


when I compile with sparse

Thanks
Wey

