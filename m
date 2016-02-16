Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53229 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbcBPVob (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 16:44:31 -0500
Message-ID: <1455659067.2723.13.camel@sipsolutions.net> (sfid-20160216_224435_704657_089873A6)
Subject: Re: [PATCH] mac80211: debugfs var for the default aggregation
 timeout.
From: Johannes Berg <johannes@sipsolutions.net>
To: Avery Pennarun <apenwarr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@vger.kernel.org, nbd@nbd.name
Date: Tue, 16 Feb 2016 22:44:27 +0100
In-Reply-To: <1455658091-28262-2-git-send-email-apenwarr@gmail.com> (sfid-20160216_222826_373181_FA784E45)
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
	 <1455658091-28262-1-git-send-email-apenwarr@gmail.com>
	 <1455658091-28262-2-git-send-email-apenwarr@gmail.com>
	 (sfid-20160216_222826_373181_FA784E45)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-16 at 16:28 -0500, Avery Pennarun wrote:
> Since around the beginning of time, ath9k aggregates have timed out
> after
> 5000 TU (around 5000ms) of inactivity, but nobody seems to be quite
> sure
> why, and this magic number seems to have migrated around from one
> place to
> another.  An openbsd mailing list recently had a patch to disable the
> timeout completely, which they say matches some commercial routers:
> https://www.mail-archive.com/tech@openbsd.org/msg29456.html
> 
> Even in Linux, several non-ath9k drivers default to no timeout
> already.  I
> think changing it directly to zero would be safe, but to allow a more
> structured investigation, let's make it configurable for now.

I believe the original timeout came from some ancient Intel code.
Nobody gave it any thought at the time, and it was merged and preserved
to this day.

The reason for Intel specifically is that every aggregation session
(both RX and TX), even idle ones, takes up hardware resources, so
there's a limited need to drop completely idle sessions.

As a result, I believe that changing the default for every driver other
than iwlegacy, iwlwifi/dvm and iwlwifi/mvm would be perfectly fine.

johannes
