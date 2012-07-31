Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:34858 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751133Ab2GaPqL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 11:46:11 -0400
Message-ID: <1343749569.6383.2.camel@joe2Laptop> (sfid-20120731_174619_324239_B647D473)
Subject: Re: [PATCH] mac80211: use eth_broadcast_addr
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	netdev <netdev@vger.kernel.org>
Date: Tue, 31 Jul 2012 08:46:09 -0700
In-Reply-To: <1343744471-5910-1-git-send-email-johannes@sipsolutions.net>
References: <1343744471-5910-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-31 at 16:21 +0200, Johannes Berg wrote:
> Instead of memset().

Maybe just do them all?

git ls-files net drivers/net |
xargs perl -p -i -e 's/\bmemset\s*\(\s*([^,]+),\s*(?i:0xff|255)\s*\,\s*(ETH_ALEN|6)\s*\)/eth_broadcast_addr\(\1\)/g'


