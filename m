Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:43938 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752796AbeEGVVe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 17:21:34 -0400
Message-ID: <1525728090.6222.1.camel@sipsolutions.net> (sfid-20180507_232137_196018_D49580FE)
Subject: Re: [PATCH 2/3] iw: Print TXQ statistics for stations and interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Mon, 07 May 2018 23:21:30 +0200
In-Reply-To: <20180219170224.14816-3-toke@toke.dk> (sfid-20180219_180319_201142_47E9DB27)
References: <20180219170224.14816-1-toke@toke.dk>
         <20180219170224.14816-3-toke@toke.dk>
         (sfid-20180219_180319_201142_47E9DB27)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-19 at 18:02 +0100, Toke Høiland-Jørgensen wrote:
> 
> +	if (header && tid >= 0)
> +		pos += snprintf(buf, buflen, "\n\t\tTID\tqsz-byt\t"
> +				"qsz-pkt\tflows\tdrops\tmarks\toverlmt\t"
> +				"hashcol\ttx-bytes\ttx-packets");
> +	else if (header)
> +		pos += snprintf(buf, buflen, "\n\t\tqsz-byt\t"
> +				"qsz-pkt\tflows\tdrops\tmarks\toverlmt\t"
> +				"hashcol\ttx-bytes\ttx-packets");
> +
> +	if (tid >= 0)
> +		pos += snprintf(pos, buflen - (pos - buf), "\n\t\t%d", tid);
> +	else
> +		pos += snprintf(pos, buflen - (pos - buf), "\n\t");
> +
> +	txqinfo = txqstats_info[NL80211_TXQ_STATS_BACKLOG_BYTES];
> +	if (txqinfo)
> +		pos += snprintf(pos, buflen - (pos - buf), "\t%u",
> +				nla_get_u32(txqinfo));

since the header is fixed, shouldn't all of these get an else branch
that just prints a tab or so?

johannes
