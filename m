Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:35280 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZBZXTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 18:19:16 -0500
Message-ID: <49A7236E.2020807@gmail.com> (sfid-20090227_001920_599639_222317F1)
Date: Fri, 27 Feb 2009 00:19:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	linux-kernel@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com> <20090226230338.M86894@bobcopeland.com>
In-Reply-To: <20090226230338.M86894@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27.2.2009 00:15, Bob Copeland wrote:
> Speaking of, I think there's another potential oob array access at:
>
> if (rxs.rate_idx>= 0&&  rs.rs_rate ==
>      sc->curband->bitrates[rxs.rate_idx].hw_value_short)
>          rxs.flag |= RX_FLAG_SHORTPRE;
>
> because sc->rate_idx is u8 instead of s8.

strcmp("sc->rate_idx", "rxs.rate_idx") != 0 :)

Or did I miss something?
