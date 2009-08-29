Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:49097 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZH2Ubk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2009 16:31:40 -0400
Message-ID: <4A999024.6060800@free.fr>
Date: Sat, 29 Aug 2009 22:31:32 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] [PATCH] rt2x00: Fix TX status reporting
References: <200908291910.14528.IvDoorn@gmail.com>
In-Reply-To: <200908291910.14528.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ivo van Doorn a écrit :
> Not all values of the TX status enumeration were covered during
> updating of the TX statistics. This could lead to wrong bitrate
> tuning but also wrong behavior in tools like hostapd.
>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
I have a pending patch about TX status that changed the meaning of
TXDONE_FALLBACK just a bit... just to avoid this change in fact.
I should be able to send those patches in few hours.

In my code, you success/failure of the packet is reported with
TXDONE_SUCCESS / TXDONE_FAILURE. The TXDONE_FALLBACK is set
independently to indicate that a fallback rate table has been used
(and this could be the case for either success or failure).

Regards,
Benoit

> --- drivers/net/wireless/rt2x00/rt2x00dev.c |   28
> ++++++++++++++++------------ 1 files changed, 16 insertions(+), 12
> deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c
> b/drivers/net/wireless/rt2x00/rt2x00dev.c index 5db613f..71761b3
> 100644 --- a/drivers/net/wireless/rt2x00/rt2x00dev.c +++
> b/drivers/net/wireless/rt2x00/rt2x00dev.c @@ -206,6 +206,7 @@ void
> rt2x00lib_txdone(struct queue_entry *entry, unsigned int
> header_length = ieee80211_get_hdrlen_from_skb(entry->skb); u8
> rate_idx, rate_flags, retry_rates; unsigned int i; +    bool success;
>
> /* * Unmap the skb. @@ -234,13 +235,18 @@ void
> rt2x00lib_txdone(struct queue_entry *entry,
> rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_TXDONE, entry->skb);
>
> /* -     * Update TX statistics. +     * Determine if the frame has been
> successfully transmitted. */ -    rt2x00dev->link.qual.tx_success += +
> success = test_bit(TXDONE_SUCCESS, &txdesc->flags) || -
> test_bit(TXDONE_UNKNOWN, &txdesc->flags); -
> rt2x00dev->link.qual.tx_failed += -        test_bit(TXDONE_FAILURE,
> &txdesc->flags); +        test_bit(TXDONE_UNKNOWN, &txdesc->flags) ||
> +        test_bit(TXDONE_FALLBACK, &txdesc->flags); + +    /* +     *
Update
> TX statistics. +     */ +    rt2x00dev->link.qual.tx_success += success;
> +    rt2x00dev->link.qual.tx_failed += !success;
>
> rate_idx = skbdesc->tx_rate_idx; rate_flags =
> skbdesc->tx_rate_flags; @@ -263,22 +269,20 @@ void
> rt2x00lib_txdone(struct queue_entry *entry,
> tx_info->status.rates[i].flags = rate_flags;
> tx_info->status.rates[i].count = 1; } -    if (i <
> (IEEE80211_TX_MAX_RATES -1)) +    if (i < (IEEE80211_TX_MAX_RATES -
> 1)) tx_info->status.rates[i].idx = -1; /* terminate */
>
> if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) { -        if
> (test_bit(TXDONE_SUCCESS, &txdesc->flags) || -
> test_bit(TXDONE_UNKNOWN, &txdesc->flags)) +        if (success)
> tx_info->flags |= IEEE80211_TX_STAT_ACK; -        else if
> (test_bit(TXDONE_FAILURE, &txdesc->flags)) +        else
> rt2x00dev->low_level_stats.dot11ACKFailureCount++; }
>
> if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) { -        if
> (test_bit(TXDONE_SUCCESS, &txdesc->flags) || -
> test_bit(TXDONE_UNKNOWN, &txdesc->flags)) +        if (success)
> rt2x00dev->low_level_stats.dot11RTSSuccessCount++; -        else if
> (test_bit(TXDONE_FAILURE, &txdesc->flags)) +        else
> rt2x00dev->low_level_stats.dot11RTSFailureCount++; }
>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqZkB8ACgkQOR6EySwP7oKnaQCglW+lu167n88CR3Chv1i4uF1P
I1kAoLrVvvXCbmzWN8M2/wHtyTSCnUZu
=IJEh
-----END PGP SIGNATURE-----

