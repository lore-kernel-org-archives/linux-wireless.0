Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44848 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab2BYJTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 04:19:12 -0500
Subject: Re: [PATCH 3.3] mwifiex: fix bug in wildcard scan handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1330148149-28922-1-git-send-email-bzhao@marvell.com> (sfid-20120225_063856_034955_8526CBA3)
References: <1330148149-28922-1-git-send-email-bzhao@marvell.com>
	 (sfid-20120225_063856_034955_8526CBA3)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Feb 2012 10:19:10 +0100
Message-ID: <1330161550.3575.1.camel@jlt3.sipsolutions.net> (sfid-20120225_101917_277941_337CDD24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-24 at 21:35 -0800, Bing Zhao wrote:

>  			ssid_len = strlen(user_scan_in->ssid_list[ssid_idx].
> -					  ssid) + 1;
> +					  ssid);

Umm, are you really using strlen() on an SSID here? That's so broken I
can hardly describe it.

johannes

