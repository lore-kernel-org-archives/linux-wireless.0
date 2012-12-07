Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:46972 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1424281Ab2LGFi4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 00:38:56 -0500
Message-ID: <1354858735.22463.31.camel@joe-AO722> (sfid-20121207_063922_600678_E7195284)
Subject: Re: [RFC V3 1/2] I'dcfg80211: Move the definition of struct
 mac_address up
From: Joe Perches <joe@perches.com>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Date: Thu, 06 Dec 2012 21:38:55 -0800
In-Reply-To: <1354853850-10537-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1354853850-10537-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-07 at 09:47 +0530, Vasanthakumar Thiagarajan wrote:
> struct mac_address will be used by ACL related configuration ops.

I'd prefer that any new code _not_ use struct mac_address
but use u8 addr[ETH_ALEN] instead.

That's the most common style in the kernel.

$ git grep -E "\bu8\s+\w+\s*\[\s*ETH_ALEN\s*\]" | wc -l
749
$ git grep -E "\bstruct\s+mac_address\b" | wc -l
13

There are also uses of char and unsigned char

$ git grep -E "\bchar\s+\w+\s*\[\s*ETH_ALEN\s*\]" | wc -l
121

Some of those are ancient, but it'd be good to
be consistent throughout the kernel.

