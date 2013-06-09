Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49207 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab3FIOfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 10:35:13 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Kirshenbaum Erez <erezk@wilocity.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wil6210: Fix AP/PCP start flow
Date: Sun, 9 Jun 2013 17:35:09 +0300
Message-ID: <3898456.LkS71H2YX8@lx-vladimir> (sfid-20130609_163537_182258_7D867896)
In-Reply-To: <1370782371-14694-1-git-send-email-erezk@wilocity.com>
References: <1370782371-14694-1-git-send-email-erezk@wilocity.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, June 09, 2013 03:52:51 PM Kirshenbaum Erez wrote:
> WMI PCP Start flow should not be hanled through:
> net_device_ops->ndo_open()->wil_up()->__wil_up() 
> because it missing mandatory FW parameters (SSID,Channel,IEs, Security...).
> 
> Prior to AP starting __wil_up() may be called with iftype set
> cfg80211_ops->change_virtual_intf(NL80211_IFTYPE_AP or STATION) 
> depend on the application hostapd/wpa_supplicant/iw. 
> there should not be an attempt to start an AP flow, 
> AP/PCP start flow will be started latter by cfg80211_ops->start_ap().
> 
> 
> Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>

Looks good. I fixed typo (s/hanled/handled/) and rebased; submitting as [PATCH v3]...

Thanks, Vladimir
