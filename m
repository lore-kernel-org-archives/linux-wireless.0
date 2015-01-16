Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48081 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbbAPNb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 08:31:57 -0500
Received: by mail-ie0-f170.google.com with SMTP id rd18so20633906iec.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 05:31:56 -0800 (PST)
Date: Fri, 16 Jan 2015 08:31:52 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: Avoid STA expiration timer truncation to u32
Message-ID: <20150116133152.GC10300@localhost> (sfid-20150116_143201_498620_9431A550)
References: <CAFk-A4kzcC9BhCtwqxjprRiXZeVPepBDXr3TvqvL6hn6J37UGw@mail.gmail.com>
 <1421389121-2841-1-git-send-email-masashi.honma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421389121-2841-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2015 at 03:18:41PM +0900, Masashi Honma wrote:
> On some combination of plink_timeout and HZ, the STA expiration timer will be
> unexpectedly truncated to u32. Maybe there is a question "Who sets such a large

Nice catch!

> -	ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout * HZ);
> +	ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout *
> +			     (unsigned long)HZ);

There's a remaining problem on 32-bit platforms: there, unsigned long
is 32 bits so 0xffffffff * HZ will still truncate to 32 bits.

For normal values of HZ though, result will still be 'a rather large
number,' so maybe it's not worth caring about that.

-- 
Bob Copeland %% http://bobcopeland.com/
