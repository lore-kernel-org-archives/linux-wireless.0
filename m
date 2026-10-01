Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E462E06EF
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 20:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790885406; cv=none; b=r1JYIXeqGEzJmi0ImGirkTMqvZkPKDP91taq33TaLoGhWmDHYH1p0tGgRkIUuqmGA3DYd0dO59fTzSkpgTLcy4y3JEsoXfDhhGZ0iTe0xvoGRQmByLslVyldQ5tkh8PPdc+X1riUVKRwblfoGUd78RqyxaE+G27Ai2rPkWNDWxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790885406; c=relaxed/simple;
	bh=Rjp0U9hUwn+qiMeIsQrMbi4eF0/wkHWAEEekOXWxHhM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QjLYPrahf+lOPQJREIpb1xgLZ/Me2Yd6REVKEocmDCGpkHO5mNzXmErp+go2MfEwkDYicKtyzkKQnkJB1kUy1JXU2ap1+j0ceWZN2WSkGGOF65N0GskMTtY24A8bSYjvk69uAZ01hg27nscOJcA7NA2TTbgXcHYjCVtJWmeTy6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=FyvBH68H; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="FyvBH68H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=RNsq/v19YBRrUAL0BHwiYo7xk9yLVcrWk7GT0QzkaOs=;
	t=1790885403; x=1792095003; b=FyvBH68HG4q74Pge+6RHIs+YSNQFsArjMRw0WXL3oR04SAU
	9QJcDM6+l+4co2W5bZOSOURr80Q6hDAsh7USlxhw+iVMZ39YzJjUdx1AdNkTNsmW74sS/AAsDLX2p
	K1ABVjJUHdmdvc6YzoqMjiepH1n1WwKhsmfYXJWqZqSYC+VvFaKUYlEcVKaRCRs18arom+Jhcc3tb
	Zbem+JPm63KZN7dzv1MSXDXBIeJm/eqXnS+vmVJ9zqkBvmIepbcTNRgSOr9WzHy4GEL2nwi74bmfY
	rysuRVu4nxl5NusLDP2BYjLr9DnZ7PHNkrKQA55EC+22pVNW8Jll/DBaxRxeziXw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCN6N-00000000QYh-3JKq;
	Thu, 01 Oct 2026 22:10:00 +0200
Message-ID: <fc91329053c0cbedecf51bcccd4a0e74eba850e5.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next v2 09/16] wifi: mac80211: Define layouts
 for SMD BSS Transition context
From: Johannes Berg <johannes@sipsolutions.net>
To: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 01 Oct 2026 22:09:58 +0200
In-Reply-To: <20260924-smd-v2-9-bb40094da1d4@oss.qualcomm.com>
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
	 <20260924-smd-v2-9-bb40094da1d4@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

[dropping CC's, I have no idea why you CC'ed hardening?!?]

On Thu, 2026-09-24 at 08:10 +0530, Pooventhiran G wrote:
> IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.9, defines the context
> data to be transported during SMD BSS Transition (ST) laid out in
> subclause 37.16. The station's context data is attached to the ST
> Preparation or Execution Request action frames so that userspace
> receives the context along with the relevant frame.
>=20
> Define the context data: per-TID sequence numbers (SN) in downlink (DL)
> and uplink (UL) directions, packet number (PN) in DL, per-TID packet
> numbers in UL, and per-TID BlockAck session parameters in DL and UL;
> along with this, define an optional driver context. This data is used by
> drivers to report the context along with the frame SKB.


Just a couple of _very_ quick comments, having imported this to my tree
to compare notes with the client side implementation I'm working on:

> Signed-off-by: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
> ---
>  include/linux/ieee80211-uhr.h | 86 +++++++++++++++++++++++++++++++++++++=
++++++

This isn't really mac80211 (commit subject), but I also don't think this
should be defined here at all. I mean, I get why - the spec defines what
needs to be transferred, but it doesn't actually define the _layout_ of
the data and it's never used over the air, so I think it'd be confusing
to have it here anyway.

Probably should define it in cfg80211.h instead, since it's used all the
way through nl80211 down to the driver(s)?

>  1 file changed, 86 insertions(+)
>=20
> diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.=
h
> index c3f87d4c8bec..e6aaef9ae9e6 100644
> --- a/include/linux/ieee80211-uhr.h
> +++ b/include/linux/ieee80211-uhr.h
> @@ -649,6 +649,92 @@ struct ieee80211_uhr_mode_change_tuple {
>  	u8 variable[];
>  } __packed;
> =20
> +/*
> + * Context information carried in SMD BSS Transition (refer IEEE P802.11=
bn/D2.0,
> + * Aug 2026, subclause 37.16.9.
> + */
> +#define IEEE80211_SMD_CTX_NUM_VALID_CTX    8

Why is there such an arbitrary limitation?

