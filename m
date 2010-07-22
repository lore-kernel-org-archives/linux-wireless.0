Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59716 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab0GVTaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 15:30:12 -0400
Date: Thu, 22 Jul 2010 15:28:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Carpenter <error27@gmail.com>
Cc: johannes.berg@intel.com, linux-wireless@vger.kernel.org
Subject: Re: potential null deref in iwlagn_request_scan()?
Message-ID: <20100722192841.GE2616@tuxdriver.com>
References: <20100721221616.GT17585@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100721221616.GT17585@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 22, 2010 at 12:16:16AM +0200, Dan Carpenter wrote:
> Smatch complains about iwlagn_request_scan().
> 
> drivers/net/wireless/iwlwifi/iwl-agn-lib.c +1354 iwlagn_request_scan(204)
> 	error: we previously assumed 'vif' could be null.
> 
>   1351          if (!priv->is_internal_short_scan) {
>   1352                  cmd_len = iwl_fill_probe_req(priv,
>   1353                                          (struct ieee80211_mgmt *)scan->data,
>   1354                                          vif->addr,
> 						^^^^^^^^^
> 
>   1355                                          priv->scan_request->ie, 
>   1356						priv->scan_request->ie_len,
>   1357                                          IWL_MAX_SCAN_SIZE - sizeof(*scan));
>   1358          } else {
>   1359                  /* use bcast addr, will not be transmitted but must be valid */
> 
> This was added in 3a0b9aad0a8166e9f "iwlwifi: use virtual interface
> address for scan".  Prior to that commit the function assumed that vif
> could be NULL throughout.
> 
> I don't know the code well enough to know what to do about this.
> 
> Also the same thing for:
> drivers/net/wireless/iwlwifi/iwl3945-base.c +2963 iwl3945_request_scan(158)
> 	error: we previously assumed 'vif' could be null.

I think both of these are more-or-less OK.  It looks like the only
time vif would be NULL is in the "priv->is_internal_short_scan ==
true" case.  I'll send a patch, but I don't know if it really matters.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
