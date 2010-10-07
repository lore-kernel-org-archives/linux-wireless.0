Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0JGSja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 14:39:30 -0400
Subject: Re: [PATCH v3] compat: backport netlink changes used in the
 nl80211 cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4CADC341.40305@openwrt.org>
References: <4CADB60C.6040105@openwrt.org> <4CADC142.7010709@openwrt.org>
	 <4CADC341.40305@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 20:39:28 +0200
Message-ID: <1286476768.20974.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 14:55 +0200, Felix Fietkau wrote:

> +#define genl_info_net(_info) genl_info_net((_info)->info)

Need this instead:

#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,32)
/* compat for even older kernels already defines this to &init_net */
#define genl_info_net(_info) genl_info_net((_info)->info)
#endif

johannes

