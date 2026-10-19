Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C823033E1
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 12:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792413845; cv=pass; b=WtgGOaGzv/5zJTGnfJSpAEqO1+KUU/jHswjBAD7KHGVrF2oz2GFtdS3vKokHG2Y8yQW7JgIHWAhBh4WlMQITHXagGasUsiOGslw3a1Bmm7VTA+Wicjflc9NM6JcqHTlYEJ4Bg7s9lCEt/acfmqRipzxCctwoZkr7KZfLmRgzZ94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792413845; c=relaxed/simple;
	bh=PzYyYBu++GbxtLOvUa7jFIhv2/GhJZdHYK9iQRhrFBA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tAFjt+c+ESlejK0YrPMlW0o6erAoamfcANVwDSDa1q6YavZ8UqIfERAfg/j8eNvNpWrgDjH2cntpCK14RBJB+Epy2bMnxXyVxjUaoqlDuO/py6zEerMUABPuefZNDJhlYFpjqchZ/ri5j02R4fxkndDSFFKHTJC1qMg9JsYHdB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=matthew.leach@collabora.com header.b=QI1BeTRl; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=matthew.leach@collabora.com header.b="QI1BeTRl"
ARC-Seal: i=1; a=rsa-sha256; t=1792413828; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=U6eU0aJoHk38UWdGoHfoiHBiArz/xYx5zNJdpGOxmbe+udiJgwXOqpFXRiPONb9xuVV4PeiCLBPbMBKXTkRuY6sVGE0N6IB1DlNuD5XOI7KR2GxljBuUTC74Z4cbItVo/j98GhB2N3NrMpwbtQS4qCmLB//3/CXVkC/q3OXRohY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1792413828; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=RhEcvchSukxXA2zC00AL2afNWLNgZgcDlycHPL/Nw4Y=; 
	b=c6m14u4NZtzsSyZzmXuwKfqBiLATvL81Ql9CJDaFzWsdk1hOG5r5O6M7/xWbgC0Vb/6zsRG1Cdj/FYWdpB0A+25Xbh0mug9fszSXU9dy9wC9iAgRKznGD7zDzArluSy5tKUOaa2Ai5KFSsmlfECirsX0JUQ7MymhVRANAag4NGQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=matthew.leach@collabora.com;
	dmarc=pass header.from=<matthew.leach@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792413828;
	s=zohomail; d=collabora.com; i=matthew.leach@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:In-Reply-To:Date:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=RhEcvchSukxXA2zC00AL2afNWLNgZgcDlycHPL/Nw4Y=;
	b=QI1BeTRlr+KJ9c3CUsGDiObvm/wne8VPLSAn4pQKpuDqiu+7u3SWz9HT0wSba0t2
	p5g7EXw0Qv5kz6ZCj0iQa8On24eXeO8e22D9q5ySy+GUvuO+Ah6v/e9a+q5f2ek7KXV
	99CrSJyKkLvwD3v5uluSygJmz7Etu24pxHrN82M8=
Received: by smtp.zohomail.com with SMTPS id 1792413825421562.9698600060245;
	Mon, 19 Oct 2026 05:43:45 -0700 (PDT)
From: Matthew Leach <matthew.leach@collabora.com>
To: "Luka Gejak" <luka.gejak@linux.dev>
Cc: "Bob Beckett" <bob.beckett@collabora.com>,  "Ping-Ke Shih"
 <pkshih@realtek.com>,  linux-wireless@vger.kernel.org,
  kernel@collabora.com
Subject: Re: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted,
 poisoning CCMP replay counter
In-Reply-To: <3839685695b77706f39cfdef192e1d137e9d46bc@linux.dev>
References: <20261016191100.1781056-1-bob.beckett@collabora.com>
	<3839685695b77706f39cfdef192e1d137e9d46bc@linux.dev>
User-Agent: mu4e 1.14.3; emacs 31.1
Date: Mon, 19 Oct 2026 13:43:33 +0100
Message-ID: <87wlrdc13e.fsf@collabora.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External

