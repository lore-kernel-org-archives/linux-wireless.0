Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0CWRVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 13:21:23 -0400
Subject: Re: [PATCH 2/2] iwlwifi: implement disabling/enabling QoS
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1269348417-4081-2-git-send-email-sgruszka@redhat.com>
References: <1269348417-4081-1-git-send-email-sgruszka@redhat.com>
	 <1269348417-4081-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 10:21:26 -0700
Message-ID: <1269364886.9689.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-23 at 13:46 +0100, Stanislaw Gruszka wrote:
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

This really could use "more" text as to why etc.

> +	if (changes & BSS_CHANGED_QOS) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&priv->lock, flags);
> +		priv->qos_data.qos_active = bss_conf->qos_disabled ? 0 : 1;
> +		iwl_activate_qos(priv, 1);
> +		spin_unlock_irqrestore(&priv->lock, flags);
> +	}

This seems alright, but we really need to revisit that since there's a
lot of odd logic in iwlwifi that makes some sense based on this now but
could probably be simplified now. I'll close with Wey-Yi, she worked on
QoS here at some point I think.

johannes

