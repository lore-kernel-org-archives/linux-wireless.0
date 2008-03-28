Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbYC1Hnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 03:43:55 -0400
Date: Fri, 28 Mar 2008 00:43:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: ieee80211_get_channel exported twice
Message-Id: <20080328004353.7ae30fe4.akpm@linux-foundation.org> (sfid-20080328_074359_233527_6998DC38)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


ia64 allmodconfig says:

WARNING: net/wireless/cfg80211: 'ieee80211_get_channel' exported twice. Previous export was in net/ieee80211/ieee80211.ko

net/ieee80211/ieee80211_geo.c already has an exported ieee80211_get_channel().

net-2.6.26 adds a new version of ieee80211_get_channel() in
net/wireless/util.c and exports that as well.


