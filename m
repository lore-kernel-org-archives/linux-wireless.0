Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33193 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1FBRAV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 13:00:21 -0400
Subject: Re: [PATCH 1/2 v2] iwlagn: fix channel switch locking
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110602161715.GD4580@redhat.com>
References: <20110602144424.GA4580@redhat.com>
	 <1307024842.13397.2.camel@wwguy-huron>  <20110602161715.GD4580@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 09:56:51 -0700
Message-ID: <1307033811.14344.0.camel@wwguy-ubuntu> (sfid-20110602_190024_551119_F3EEDDDD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-02 at 09:17 -0700, Stanislaw Gruszka wrote:
> We use priv->mutex to avoid race conditions between iwl_chswitch_done()
> and iwlagn_mac_channel_switch(), when marking channel switch in
> progress. But iwl_chswitch_done() can be called in atomic context
> from iwl_rx_csa() or with mutex already taken from iwlagn_commit_rxon().
> 
> These bugs were introduced by:
> 
> commit 79d07325502e73508f917475bc1617b60979dd94
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Thu May 6 08:54:11 2010 -0700
> 
>     iwlwifi: support channel switch offload in driver
> 
> To fix remove mutex from iwl_chswitch_done() and use atomic bitops for
> marking channel switch pending.
> 
> Also remove iwl2030_hw_channel_switch() since 2000 series adapters are
> 2.4GHz only devices.
> 
> Cc: stable@kernel.org # 2.6.36+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---


