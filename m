Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38742 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746Ab3CGVcp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 16:32:45 -0500
Received: by mail-ie0-f182.google.com with SMTP id k14so1206398iea.13
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 13:32:45 -0800 (PST)
Date: Thu, 7 Mar 2013 16:32:49 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	thomas@net.t-labs.tu-berlin.de, johannes@sipsolutions.net,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: Question regarding minstrel(_ht) and retry limits
Message-ID: <20130307213248.GF14175@localhost> (sfid-20130307_223250_021065_DCE16558)
References: <20130307153100.GA30608@pandem0nium>
 <5138B69C.4000102@openwrt.org>
 <20130307180635.GA31210@pandem0nium>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130307180635.GA31210@pandem0nium>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 07, 2013 at 07:06:35PM +0100, Simon Wunderlich wrote:
> Are there any theoritical constraints to consider? I don't know too much
> about minstrel theory, but from what I understand:
> 
> The ieee80211_tx_rate array has 4 entries with rate + count number, where
> the last entries may be empty (count = 0).

>From what I understand, essentially all legacy Minstrel tries to do is
pick more transmissions for higher rates (since airtime for those will
generally be less) and then a certain base level for the minimal fallback
rate.[1]

My guess would be that it would be "better" to scale the retries by the
desired number of total retries rather than just subtracting the same
amount from each rate.  I think you could do the scaling without divides.
At the least, you'd want to keep some minimal number in the base rate
slot so that it gets used if all else fails.

[1] see minstrel_rate_init(); ostensibly, it does this by trying to fit
as many retransmissions per slot that will take 6 ms on a 1200 byte
frame.  It doesn't seem to account for the backoff between slots though
(it's all pre-computed per-rate), so the total tx time could be well
over 6x4=24 ms if all the retries were used.  Perhaps it's worth fixing
that, too.

-- 
Bob Copeland %% www.bobcopeland.com
