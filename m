Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYJ3JSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 05:18:09 -0400
Message-ID: <ae8368d03d2885c4942e2f9876dcaa60.squirrel@secure.sipsolutions.net>
In-Reply-To: <1225314349-11139-4-git-send-email-reinette.chatre@intel.com> 
References: <> <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
    <1225314349-11139-2-git-send-email-reinette.chatre@intel.com>
    <1225314349-11139-3-git-send-email-reinette.chatre@intel.com>
    <1225314349-11139-4-git-send-email-reinette.chatre@intel.com>
Date: Thu, 30 Oct 2008 10:18:03 +0100 (CET)
Subject: Re: [PATCH 3/7] iwlwifi: fix priv->iw_mode setting when multiple
     vif are configured
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Reinette Chatre" <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette Chatre wrote:
> From: Zhu, Yi <yi.zhu@intel.com>
>
> mac80211 supports multiple virtual interfaces for a single device. For
> example, a managed interface (wlan0) and a monitor interface (mon0) can
> exist at the same time. Thus priv->iw_mode is not sufficient to track
> the wireless mode any more.

This example is not correct, mac80211 will only support multiple virtual
interfaces when the driver allows this via add_interface (which I don't
think yours does) and it will *never* tell you about monitor interfaces at
all except by way of configuring the filter differently.

Therefore, all the "is monitor" checks in iwlwifi are pretty pointless
unless you really want to have differing behaviour between "monitor +
something" and "just monitor"?

johannes
