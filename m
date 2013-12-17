Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46632 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3LQT4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 14:56:40 -0500
Message-ID: <1387310197.4749.18.camel@jlt4.sipsolutions.net> (sfid-20131217_205644_034118_D5795561)
Subject: Re: Circular lock with mac80211_hwsim and DFS
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Dec 2013 20:56:37 +0100
In-Reply-To: <87lhzjeqg6.fsf@kamboji.qca.qualcomm.com> (sfid-20131217_111250_394625_7CF651F6)
References: <87lhzjeqg6.fsf@kamboji.qca.qualcomm.com>
	 (sfid-20131217_111250_394625_7CF651F6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-17 at 12:12 +0200, Kalle Valo wrote:
> Hi,
> 
> I tried to run a simple DFS test with mac80211_hwsim for the first time
> but got the deadlock below. Is this a regression or has DFS ever worked
> with hwsim?

It should still work - the actual deadlock can't really happen in
practice since almost all the calls that could lead to it are under RTNL
anyway.

It's still really ugly and we should fix it, but it's .. complicated.

johannes

