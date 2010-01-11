Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7636 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab0AKBun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 20:50:43 -0500
Subject: Re: [patch] iwlwifi: silence buffer overflow warning
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100109084147.GB7840@bicker>
References: <20100109084147.GB7840@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 09:50:41 +0800
Message-ID: <1263174641.15653.241.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-01-09 at 16:41 +0800, Dan Carpenter wrote:
> Smatch (and presumably other static checkers) complain that MAX_TID_COUNT is 
> past the end of the array.  In the resulting discussion, Zhu Yi pointed out
> that this value is not used in real life and the assignment was only there to
> silence a gcc warning.
> 
> If there were a bug in the surrounding code and the value were used, the 
> WARN_ON(!qc) would print a warning before the crash.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

> --- orig/drivers/net/wireless/iwlwifi/iwl-4965.c	2010-01-03 11:02:42.000000000 +0300
> +++ devel/drivers/net/wireless/iwlwifi/iwl-4965.c	2010-01-06 00:27:00.000000000 +0300
> @@ -1961,7 +1961,7 @@ static void iwl4965_rx_reply_tx(struct i
>  	struct ieee80211_tx_info *info;
>  	struct iwl4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
>  	u32  status = le32_to_cpu(tx_resp->u.status);
> -	int tid = MAX_TID_COUNT;
> +	int uninitialized_var(tid);
>  	int sta_id;
>  	int freed;
>  	u8 *qc = NULL;


