Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40743 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3LPKab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 05:30:31 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1VsVRW-0006Ur-P3
	for linux-wireless@vger.kernel.org; Mon, 16 Dec 2013 11:30:30 +0100
Message-ID: <1387189828.4665.5.camel@jlt4.sipsolutions.net> (sfid-20131216_113034_808187_8524F5FD)
Subject: Re: [PATCH 0/8] mac80211: speed up station cleanup/AP shutdown
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 16 Dec 2013 11:30:28 +0100
In-Reply-To: <1386246956-14257-1-git-send-email-johannes@sipsolutions.net> (sfid-20131205_133615_238897_7D79C534)
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
	 <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131205_133615_238897_7D79C534)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 13:35 +0100, Johannes Berg wrote:
> Inspired by hostap shutdown potentially taking a long time (which is
> in part also its fault), I took a closer look at the station removal
> code and I think it's too complex. Only a single driver (iwlmvm) has
> a need for an RCU grace period after sta_state() returns, and that
> can easily be addressed differently.
> 
> So consolidate many of the synchronize_rcu()/_net() in these paths
> and get rid of the rcu_barrier() stuff completely.
> 
> Testing is still pending, but it should improve timing.

Timing tests showed a huge improvement, applied all patches.

johannes

