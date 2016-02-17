Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33762 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965038AbcBQCap (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 21:30:45 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22211.54634.306724.455601@gargle.gargle.HOWL> (sfid-20160217_033048_632934_EB6906A1)
Date: Wed, 17 Feb 2016 07:35:30 +0530
To: "Avery Pennarun" <apenwarr@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name
Subject: Re: [PATCH] mac80211: debugfs var for the default aggregation timeout.
In-Reply-To: <1455658091-28262-2-git-send-email-apenwarr@gmail.com>
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
	<1455658091-28262-1-git-send-email-apenwarr@gmail.com>
	<1455658091-28262-2-git-send-email-apenwarr@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avery Pennarun wrote:
> Since around the beginning of time, ath9k aggregates have timed out after
> 5000 TU (around 5000ms) of inactivity, but nobody seems to be quite sure
> why, and this magic number seems to have migrated around from one place to
> another.  An openbsd mailing list recently had a patch to disable the
> timeout completely, which they say matches some commercial routers:
> https://www.mail-archive.com/tech@openbsd.org/msg29456.html

We actually did this for ath9k:
https://git.kernel.org/cgit/linux/kernel/git/wireless/wireless-testing.git/commit/?id=bd2ce6e43f65127bc723e7fcc044758cf8113260

Almost all APs set the timeout to zero, only mac80211 differs
and uses 5000 TUs. I guess ath9k lost this fix when the old
RC was removed and switched to minstrel.

Sujith
