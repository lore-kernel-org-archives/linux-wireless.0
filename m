Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:11895 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756698Ab0LNP1M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 10:27:12 -0500
Subject: Re: [PATCH 03/14] iwlagn: check ready in iwlagn_bss_info_changed()
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Zhao, Shanyu" <shanyu.zhao@intel.com>
In-Reply-To: <1292310979.3569.2.camel@jlt3.sipsolutions.net>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1292285372-11373-4-git-send-email-wey-yi.w.guy@intel.com>
	 <1292310979.3569.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Tue, 14 Dec 2010 07:26:05 -0800
Message-Id: <1292340365.9665.4.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes and John,

On Mon, 2010-12-13 at 23:16 -0800, Johannes Berg wrote:
> On Mon, 2010-12-13 at 16:09 -0800, Wey-Yi Guy wrote:
> 
> > -	if (WARN_ON(!ctx->vif)) {
> > +	if (unlikely(!iwl_is_ready(priv))) {
> > +                IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
> > +                mutex_unlock(&priv->mutex);
> > +		return;
> 
> There appears to be some whitespace damage here.
> 

my bad did not check before push, I will submit another patch to fix it
and please merge both

Thanks
Wey

> 

