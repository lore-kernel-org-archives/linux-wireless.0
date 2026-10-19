Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792442016;
	b=V4lGrnatUpLZWHKUwAhnQ6pQCdlH6p6HPWaBIk0DFImmFSO3exrHKyIeNyHAwOWQqidx
	 a0557N3btwujD/1e3scWDRmHDdjP2JAyQO3qXK0cr2hBmtlsweMb4cHdRtKCSplMfqwk7
	 3OeVCLDGyq1D5uHsOXaVRVfx8D+HszTdzHOAjKtAaJgWf7VQ0auOjFbr268oujwinjiPT
	 kwmtUtu78BX9NcILvg7e0X6Nt4OGxqHrL9BDIRzQCmt0lwKQ2yAaY6bmahlNQHAfey4ZQ
	 NGid0rm7WcwqXLZYJUIpLimxPNF+YWanywbryPy//1Z9sga9FpLb5mgsy5s5DmhDuuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792442016;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type;
	bh=MBUi8rlfbbq2lbt95v37BFVzzpxuMUQ2XKcAjzcn8dk=;
	b=xtiyRdvjTJ9pnQ0nZfLShKWztSTJqc47Xy7DD0Zt056vHVlJI1mo1xPtUw0hskDDT191
	 0J7tBNDjslVWuyPnPb+Kj+z8AvM0T64Wf/OUPgpkiWvEPrhybTsG9tQC+AZDTFL1A0NNA
	 2z3hxKMLdjwcXppzGKOHoRA8hS4FVY/+1/k+YBhOYmKTVXEyM7KzqPTuHroBlq3UdafA3
	 nduoTj+iE1xh2XGi2O5apvj8NdHlS5OQ4uH9xgEYqFekOTPPZOqzEsUzCuIuQHu4pdSDw
	 G9aotxgbQ6zBH1FabcjytLdzT+KlsNa0cgVyrMIaMqewW9tYCrHyK93Il9IAPhj6hsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C477E606A319;
	Mon, 19 Oct 2026 20:33:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C477E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Tomas Tonhauser <t.tonhauser@pobox.sk>, linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>, linux-kernel@vger.kernel.org, Tomas
 Tonhauser <t.tonhauser@pobox.sk>
Subject: Re: [RFC PATCH] wifi: ath9k: clear destination mask for
 non-aggregate frames
In-Reply-To: <20261003192957.761090-1-t.tonhauser@pobox.sk>
References: <20261003192957.761090-1-t.tonhauser@pobox.sk>
Date: Mon, 19 Oct 2026 22:33:33 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87mrs9v3aa.fsf@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Tomas Tonhauser <t.tonhauser@pobox.sk> writes:

> Frames to stations without an A-MPDU session (e.g. non-WMM/non-HT
> clients) use the non-aggregate path. If the hardware returns such a
> frame with ATH9K_TXERR_FILT, ath_tx_complete_buf() reports it to
> mac80211 as IEEE80211_TX_STAT_TX_FILTERED. For a station that is not
> in powersave, ieee80211_handle_filtered_frame() retries it once and
> drops it if it is filtered again.
>
> The aggregate path re-queues filtered subframes on tid->retry_q and
> sets tid->clear_ps_filter, so they are retransmitted until they get
> through.
>
> The result is downlink loss to awake non-WMM stations, while WMM/HT
> stations on the same radio are unaffected. On a QCA9563 AP with
> ESP8266 clients this caused 20-45% ping loss, with two TXERR_FILT
> completions per lost frame and no XRETRY failures.
>
> Set CLRDMASK on every non-aggregate frame. This restores the
> behaviour from before commit 5519541d5a5f ("ath9k: fix powersave
> frame filtering/buffering in AP mode") for the non-aggregate path
> only. The trade-off is that non-aggregate frames already queued in
> hardware when a station enters powersave may be sent to the sleeping
> station instead of being filtered.
>
> Assisted-by: LLM
> Signed-off-by: Tomas Tonhauser <t.tonhauser@pobox.sk>
> ---
> RFC: is this direction acceptable, or is one of the alternatives
> below preferred?

Hmm, no, I don't think unconditionally clearing the filter is the right
thing to do. See below.

> Setup: TP-Link EAP225 v3 (QCA9563, 2.4 GHz), OpenWrt 25.12.5,
> backports 6.18.26. Clients: ESP8266 running Tasmota, modem sleep
> disabled, associated without WMM (legacy rates).
>
> Ping from the AP to one client, 30 packets, 14 lost:
>
>   station "tx failed":             +14
>   station "tx retries":            +2
>   ath9k/xmit BE "TXERR Filtered":  +27
>   ath9k/xmit BE "MPDUs XRetried":  +0
>
> A second run: 12 lost, Filtered +28, XRetried +0.
>
> Ruled out:
>  - Client powersave: PS_STA never set in debugfs station flags, and a
>    monitor capture showed no client frames with the PM bit set.
>  - airtime_flags=0, aql_enable=0, nohwcrypt=1: no change.
>  - RF: signal -50..-64 dBm; a WMM/HT client on the same radio has
>    0 tx failed out of ~10k frames; the same ESP8266 hardware behind
>    an ath10k AP has no loss.
>
> With the patch: 500 pings to each of five ESP8266 clients, 0 lost.
>
> Open question: what sets the destination mask for stations that are
> awake and never hit XRETRY? 5519541d5a5f removed an unconditional
> CLRDMASK commented "needed for crypto errors", so the hardware may
> set it in other cases too.

This is a good question. Maybe Felix knows?

Regardless, of your alternatives:

> Alternatives:
>  1. Set CLRDMASK only when the station is not sleeping.
>  2. Re-queue filtered non-aggregate frames in ath9k for awake
>     stations, like the aggregate path does.
>  3. Allow more than one software retry in
>     ieee80211_handle_filtered_frame() for awake stations.

I think 2. makes the most sense. In fact, AFAICT, there is currently
*no* software retry logic for non-aggregated frames in ath9k? So you hit
it due to this weird filtering issue, but presumably random interference
can also just lead to losses if they exhaust the hardware retry chain.
But maybe this is not something that's noticeable because the hardware
retry chain is usually enough? Do you notice any errors/retries in your
AP stats after applying the fix (in normal usage, not just with a ping
test)?

Anyway, I don't think it's unreasonable to add the same retry logic to
non-aggregated frames that we have for aggregated ones, and the retry_q
seems like the simplest way to do that.

-Toke
