Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4072 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab1CCIH2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 03:07:28 -0500
Subject: Re: [PATCH v2] mwifiex: remove PRINTM/HEXDUMP and associated
From: Joe Perches <joe@perches.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1299105113-3052-1-git-send-email-bzhao@marvell.com>
References: <1299105113-3052-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 00:07:26 -0800
Message-ID: <1299139646.4338.69.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-02 at 14:31 -0800, Bing Zhao wrote:
> use pr_debug family APIs instead.
> MERROR/MFATAL/MMSG: pr_err, pr_warning, pr_notice

Trivia:

It looks to me as if all the MFATAL should
map to KERN_ERR.

Please use pr_fmt
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
to prefix "mwifiex: " rather than put it each
format string. 

Please use pr_warn not pr_warning.

I really don't think you need to add another prefix
string like "err" and "info" and "cmd" to the various
levels.  The output content is enough to figure it out.

Perhaps use use dev/netdev/wiphy_<level> where it makes
sense?

You've sometimes added __func__ and sometimes used or
kept some shortened function name equivalent.  It'd
probably be better to consistently use __func__ where
appropriate.

