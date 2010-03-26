Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40639 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0CZR2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 13:28:19 -0400
Subject: Re: [PATCH 2/2] iwlwifi: manage QoS by mac stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>, wey-yi.w.guy@intel.com
In-Reply-To: <1269621992-5034-2-git-send-email-sgruszka@redhat.com>
References: <1269621992-5034-1-git-send-email-sgruszka@redhat.com>
	 <1269621992-5034-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 10:28:27 -0700
Message-ID: <1269624507.4342.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-26 at 17:46 +0100, Stanislaw Gruszka wrote:

> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -321,17 +321,13 @@ EXPORT_SYMBOL(iwl_hw_nic_init);
>  /*
>   * QoS  support
>  */
> -void iwl_activate_qos(struct iwl_priv *priv, u8 force)
> +void iwl_activate_qos(struct iwl_priv *priv)

I would advocate renaming this function to something like
iwl_update_qos.

Also, since you remove it from 3945/agn, I think it can probably be
static now and lose the export?

johannes

