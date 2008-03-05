Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:36211 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612AbYCEGjP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 01:39:15 -0500
Date: Wed, 5 Mar 2008 07:38:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Julia Lawall <julia@diku.dk>
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Alexander Viro <viro@ftp.linux.org.uk>,
	linux-sparse@vger.kernel.org, Josh Triplett <josh@freedesktop.org>
Subject: Re: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct
	use of ! and &
Message-ID: <20080305063842.GA24495@elte.hu> (sfid-20080305_063936_354127_89272372)
References: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


* Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed 
> that involved converting !x & y to !(x & y).  The code below shows the 
> same pattern, and thus should perhaps be fixed in the same way.

>  	if (sta_ht_inf) {
>  		if ((!sta_ht_inf->ht_supported) ||
> -		   (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
> +		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
>  			return 0;

i'm wondering, could Sparse be extended to check for such patterns? 

People are regularly running "make C=1" and are sending fixes to make 
entire subsystems sparse-warning-free, so Sparse is a nice mechanism 
that works and it keeps code clean in the long run.

I dont think the "!X & Y" pattern is ever used legitimately [and even if 
it were used legitimately, it's easy to avoid the sparse false positive 
- while in the buggy case we have a clear bug].

	Ingo
