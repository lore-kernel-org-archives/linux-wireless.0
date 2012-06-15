Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44584 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2FOVrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 17:47:19 -0400
Message-ID: <1339796838.16369.3.camel@jlt3.sipsolutions.net> (sfid-20120615_234722_201761_4F42EDE1)
Subject: mwifiex mwifiex_add_virtual_intf return value
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 15 Jun 2012 23:47:18 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was just looking at this because I'm changing it from returning a
netdev to struct wireless_dev, but I notice that you're returning the
wrong thing on errors -- you need to return an ERR_PTR(), not NULL,
otherwise cfg80211 will crash.

johannes

