Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793610635;
	b=s2Px3vFDus4xefOktRSl28cU8dFq+spqtTbHBbqe+H3/ez9ZssqfR+Z3M8+zMDD+bZlU
	 so1KRYxXG6XyC8dyrbI41+JaV/eRXgqVPbKHrCYg9xNe6O3UKfP/NslQATge6vjShYp1g
	 JfKg+EvhjXGQhzBBx//08E3Hjld1kLLMCLkTqhqh596c95ZgOZbJ6FJWFZxBsVfHRLO7c
	 gn0YioeyF53mUJ11Ve+8fwVVGor55DDMGJWgnEh3MwhPhOOH1H8wv6zlULm5zbQo5Shic
	 pa6g1ktBM3iyEj5RmgLZlJSMS8GnZ2M7NGaCI7slIiha93MMVIQoSVPlqWq5e78OlsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793610635;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=K55TA0Xx4eo4x4aGz06tjfzrbSjfUgna9+vbhgB+sZc=;
	b=jk1wzxS6WRgeOoGtU34Ghar9/VCQ7RNzDHskzo84IvDk27m+62sCUelkFGWe4wARjKN5
	 rNAXcyOtG1aT1BkXW02TyfOzX+vtPInHpoORWiZgPG4x37zQ/FfI7VV1wbrUWFwW+5UQM
	 xWwI45S2bvog9VVEwbqaeg9MkuweTcXc6y9NwPoxBUdKu1wb0Uw3up8LmKvtBt9O7dUoi
	 lkrTG1vaSplytRm9Yf4dcEBBXVL9f1seWAM5oWCjXsHvEFEEVXswZ0QlsH9TOG4PNOQ5g
	 rcfXtT+jFoBUjrnqlOHFZHv1IWYD+7CZAypxDda6q1d7AiL9u5BjOLo7rAdBWiFABUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fnxzQQ3Z;
	arc=none smtp.remote-ip=91.218.175.197
Received: from mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A250606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 09:10:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A250606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fnxzQQ3Z
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=K55TA0Xx4eo4x4aGz06tjfzrbSjfUgna9+vbhgB+sZc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793610632; v=1; x=1794215432;
 b=fnxzQQ3Zu3WF8DdF4cQ36GOWNZc6NYHwUNXMQN0mEqIHdQoli/XhS62YTcLQ/I5V0NjtFiY7
 Va7Bo+3PVGRsWJNU9+/jgufh8PfB3SxTJBQSWFD0HuXj0mMdxMLQQVpkxzn/AzYf1F9ennOPZYa
 NJ/hwr1iQcvIisYhbjxfFvjQ=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8e8f11a4a2200b66;
	Mon, 02 Nov 2026 09:10:32 +0000
X-Mizu-Trace-ID: 8e8f11a4a2200b66
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 02 Nov 2026 09:10:31 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <b3e27bc36adc6f4682da6202382ef214209b7c89@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v2 1/2] wifi: rtw88: drop C2H packets shorter
 than the C2H header
To: "Huihui Huang" <hhhuang@smu.edu.sg>, linux-wireless@vger.kernel.org
Cc: "Huihui Huang" <hhhuang@smu.edu.sg>, "Ping-Ke Shih" <pkshih@realtek.com>,
 stable@vger.kernel.org
In-Reply-To: <20261031175621.2228762-2-hhhuang@smu.edu.sg>
References: <20261031175621.2228762-1-hhhuang@smu.edu.sg>
 <20261031175621.2228762-2-hhhuang@smu.edu.sg>

October 31, 2026 at 6:56 PM, "Huihui Huang" <hhhuang@smu.edu.sg> wrote:

>=20
>=20rtw_fw_c2h_cmd_rx_irqsafe() and rtw_fw_c2h_cmd_handle() compute the C=
2H
> payload length as
>=20
>=20 len =3D skb->len - pkt_offset - 2;
>=20
>=20where len is a u8, without checking that the skb holds the 2-byte C2H
> header (id and seq).
>=20
>=20If the header is incomplete, the C2H payload length underflows: zero
> bytes after pkt_offset produce len =3D 254, and one byte produces
> len =3D 255. With zero bytes, reading c2h->id also accesses data beyond
> skb->len. The wrapped len defeats the minimum-length checks in
> rtw_fw_ra_report_handle() and rtw_coex_wl_fwdbginfo_notify(), which the=
n
> read their fixed-size reports beyond the valid packet data.
>=20
>=20skb->len is pkt_offset plus pkt_len from the RX descriptor, and
> rtw_rx_query_rx_desc() returns for C2H packets before its
> "pkt_len <=3D FCS_LEN" check, so a short C2H packet is not rejected the=
re.
>=20
>=20Drop C2H packets that are too short to hold the C2H header. Since
> rtw_fw_c2h_cmd_handle() only sees skbs queued by
> rtw_fw_c2h_cmd_rx_irqsafe(), this covers both computations.
>=20
>=20Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Huihui Huang <hhhuang@smu.edu.sg>
> ---

Looking good to me.

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
