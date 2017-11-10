Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46928 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755648AbdKJCek (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 21:34:40 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rt2x00: use monotonic timestamps for frame dump
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171106140412.1532617-1-arnd@arndb.de>
References: <20171106140412.1532617-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20171110023439.DF069607EF@smtp.codeaurora.org> (sfid-20171110_033501_218080_0293A28F)
Date: Fri, 10 Nov 2017 02:34:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> rt2x00 uses the deprecated do_gettimeofday() function to get a timestamp
> for its debugfs "dump" file interface.
> 
> The timestamp is using an unsigned 32-bit value, so we could make it
> work until 2106 by using ktime_get_real_ts64(), but it seems better to
> use monotonic times, as we normally want for timestamps.
> 
> Since this is an interface change, I'm incrementing the
> DUMP_HEADER_VERSION number, so user space can figure out whether the
> timestamps are monotonic or not. Most likely the tools won't care either
> way.
> 
> Generally speaking, ABI version numbers and in particular changing them
> is a bad idea. However since this is in debugfs, we don't put any
> API stability rules on the interface according to
> Documentation/filesystems/debugfs.txt, and we can take the easy way
> out here; anyone using the frame dump feature can probably work out
> the differences here.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

f87eba996bac rt2x00: use monotonic timestamps for frame dump

-- 
https://patchwork.kernel.org/patch/10043531/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
