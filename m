Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:54626 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557Ab3KOMFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 07:05:36 -0500
Received: by mail-la0-f51.google.com with SMTP id ec20so2662920lab.38
        for <linux-wireless@vger.kernel.org>; Fri, 15 Nov 2013 04:05:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201311141714.00098.sw@simonwunderlich.de>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384442962.13941.36.camel@jlt4.sipsolutions.net> <CAB=NE6WX9JV-Lx11iiPHPinDCxy7u-Q--ucQ-9Mjy-nndKTeqQ@mail.gmail.com>
 <201311141714.00098.sw@simonwunderlich.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 15 Nov 2013 13:05:14 +0100
Message-ID: <CAB=NE6XXZ5nkBfGcfsd+C=xDXGXT2HKQckt1hqS1+hSUVr5tqg@mail.gmail.com> (sfid-20131115_130549_426125_F6BBCD7B)
Subject: Re: [RFC 4/5] cfg80211: add DFS region capability support
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Jouni Malinen <j@w1.fi>, sunitb <sunitb@qca.qualcomm.com>,
	rsunki <rsunki@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 14, 2013 at 5:13 PM, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> Right, it does not mean userspace implements radar detection/pattern
> matching/etc.
>
> HANDLE_DFS only means that userspace lets the kernel know that it will react
> to nl80211-dfs-radar events (these only contain "i detected a radar on freq
> XXX" [1] and similar) and that it will do a channel switch (CSA) in this case
> to move away.
>
> We still assume that the radar detection/pattern matching/etc, which is indeed
> region-specific, is done in the drivers (as done for ath9k now) or by other
> means independent of this HANDLE_DFS attribute.

OK thanks, I think I read too much into "userspace controls DFS
operation in IBSS mode". Some clarification on this would be useful on
the documentation.

In that case, yes everything would be handled properly now with the
series I posted and all that nonsense I mentioned about HANDLE_DFS can
be ignored.

  Luis
