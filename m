Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13600 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544Ab1BYRNI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 12:13:08 -0500
Subject: Re: [PATCH 3/3] iwlwifi: ack,plcp check health changes
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1298649432-4416-3-git-send-email-sgruszka@redhat.com>
References: <1298649432-4416-1-git-send-email-sgruszka@redhat.com>
	 <1298649432-4416-3-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 08:58:09 -0800
Message-ID: <1298653089.28351.26.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-25 at 07:57 -0800, Stanislaw Gruszka wrote:
> Add module ack_check, and plcp_check parameters, Ack_check is disabled
> by default since is proved that check ack health can cause troubles.
> Plcp_check is enabled by default.
> 
> Remove iwl_lib_ops methods, they are unneeded after iwlegacy driver
> split. Merge check health code into to iwl-rx.c and make functions
> static.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-1000.c    |    2 -
>  drivers/net/wireless/iwlwifi/iwl-2000.c    |    2 -
>  drivers/net/wireless/iwlwifi/iwl-5000.c    |    4 -
>  drivers/net/wireless/iwlwifi/iwl-6000.c    |    4 -
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 +
>  drivers/net/wireless/iwlwifi/iwl-agn-rx.c  |   87 ---------------
>  drivers/net/wireless/iwlwifi/iwl-agn.c     |   73 ++-----------
>  drivers/net/wireless/iwlwifi/iwl-agn.h     |    4 -
>  drivers/net/wireless/iwlwifi/iwl-core.h    |    9 +-
>  drivers/net/wireless/iwlwifi/iwl-rx.c      |  162 ++++++++++++++++++++++++++-
>  10 files changed, 167 insertions(+), 181 deletions(-)
> 

looks good, just wonder should it split into 2 patches, one for module
parameter, and the other for moving the function?

Your call

Wey