"Luka Gejak" <luka.gejak@linux.dev> writes:

> Hi Bob,

Hi Luka,

> Thanks for the write up. I have a different read on this one. I don't
> think those frames were decrypted at all, and I think the descriptor
> is telling us less than it looks. Notes below.

Thanks for taking the time to look at this.

>> the bytes from the CCMP header onwards are garbage.
>
> That data is not from this frame. Your jump 2 dump shows where it
> comes from. The drv_info area is the 32 bytes at offset 24, and the
> hardware leaves it alone when PHYST is 0, so whatever is siting there
> is old. At offset 32 there is a whole RX descriptor, same w0, w1, w3
> and w4 as the live one, w2 sequence number 0xc5d and TSF 0x0042a3fa.
> The live frame is sequence 0xc66 with TSF 0x0042a4f3. So that memory
> is from ~9 frames and ~250us earlier.
>
> The ring has 512 buffers and one frame per buffer, so the same buffer
> only comes around again after about 512 frames. Data from approx. 9
> frames ago can't be leftover from the last time that buffer was used,
> so I think the hardware wrote it for some other frame. So for the
> frame we got, the hardware wrote the descriptor and the 802.11 header
> and then stopped, and the rest of the buffer still had that other
> frame in it.
>
> Same for the feame 3. Its first four CCMP bytes are 44(PN0) 50(PN1)
> 00(the zero reserved byte) 20 (ExtIV), so that write got four bytes in
> the CCMP header and then stopped.

The fresh header followed by unexpected contents is consistent with an
incomplete write, although I don't think we can distinguish that from
consuming the buffer before all payload writes are visible. Could we
compare the RX buffer contents when completion is first observed and
again before returning the buffer to the hardware? If the contents
change while the buffer is still host-owned, that would support
premature completion signalling.

>> our reading is that for these frames the payload/decrypt path produced
>> wrong data while the descriptor still reported CRC OK, ICV OK and
>> hardware decrypted.
>
> I read it the other way. Nothing was decrypted into that area. The CRC, I=
CV
> and decrypt bits are the results of checks the hardware does before it ha=
nds
> the frame over,

My understanding is that BIT_AICV in RCR controls acceptance of
integrity-error frames, and it is unset in our register snapshots.
Hardware should therefore already be filtering those frames.

That doesn't rule out the scenario you describe, where the frame passes
the integrity check internally but the bytes delivered to host memory
are wrong. However, all four captured bad frames have ICV_ERR clear, so
checking that bit alone would not catch these examples.

> and the payload write is a separate step after those checks which just
> did not happen here. So a good descriptor doesn't mean the frame in
> the buffer is real.
>
> My guess for what takes the link down is that rtw_rx_query_rx_desc sets
> decrypted from swdec and the enc type alone, without looking at icv_err, =
and
> then rtw_rx_fill_rx_status sets RX_FLAG_DECRYPTED, with which mac80211
> reads the PN out of the frame itself and saves it as the last PN for the
> key, and it only rejects a PN that is lower. So one frame like this pins =
the
> key to a random PN, and everything after it is dropped as a replay until =
new
> keys go in.

Yes, this is our take. Somehow the bogus PN gets passed to mac80211.
That then poisons the kernel's own PN value, which causes all subsequent
packets, which have a good PN, to be dropped as replay attacks.

> I will send a patch that fixes this part  so you can test it. It should
> turn a dead link into a dropped frame, but either way the test will
> tell.

Thanks for that patch; I've taken a look. The CCMP-header validation
should catch jumps 1, 2 and 4. However, jump 3 has valid reserved/ExtIV
bytes (44 50 00 20) and corruption in the remaining PN bytes, so this
patch would retain RX_FLAG_DECRYPTED and still poison the replay
counter. This looks useful as a partial mitigation, but doesn=E2=80=99t yet
resolve the reported failure.

Regards,
--=20
Matt
