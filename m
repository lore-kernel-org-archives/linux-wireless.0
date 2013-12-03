Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43252 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3LCMzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 07:55:37 -0500
Message-ID: <1386075333.4393.13.camel@jlt4.sipsolutions.net> (sfid-20131203_135553_610883_63E642A2)
Subject: Re: [PATCH v4] mac80211_hwsim: claim CSA support for AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Tue, 03 Dec 2013 13:55:33 +0100
In-Reply-To: <1385224698-12294-1-git-send-email-karl.beldan@gmail.com> (sfid-20131123_173902_687822_1D76D641)
References: <1385224698-12294-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20131123_173902_687822_1D76D641)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-11-23 at 17:38 +0100, Karl Beldan wrote:

> This adds a per vif bool csa_finished that is set after a call to
> ieee80211_csa_finish() and used to skip beaconing while csa_active is
> set in case a beacon is scheduled prior to csa_finalize_work completion.
> This bool and the number of beacons transmitted during the CSA up to the
> call to ieee80211_csa_finish() are reset in channel_switch_beacon op.

Andrei says:

Overall it seems ok, but all the purpose of csa_finished is not very
clear..
It looks that this patch tries to avoid extra beaconing on the previous
channel/hitting the warning..
But the problem is much bigger here, it means that we didn't switch in
time (before the next beacon) so it's ok to hit the warning here and
transmit extra beacon with count==1.
So if we see a lot of such warnings, maybe we need to fix
ieee80211_csa_finish instead (not using work for example)

johannes

