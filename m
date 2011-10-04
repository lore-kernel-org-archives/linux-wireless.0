Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1JDG3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 02:29:52 -0400
Subject: Re: [PATCH] mwifiex: use separate wait queue for each command node
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1317701303-21871-1-git-send-email-bzhao@marvell.com> (sfid-20111004_061336_546510_9B44E171)
References: <1317701303-21871-1-git-send-email-bzhao@marvell.com>
	 (sfid-20111004_061336_546510_9B44E171)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 08:29:48 +0200
Message-ID: <1317709788.3986.0.camel@jlt3.sipsolutions.net> (sfid-20111004_082956_081225_166E16BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-03 at 21:08 -0700, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Currently global wait queue (adapter->cmd_wait_q) is used for
> sending synchronous commands to FW. When two threads enter in
> mwifiex_send_cmd_sync() routine at the same time, both the
> threads wait for their command responses. They wake up
> simultaneously after getting response of 1st command. After
> this when a thread is waiting for command response of 3rd
> command, it wakes up after getting response of 2nd command
> and so on. Therefore we don't wait for the response of last
> command(0xaa) during unload. Hence while next time loading the
> driver command time out is seen for INIT command.
> 
> This problem is resolved by having separate wait queue for each
> command. Since driver sends multiple scan commands asynchronously
> to FW for scanning the network, we will need separate wait queue
> for the whole scan operation. Earlier the global wait queue was
> being used for scan.

I can't say I really care about this, but this seems completely
pointless. A waitqueue doesn't imply that just a single thing can be
waiting on it, since you should be using wait_for() macros. Thus, all
you *really* need is a bit in the command that marks it as completed,
and then you use the waitqueue to wait for that bit to be set.

johannes


