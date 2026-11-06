Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793967828;
	b=RkALrc54aCtoBnyglXWiEpCUnrobXxjvmrfejiDapNEyH+hK4N9N3JEL9UGgfVGDFroX
	 MxgKKre6EdsO5RjzGHvAiBO4CtT23R05D5Uey5tB8EDlmHDyFNmPQHgkYGcjQYshCkL0k
	 ZQQ+hXqb/l417EKy/M73T1sYSOXmtaLHrws8s4M3sZiQw16X7LU9KbfkPECuysbUyIhP5
	 MM5fYn9ZnqA35m0XEhmXb5rs2r0oich4z7DDFoAOcPeeaCeE+K8HMyVaSRc0CpcEWsYn5
	 IrG2i2jOQSypQqBZVuLDY68V99f3xQRgydGmelEN/9qA38hLJbzX3eVgGfWZvGbWhNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793967828;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type;
	bh=qyE6CYlL0hGqb8dHlLDDqpi1F8l3Odg8Urndse4foOU=;
	b=zyohj6jT86AYP0wGgq2LV3r5rBwRDo9caP4AnH5AFjy/S1dXE0tLa2CqSBEC2iPMSdHo
	 SSad/kSVwgLkfERp1DY9XHlLXGo3Ku/w1kvoLXJERqdE4v6TWAH2jdCj/bN9HXqje+Nxn
	 X3HxUKJ8fLDI1KMHWiNkgrO8lA9lqssy91CsqhxdcV6v1e9vf8YJVuDzoRPqZoXrur9d6
	 O7rJhtOuP8C2BsUhmB3GqkTQiZcSH2JpkIOBC9K6ZUYT47hcSPDgcMS9ZlQcAkFUnkkHI
	 2/9MrPpddxCOCvKV+yHdYJzs4g5NnaqceGGHYv97I6023MW+sknzQBwEq5lU3xxB1Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411C5606A326
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 12:23:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 411C5606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 14/30] wifi: mac80211: put filtered data frames back on
 TXQs
In-Reply-To: <20261102203831.1058362-46-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
 <20261102203831.1058362-46-johannes@sipsolutions.net>
Date: Fri, 06 Nov 2026 13:23:45 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87bj82p2r2.fsf@toke.dk>
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

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> When a device filters frames because the station went to
> sleep, we put them back on tx_filtered or pending queues.
> This can mix up ordering between TXQs and filtered frames
> when the station wakes up again later.
>
> Put filtered frames onto the frags queue of the TXQ they
> came from, fixing the order and simplifying the queueing
> structure in mac80211.
>
> Assisted-by: LLM
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/ht.c          |  5 ++++
>  net/mac80211/ieee80211_i.h |  5 +++-
>  net/mac80211/sta_info.c    | 52 +++++++++++++++++++++++++++++++++++-
>  net/mac80211/sta_info.h    |  4 ++-
>  net/mac80211/status.c      | 54 +++++++++++++++++++++++++++++++++++++-
>  net/mac80211/tx.c          | 37 ++++++++++++++++++++++++++
>  6 files changed, 153 insertions(+), 4 deletions(-)
>
> diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
> index c5c2113fa4f7..e26d12659942 100644
> --- a/net/mac80211/ht.c
> +++ b/net/mac80211/ht.c
> @@ -372,6 +372,11 @@ void ieee80211_ba_session_work(struct wiphy *wiphy, struct wiphy_work *work)
>  			/* Allow only frags to be dequeued */
>  			set_bit(IEEE80211_TXQ_STOP, &txqi->flags);
>  
> +			/*
> +			 * Fragments and filtered frames (which already have a
> +			 * sequence number) must be out before aggregation
> +			 * starts, otherwise they'd be sent as part of it.
> +			 */
>  			if (!skb_queue_empty(&txqi->frags)) {
>  				/* Fragmented Tx is ongoing, wait for it to
>  				 * finish. Reschedule worker to retry later.
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index cb947341fee6..4a9b68022250 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -987,7 +987,8 @@ enum txq_info_flags {
>   * @tin: contains packets split into multiple flows
>   * @def_cvars: codel vars for the @tin's default_flow
>   * @cstats: code statistics for this queue
> - * @frags: used to keep fragments created after dequeue
> + * @frags: used to keep fragments created after dequeue, and frames that
> + *	were filtered by the device (queued before the fragments)

Hmm, so rather than splicing these two together in one queue and having
all that logic to insert into the middle, and to walk the queue to check
flags, isn't it simpler to just have two distinct queues as struct
members and check them in order on dequeue?

-Toke
