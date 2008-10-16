Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44048 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbYJPB6Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 21:58:24 -0400
Subject: Re: iwlwifi workqueue
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
In-Reply-To: <1224107259.735.35.camel@johannes.berg>
References: <1224107259.735.35.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 16 Oct 2008 09:58:26 +0800
Message-Id: <1224122306.24677.65.camel@debian.sh.intel.com> (sfid-20081016_035826_755153_51F832D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-15 at 14:47 -0700, Johannes Berg wrote:
> Does it really have to be multi-threaded?

No real reason. Actually most of the works are serialized by a mutex.
Patch is welcome.

Thanks,
-yi

> static void iwl_setup_deferred_work(struct iwl_priv *priv)
> {
>         priv->workqueue = create_workqueue(DRV_NAME);
> 
> 
> this creates one thread for each CPU, bound to that CPU, which seems
> overkill. mac80211 even provides a single-threaded workqueue.
> 
> johannes

