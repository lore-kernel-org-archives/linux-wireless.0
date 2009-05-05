Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54554 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbZEERfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 13:35:52 -0400
Message-Id: <20090505173512.349795688@atheros.com>
Date: Tue, 05 May 2009 20:35:12 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] mac80211: HT RX reorder buffer cleanup and timeout workaround
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some cases where frames in RX reorder buffer can get stuck for
extended time due to various errors (implementation bugs, frames getting
lost completely, etc.). The workaround added here seems to make us
recover much more quickly in some of these cases. This does not cover
all cases, but is a useful initial step in avoiding some HT aggregation
issues.

-- 
Jouni Malinen                                            PGP id EFC895FA
