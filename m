Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C34442FAA
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 07:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111101; cv=none; b=Gd/3aI4cxARY1KlTCRbOgwYm6e+QrlrZfTy74uFbh3t4gIDtkLdT5gjhtD4uUc5cRTIpMQ0sqaDYSR/1iUnauVqgrwkglwv1twrn0Jzczzwzevxqe6vi2HRD+PPIhyQ5cKbyUkMFptZmKoawxAmOjwBGG//ldPLRBnpgh2dDWzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111101; c=relaxed/simple;
	bh=HB9C5ndooPOI51e03OLe09bTWsmJUn1p5fraMMQWLa0=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=ba1+Tqvh3lbqzjk6YO9VKw1AAtMpNycX8P8YcfoSty+XW+P2VY1IXUgcwiNbDNj5scW1bIrATHaCdedT1fkaKru8P+ZDMVI7w9AHqzysc7mDfeUVBSOFmhxWcgzHDYFb0tjMUJeA+m1V/6CFSc0OFM4lvXlZxmHNLxsIOjQad7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iP6Oly/0; arc=none smtp.client-ip=91.218.175.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iP6Oly/0"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HB9C5ndooPOI51e03OLe09bTWsmJUn1p5fraMMQWLa0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789111090; v=1; x=1789715890;
 b=iP6Oly/0cB3ZBTPLkNpILZgfiT+G1GvMkyonEqsxFEaaK2uHcfwBD5L5LeOrIxY28BEXij1q
 0ULlz/y7E9QJrtgvIx7wlnMXFKkx7efmPPTVzC8DzCWy006CUMQ3eWiMrbqPVmLilXvKnAXIIeo
 s0RPtqorbAabK+wJP8ZACL2o=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fa6f9a8f65eccf38;
	Fri, 11 Sep 2026 07:18:09 +0000
X-Mizu-Trace-ID: fa6f9a8f65eccf38
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 11 Sep 2026 07:18:09 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <c584533a7433cdcdd94c554621bb7d466854bd83@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] wifi: mwifiex: bound SDIO fw dump count by memory table
 size
To: briannorris@chromium.org, francesco@dolcini.it
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <7d886d74276c05eeb1b1698e31b72a5aed98612a@linux.dev>
References: <7d886d74276c05eeb1b1698e31b72a5aed98612a@linux.dev>

September 4, 2026 at 8:57 PM, "Tianchu Chen" <tianchu.chen@linux.dev mail=
to:tianchu.chen@linux.dev?to=3D%22Tianchu%20Chen%22%20%3Ctianchu.chen%40l=
inux.dev%3E > wrote:


>=20
>=20From: Tianchu Chen <flynnnchen@tencent.com>
>=20
>=20mwifiex_sdio_fw_dump() reads the number of memory regions (dump_num) =
from=20
>=20a device register and uses it to index the static 15-entry
> mem_type_mapping_tbl[] without any bounds check. A bogus device can
> report a dump_num larger than the table, making each loop iteration
> store a vmalloc pointer and a device-controlled size past the end
> of the table into adjacent .data (up to ~5.7KB when dump_num is 255).
>=20
>=20The dump path runs after command timeouts or firmware crashes, so a
> bogus device can first force an error to trigger the dump and
> then report a bogus dump_num.
>=20
>=20Aborting the dump only loses the firmware snapshot; the card reset=20
>=20that follows is unaffected, so error recovery still completes.
>=20
>=20Discovered by Atuin - Automated Vulnerability Discovery Engine.
>=20
>=20Fixes: 54881c6b37c8d ("mwifiex: add firmware dump feature for SDIO")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
>=20diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/ne=
t/wireless/marvell/mwifiex/sdio.c
> index f039d6f19183a..e40ca40418b30 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -2795,6 +2795,11 @@ static void mwifiex_sdio_fw_dump(struct mwifiex_=
adapter *adapter)
>  mwifiex_dbg(adapter, ERROR, "SDIO read memory length err\n");
>  goto done;
>  }
> + if (dump_num > ARRAY_SIZE(mem_type_mapping_tbl)) {
> + mwifiex_dbg(adapter, ERROR,
> + "Invalid fw dump num: %d\n", dump_num);
> + goto done;
> + }
>=20=20
>=20 /* Read the length of every memory which will dump */
>  for (idx =3D 0; idx < dump_num; idx++) {
> --=20
>=202.51.0
>

Hi,

I noticed that this patch is marked as "Changes Requested" in
Wireless Patchwork, but I haven't received any review comments.

Could you please point me to the requested changes or the relevant
review message? I am happy to send a v2 once I know what should be improv=
ed.

Best regards,

Tianchu
