Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974348;
	b=PX4TNM9fH+7xMR6wCaYZH8H1tR5UkSm23VkXcpVlBFNUngU/AULNvhqV5QSC/9Bt7qu5
	 Hezww3KzH7Ddml/RyTDthw/bgvIOOtgIqTPsaDrkxjiNxEej8Kurf8Zc+eoy3OZBT7kEu
	 FbPE1r3yuobtZ9mliB1fQBnT2bDU7/2dybUWsuXPVUoTjPHSfui8T1yJmL4XamkHt0LIv
	 wiYXivK2cgwbiPT5AbYNMqtePwzvHwkVzEqjEvt1/MhioNVAqJDXncpY9wYX65vLuJsdg
	 Cp0aydGA33NP1tPq1UgXKk2AyeOpcqu22wQCyjakaAKqtR331bNjfVlNDwhw2EFljIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974348;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=pDszWt2O8xWUlpWZFCEmv6hjE8k3I41KbNzjqPl67H4=;
	b=epG8tjE+JUcIe1SQQZaJhD+nmSTdRf8jS5bfmapUbheW3TrT+6ZkfgDZlX6hkp35xqf9
	 S9ZEgrHRnX16CeHEnncN8WDySmRhxxB377W7reqvF+3DUi0LZ2mjERy6rXIbUJbbWcs4q
	 8BhyDqd1ud19ACvBqKh9EvAMc3/2d+X2khLnvgCafe6lD3tqZfz1iSyF/XvGTkMDGSFhz
	 CfHgOySMEDpw1PQeOeEXTlm5yOPLGT9+njhNMCKT5kLwiKjVR19SbuVukTVvgLa7no0rL
	 9YAXx9y2jcH5L6gBQealuH912fzu+8sN1IDgd2W5ibMkV5hspx82VbyfpA3aDGWQ7EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aN0qV6Ke;
	arc=none smtp.remote-ip=95.215.58.39
Received: from mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938B4606A329
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 14:12:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 938B4606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aN0qV6Ke
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=QqBNuzrjfZbjHla+WTeJYIytk3a9u7CZytU/jezPT2g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793974345; v=1; x=1794579145;
 b=aN0qV6KesEfGb8qJsU48KTHu7kCslk6FOpQyoXMjb87OV15RApZuPPXiQD/savkh5RplIAGQ
 Ypcazqh98j6BlAWgRy0ay+GYS+6+5nNl8xMxW1ZZUodErESjaZQq6BsIQxaZdN1/foN8hAFyzQU
 4cROx1GbQYA/uYgwcV/ZuFa0=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7ab2c0fdcb1c85a3;
	Fri, 06 Nov 2026 14:12:25 +0000
X-Mizu-Trace-ID: 7ab2c0fdcb1c85a3
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
Date: Fri, 06 Nov 2026 14:12:22 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <1537d31634016c22bbcc8d04f9a09a99b78286f7@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v3 2/2] wifi: rtw88: check the C2H payload
 length before reading it
To: "Huihui Huang" <hhhuang@smu.edu.sg>, linux-wireless@vger.kernel.org
Cc: "Huihui Huang" <hhhuang@smu.edu.sg>, "Ping-Ke Shih" <pkshih@realtek.com>
In-Reply-To: <20261105125958.3891196-3-hhhuang@smu.edu.sg>
References: <20261105125958.3891196-1-hhhuang@smu.edu.sg>
 <20261105125958.3891196-3-hhhuang@smu.edu.sg>

November 5, 2026 at 1:59 PM, "Huihui Huang" <hhhuang@smu.edu.sg> wrote:

>=20
>=20With the previous patch, a C2H packet holds at least the 2-byte C2H
> header, but its payload can still be shorter than what the handlers
> read. These handlers read fixed payload offsets without checking the
> payload length:
>=20
>=20 - rtw_fw_scan_result() reads payload[0];
>  - rtw_coex_info_response() reads payload[0];
>  - rtw_fw_c2h_cmd_handle_ext() reads the sub-command ID in payload[0],
>  and rtw_hw_scan_status_report() and rtw_hw_scan_chan_switch() read
>  up to payload[2] and payload[4];
>  - rtw_tx_report_handle() reads up to payload[6] for C2H_CCX_TX_RPT and
>  payload[9] for C2H_CCX_RPT.
>=20
>=20With a short payload, these reads are beyond skb->len.
>=20
>=20Add rtw_c2h_payload_len() to get the payload length of a C2H skb, and
> ignore C2H packets whose payload is too short for the fields the
> handler reads. For C2H_SCAN_RESULT, check the length before completing
> fw_scan_density, so that a report without payload does not wake the
> waiter. A short HW scan status report is not ignored but completes the
> scan as aborted; otherwise the scan stays pending until something
> aborts it.
>=20
>=20For coexistence responses, this only validates the byte inspected by
> rtw_coex_info_response(). Length validation for the queued response's
> GET_COEX_RESP_*() consumers is left for a separate follow-up.
>=20
>=20Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Fixes: 4136214f7c46 ("rtw88: add BT co-existence support")
> Fixes: a853d234e179 ("rtw88: notify fw when driver in scan-period to av=
oid potential problem")
> Fixes: 10d162b2ed39 ("rtw88: 8822c: add ieee80211_ops::hw_scan")
> Suggested-by: Luka Gejak <luka.gejak@linux.dev>
> Assisted-by: LLM
> Signed-off-by: Huihui Huang <hhhuang@smu.edu.sg>
> ---

Looking good to me,

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
