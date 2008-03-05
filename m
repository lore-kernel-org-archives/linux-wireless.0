Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:55926 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104AbYCEHCj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 02:02:39 -0500
Date: Wed, 5 Mar 2008 08:02:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christopher Li <sparse@chrisli.org>
Cc: Julia Lawall <julia@diku.dk>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Alexander Viro <viro@ftp.linux.org.uk>,
	linux-sparse@vger.kernel.org, Josh Triplett <josh@freedesktop.org>
Subject: Re: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct
	use of ! and &
Message-ID: <20080305070201.GA32434@elte.hu> (sfid-20080305_070244_040082_B433877E)
References: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk> <20080305063842.GA24495@elte.hu> <70318cbf0803042249j57d7f3a3j7666961a9132b10b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <70318cbf0803042249j57d7f3a3j7666961a9132b10b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


* Christopher Li <sparse@chrisli.org> wrote:

> I think Al Viro has sent a patch to linux-sparse with subject "[PATCH 
> 3/3] catch !x & y brainos" does exactly that.

ah - nice :-)

/me checks the linux-sparse archive

Al's patch is:

+                       if (op == '&' && expr->left->type == EXPR_PREOP &&
+                           expr->left->op == '!')
+                               warning(expr->pos, "dubious: !x & y");

i think there might be similar patterns: "x & !y", "!x | y", "x | !y" ?

	Ingo
