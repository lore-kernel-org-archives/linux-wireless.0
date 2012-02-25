Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab2BYJSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 04:18:33 -0500
Subject: Re: [PATCH 3.3] mwifiex: correct bitrates advertised to cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1330148145-28895-1-git-send-email-bzhao@marvell.com> (sfid-20120225_063848_535698_E4A085DE)
References: <1330148145-28895-1-git-send-email-bzhao@marvell.com>
	 (sfid-20120225_063848_535698_E4A085DE)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Feb 2012 10:18:28 +0100
Message-ID: <1330161508.3575.0.camel@jlt3.sipsolutions.net> (sfid-20120225_101838_028169_602EE4F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-24 at 21:35 -0800, Bing Zhao wrote:
> From: Avinash Patil <patila@marvell.com>
> 
> 1. Remove non-standard rates 22Mbps and 72Mbps.

You can advertise those rates if you like. 22 is standard even, just
hardly implemented.

> 2. First 4 rates from mwifiex_rates table are not valid for

but then of course you need to remove the first 5 rates since 22 isn't
valid in 5 GHz either.

johannes

