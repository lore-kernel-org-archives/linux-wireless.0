Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:45618 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbZFATxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 15:53:13 -0400
Received: by pzk7 with SMTP id 7so6198098pzk.33
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 12:53:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090601184134.GC5516@tesla>
References: <20090601184134.GC5516@tesla>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 1 Jun 2009 12:52:54 -0700
Message-ID: <43e72e890906011252s43d2c596m6ec79569f5074837@mail.gmail.com>
Subject: Re: [ath9k-devel] Pending ath9k bugs
To: linux-wireless@vger.kernel.org
Cc: parag.warudkar@gmail.com, Gaurav.Jauhar@atheros.com,
	fabian.deutsch@gmx.de, arxs@fedoraproject.org,
	linville@tuxdriver.com, debaditya@gmail.com,
	senthilkumar@atheros.com, drago01@gmail.com,
	ath9k-devel@lists.ath9k.org, michal@harddata.com,
	leann.ogasawara@canonical.com, tim.gardner@canonical.com,
	jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 1, 2009 at 11:41 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

> ath9k-devel:

I just remembered of another issue:

BUG_ON in rc.c when using 11n. This could be caused by an incorrect
assumption in ath9k that the rc priv is correctly for the target rate.
The issue may be seen when trying to associate and changing between
legacy and HT rates on SMP systems when mac80211 passes frames on
different queues due to multiqueue support. If that is indeed the
reason for the issue we will probably need locking on the rc priv or
simply to revamp it. I'll send a patch for now to downgrade the BUG_ON
but we do need a proper fix for this, it just needs more careful
review.

While on the topic I should mention a welcomed change would be to
actually revamp ath9k RC to fix it to correctly report MCS rates to
mac80211. Then add MCS support for minstrel, and finally allow ath9k
to make use of minstrel as an optional rate control algo. If anyone is
up for the task please say so :)

  Luis
