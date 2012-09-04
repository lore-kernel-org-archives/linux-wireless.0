Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20652 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2IDGaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 02:30:09 -0400
Message-ID: <50459FD3.2010305@qca.qualcomm.com> (sfid-20120904_083017_031819_3D26A7AA)
Date: Tue, 4 Sep 2012 09:29:39 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/2] cfg80211/nl80211: Enable drivers to implement mac address
 based ACL
References: <1346675037-17858-1-git-send-email-vthiagar@qca.qualcomm.com> <1346675037-17858-2-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1346675037-17858-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/03/2012 03:23 PM, Vasanthakumar Thiagarajan wrote:
> This patch enables drivers to implement mac address based
> access control in AP/P2P GO mode. There is a new flag in
> nl80211_feature_flags (NL80211_FEATURE_MAC_ACL) for drivers
> to advertise this capability. There are two acl policies, white
> and black list, under which an acl list can be configured in the
> driver. Driver has to advertise the maximum number of mac address
> entries in acl list through max_acl_mac_addrs of wiphy.
> 
> ACL is enabled/disabled based on attribute NL80211_ATTR_MAC_ACL which
> is passed in start_ap. A list of stations' mac addresses is set
> using NL80211_CMD_SET_MAC_ACL.

I would prefer a bit more documentation how this works from user space
or driver's point of view. I think I can guess how it's supposed to
work, but it would be good to document it explicitly. For example, it
wasn't clear how he driver must function when NL80211_ACL_POLICY_ACCEPT
or DENY is used.

> Driver may have to make sure to clear it's acl list when doing start/stop ap.

s/may/must/?

Kalle

