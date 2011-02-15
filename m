Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34781 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab1BOSSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 13:18:06 -0500
Received: by qwa26 with SMTP id 26so355637qwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 10:18:05 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
References: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
Date: Tue, 15 Feb 2011 19:17:52 +0100
Message-ID: <AANLkTikhq6yAZOBKzVn8xyUMP6uy49ZXuLrkFFsdVh6i@mail.gmail.com>
Subject: Re: [RFC/RFT] mac80211: make tx() operation return void
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <bcopeland@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 3:07 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The return value of the tx operation is commonly
> misused by drivers, leading to errors. All drivers
> will drop frames if they fail to TX the frame, and
> they must also properly manage the queues (if they
> didn't, mac80211 would already warn).
>
> Removing the ability for drivers to return a BUSY
> value also allows significant cleanups of the TX
> TX handling code in mac80211.
>
> NB: Also fixes a bug in ath9k_htc.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Tested with ath5k against linux-next (next-20110215) and adapted
ath5k-move-external-function-definitions-to-a-header-file-v2.patch (to
fit this patch) from Bob.

- Sedat -
