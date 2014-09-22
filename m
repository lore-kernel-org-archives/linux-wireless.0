Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21334 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbaIVKwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 06:52:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath10k: dump hex bytes with dev string prefix
References: <1411046721-20510-1-git-send-email-michal.kazior@tieto.com>
	<1411046721-20510-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 22 Sep 2014 13:52:05 +0300
In-Reply-To: <1411046721-20510-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 18 Sep 2014 15:25:20 +0200")
Message-ID: <877g0wlyga.fsf@kamboji.qca.qualcomm.com> (sfid-20140922_125240_773381_A9DF6E61)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This makes it easier to debug hex dumps on systems
> with more than a single ath10k device.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> -		print_hex_dump_bytes(prefix, DUMP_PREFIX_OFFSET, buf, len);
> +		for (ptr = buf; (ptr - buf) < len; ptr += 16) {
> +			linebuflen = 0;
> +			if (prefix)
> +				linebuflen += scnprintf(linebuf + linebuflen,
> +							sizeof(linebuf) -
> +							linebuflen,
> +							"%s", prefix);
> +			linebuflen += scnprintf(linebuf + linebuflen,
> +						sizeof(linebuf) - linebuflen,
> +						"%08x: ",
> +						(unsigned int)(ptr - buf));
> +			hex_dump_to_buffer(ptr, len - (ptr - buf), 16, 1,
> +					   linebuf + linebuflen,
> +					   sizeof(linebuf) - linebuflen, true);
> +			dev_printk(KERN_DEBUG, ar->dev, "%s\n", linebuf);
> +		}

Would it be possible to simplify this to one scnprintf()? Something
like:

linebuflen += scnprintf(linebuf + linebuflen,
			sizeof(linebuf) - linebuflen,
			"%s%08x: ",
                        prefix ? prefix : "",
			(unsigned int)(ptr - buf));

-- 
Kalle Valo
