Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51174 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbZFBFKj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 01:10:39 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 22:10:41 -0700
Date: Tue, 2 Jun 2009 10:39:04 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"parag.warudkar@gmail.com" <parag.warudkar@gmail.com>,
	Gaurav Jauhar <Gaurav.Jauhar@Atheros.com>,
	"fabian.deutsch@gmx.de" <fabian.deutsch@gmx.de>,
	"arxs@fedoraproject.org" <arxs@fedoraproject.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"debaditya@gmail.com" <debaditya@gmail.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"drago01@gmail.com" <drago01@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"michal@harddata.com" <michal@harddata.com>,
	"leann.ogasawara@canonical.com" <leann.ogasawara@canonical.com>,
	"tim.gardner@canonical.com" <tim.gardner@canonical.com>,
	"jirislaby@gmail.com" <jirislaby@gmail.com>
Subject: Re: [ath9k-devel] Pending ath9k bugs
Message-ID: <20090602050904.GC17632@vasanth-laptop>
References: <20090601184134.GC5516@tesla> <43e72e890906011252s43d2c596m6ec79569f5074837@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <43e72e890906011252s43d2c596m6ec79569f5074837@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> BUG_ON in rc.c when using 11n. This could be caused by an incorrect
> assumption in ath9k that the rc priv is correctly for the target rate.
> The issue may be seen when trying to associate and changing between
> legacy and HT rates on SMP systems when mac80211 passes frames on
> different queues due to multiqueue support. If that is indeed the
> reason for the issue we will probably need locking on the rc priv or
> simply to revamp it. I'll send a patch for now to downgrade the BUG_ON
> but we do need a proper fix for this, it just needs more careful
> review.

I agree that rc priv needs proper locking, but I dont think this
particular issue is related to some race in rc priv. As I already
mentioned in one of the mails related to this problem, the root
cause can be a failure in channel set, have we confirmed that?.
I tried to reproduce this on my setup but no luck.

> 
> While on the topic I should mention a welcomed change would be to
> actually revamp ath9k RC to fix it to correctly report MCS rates to
> mac80211. 

This needs complete rewrite of ath9k rate control alg.


Vasanth


