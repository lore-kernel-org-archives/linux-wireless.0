Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2LKT5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 14:57:13 -0500
Message-ID: <1355255841.9819.18.camel@jlt4.sipsolutions.net> (sfid-20121211_205717_448369_2E029CC7)
Subject: Re: [PATCH 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 11 Dec 2012 20:57:21 +0100
In-Reply-To: <1354880763-12309-2-git-send-email-vthiagar@qca.qualcomm.com>
References: <1354880763-12309-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1354880763-12309-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-07 at 17:16 +0530, Vasanthakumar Thiagarajan wrote:
> This patch enables drivers to implement mac address based
> access control in AP/P2P GO mode. There is a new flag in
> nl80211_ap_sme_features (NL80211_AP_SME_FEATURE_MAC_ACL)
> for drivers to advertise this capability. There are two acl
> policies, white and black list under which an acl list can
> be configured in the driver. Driver has to advertise the
> maximum number of mac address entries in acl list through
> max_acl_mac_addrs of wiphy.
> 
> Driver can enable its ACL either with the initial list passed
> through NL80211_CMD_START_AP or a list passed through
> NL80211_CMD_SET_MAC_ACL. ACL information passed in these
> commands is an array of acl configuration containing acl
> policy and list of mac address. With the acl policy as
> NL80211_ACL_POLICY_ACCEPT, driver will accept Auth request
> from any client matching any one of the mac addresses in the acl list.
> When acl policy is NL80211_ACL_POLICY_DENY, driver will reject any
> Auth request from the clients having their mac address listed in the
> acl list. Driver must make sure to clear it's acl list when doing
> stop ap.

It seems easy to imagine a device that supports only a blacklist or
whitelist, not both combined? What's the point of that anyway?

> +       NL80211_AP_SME_FEATURE_MAC_ACL          = 1 << 0,

This doesn't seem to be needed since you have the max ACL number, and
should leave out the attribute if it's 0 so its presence can be the
feature test.

johannes

