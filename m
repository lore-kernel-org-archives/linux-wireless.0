Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab2FISNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 14:13:05 -0400
Message-ID: <1339265576.5029.1.camel@jlt3.sipsolutions.net> (sfid-20120609_201346_941184_D2A7F6E4)
Subject: Re: [patch] iwlwifi: turn on a lockdep assertion
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sat, 09 Jun 2012 20:12:56 +0200
In-Reply-To: <20120609155718.GB6488@elgon.mountain> (sfid-20120609_175745_768929_5935229F)
References: <20120609155718.GB6488@elgon.mountain>
	 (sfid-20120609_175745_768929_5935229F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-09 at 18:57 +0300, Dan Carpenter wrote:
> CMD_SYNC is zero so the if (cmd->flags & CMD_SYNC) is never true.  I
> think it should be if (cmd->flags == CMD_SYNC).  This enables a lockdep
> assertion.

Good catch, thanks. It should really be if (!(cmd->flags & CMD_ASYNC))
though I think as there could be other flags set which don't make it
non-sync.

I'll commit a fix on Monday unless you want to send a separate patch
(which I'll then pick up on Monday :-) )

johannes