> +/**
> + * struct ieee80211_smd_ctx_ba - BlockAck parameters for DL and UL
> + *
> + * @amsdu_supported: Peer's capability to support A-MSDU within A-MPDU.
> + * @ba_policy: BlockAck policy (0 =3D delayed BlockAck, 1 =3D immediate =
BlockAck)
> + * @buffer_size: Reorder buffer size from ADDBA Request (10-bit, max 102=
3)
> + * @timeout: BlockAck session timeout
> + * @ext_no_frag: ADDBA Extension fragmentation support
> + * @extfrag_level: ADDBA Extension HE fragmentation level
> + * @ext_buffer_size: ADDBA Extension buffer size; combined with @buffer_=
size as
> + *	(@ext_buffer_size << 10 | @buffer_size) to get the full reorder
> + *	buffer size
> + */
> +struct ieee80211_smd_ctx_ba {
> +	bool amsdu_supported;
> +	u8 ba_policy;
> +	u16 buffer_size;
> +	u16 timeout;
> +	bool ext_no_frag;
> +	u8 extfrag_level;
> +	u16 ext_buffer_size;
> +};

What about WinStartO?

Though I honestly lost track of where the spec is going with all the
options of transfer/not transfer - need to try to catch up next week.

> +/**
> + * struct ieee80211_smd_ctx - IEEE 802.11bn SMD Roaming Context (refer
> + *	IEEE P802.11bn/D2.0, Aug 2026, subclause 37.16.9)
> + *
> + * @valid_ctx_bmap: Bitmap indicating which context fields are valid;
> + *	bit positions defined by IEEE80211_SMD_CTX_VALID_* constants
> + * @pn_len: Length of PN in bytes; varies by cipher type
> + *	(e.g. CCMP (6), GCMP-256 (16))
> + * @dl: Down-link context data
> + * @dl.valid_tid_bmap: valid DL TIDs for which context is present
> + * @dl.sn: DL SN per-TID to be assigned next
> + * @dl.pn: DL PN to be assigned next
> + * @dl.ba: DL BlockAck parameters per-TID for the BlockAck session
> + * @ul: Up-link context data
> + * @ul.valid_tid_bmap: valid UL TIDs for which context is present
> + * @ul.sn: UL SN per-TID to be checked next
> + * @ul.pn: UL PN per-TID to be checked next
> + * @ul.ba: UL BlockAck parameters per-TID for the BlockAck session
> + * @drv_ctx_size: Number of valid bytes in @drv_ctx.
> + * @drv_ctx: Variable-sized array of driver-specific context, counted by
> + *	@drv_ctx_size. Opaque to the wireless core; interpreted by drivers.
> + */
> +struct ieee80211_smd_ctx {
> +	DECLARE_BITMAP(valid_ctx_bmap, IEEE80211_SMD_CTX_NUM_VALID_CTX);

This seems overly complex for ... 4 bits? Could just have individual
valid:1 bitfield entries or something?

> +	u8 pn_len;
> +
> +	struct {
> +		DECLARE_BITMAP(valid_tid_bmap, IEEE80211_SMD_CTX_NUM_TIDS);
> +		u16 sn[IEEE80211_SMD_CTX_NUM_TIDS];

Aren't there more counters, e.g. for mgmt frames?

> +		u8 pn[IEEE80211_SMD_CTX_MAX_PN_LEN];
> +		struct ieee80211_smd_ctx_ba ba[IEEE80211_SMD_CTX_NUM_TIDS];
> +	} dl;

It feels like there should be some information here about "how many
frames are buffered for each TID" and mac80211 could increment that by
however many are buffered there, both to give the AP an ability to
estimate the downlink drain time, as well as how much to bump the PN
forward to by? Although the latter could just be like 1 million and
nobody cares.

> +	struct {
> +		DECLARE_BITMAP(valid_tid_bmap, IEEE80211_SMD_CTX_NUM_TIDS);

again I think the whole DECLARE_BITMAP is a bit of a contortion when
really you needed ... a u8? perhaps a u16 or u32 when accounting for
mgmt? still not longer than the "unsigned long" this results in, and
seems way more understandable?

(and wouldn't even have the kernel-doc problem)

> +		u16 sn[IEEE80211_SMD_CTX_NUM_TIDS];
> +		u8 pn[IEEE80211_SMD_CTX_NUM_TIDS][IEEE80211_SMD_CTX_MAX_PN_LEN];

Does this even need to be per TID? I guess I could see that maybe it
must be, but if so you forgot mgmt frames here too?

I'd also love for you to think about hwsim supporting this - in that
case mac80211 maintains a lot of this data. Having mac80211 fill in some
data unconditionally though seems brittle - what if the driver just
forgot the PN and then mac80211 says "sure the PN is 0" because
something, so ideally drivers would somehow say "this should be filled
in from mac80211 software state" or something.

johannes
