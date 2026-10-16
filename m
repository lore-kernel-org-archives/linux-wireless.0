Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692AF43F4C2
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 22:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792188918; cv=none; b=JdAxpd3hWkuJ/dyjCEGpJK+A9zwBHR1UiTsNI5fcTB9O8xYLgM9uT2RVFQEinGPpOuxAJaVK6/o6YG6cL/nCCzAVDii16TStQAiCKDYLRazCjpv9VVhtFibbBu3fCdxOlNM/HtJDT8P7x76/mibv/sxokXDiVHaEgMUeYsIh/4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792188918; c=relaxed/simple;
	bh=ya2SUx4Iwa3qzESNPW0+Yao/WLqVAoAMZLWJPB3x1yI=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=kAOcNNiwkVnHPX46ykZ3qbwuLblLURVNqno4Q+IteK1vVU3qSjquNT/34tzvc5OJXQ0WDZxmD9ygws7ZKoyEuh0JpvC9OrMTRjEnHMWMB/uF2KDObbulzjSR97lhTmWFAbJlifg10l1XN2YgQogqOtKJGlU4UDnvDTlT1rusK50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f4hFOpO2; arc=none smtp.client-ip=91.218.175.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f4hFOpO2"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ya2SUx4Iwa3qzESNPW0+Yao/WLqVAoAMZLWJPB3x1yI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792188911; v=1; x=1792793711;
 b=f4hFOpO2+xsdOku5l1KgUes+rMSPDWm0FTnQNL59E5SRcdv6PTW+An6eW4R6jIpM5DRQQ93e
 8gAHVhqbplGekSkmuiP/V1YnLG4VepOP/GSAb7XJfFnG3dd6+veHECernzQegoL1eYtJvFpRvaz
 +dkd/CGnghmdVDb+yY+aocmg=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b8486ec550626561;
	Fri, 16 Oct 2026 22:15:10 +0000
X-Mizu-Trace-ID: b8486ec550626561
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 16 Oct 2026 22:15:10 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <3839685695b77706f39cfdef192e1d137e9d46bc@linux.dev>
TLS-Required: No
Subject: Re: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted,
 poisoning CCMP replay counter
To: "Bob Beckett" <bob.beckett@collabora.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, kernel@collabora.com,
 matthew.leach@collabora.com
In-Reply-To: <20261016191100.1781056-1-bob.beckett@collabora.com>
References: <20261016191100.1781056-1-bob.beckett@collabora.com>

Hi Bob,

Thanks for the write up. I have a different read on this one. I don't thi=
nk
those frames were decrypted at all, and I think the descriptor is telling=
 us
less than it looks. Notes below.

> the bytes from the CCMP header onwards are garbage.

That data is not from this frame. Your jump 2 dump shows where it comes
from. The drv_info area is the 32 bytes at offset 24, and the hardware
leaves it alone when PHYST is 0, so whatever is siting there is old. At
offset 32 there is a whole RX descriptor, same w0, w1, w3 and w4 as the l=
ive
one, w2 sequence number 0xc5d and TSF 0x0042a3fa. The live frame is seque=
nce
0xc66 with TSF 0x0042a4f3. So that memory is from ~9 frames and ~250us
earlier.

The ring has 512 buffers and one frame per buffer, so the same buffer onl=
y
comes around again after about 512 frames. Data from approx. 9 frames
ago can't be leftover from the last time that buffer was used, so I
think the hardware wrote it for some other frame. So for the frame we
got, the hardware wrote the descriptor
and the 802.11 header and then stopped, and the rest of the buffer
still had that other frame in it.

Same for the feame 3. Its first four CCMP bytes are 44(PN0) 50(PN1)
00(the zero reserved byte) 20 (ExtIV), so that write got four bytes
in the CCMP header and then stopped.

> our reading is that for these frames the payload/decrypt path produced
> wrong data while the descriptor still reported CRC OK, ICV OK and
> hardware decrypted.

I read it the other way. Nothing was decrypted into that area. The CRC, I=
CV
and decrypt bits are the results of checks the hardware does before it ha=
nds
the frame over, and the payload write is a separate step after those chec=
ks
which just did not happen here. So a good descriptor doesn't mean the fra=
me
in the buffer is real.

My guess for what takes the link down is that rtw_rx_query_rx_desc sets
decrypted from swdec and the enc type alone, without looking at icv_err, =
and
then rtw_rx_fill_rx_status sets RX_FLAG_DECRYPTED, with which mac80211
reads the PN out of the frame itself and saves it as the last PN for the
key, and it only rejects a PN that is lower. So one frame like this pins =
the
key to a random PN, and everything after it is dropped as a replay until =
new
keys go in.

I will send a patch that fixes this part  so you can test it. It should
turn a dead link into a dropped frame, but either way the test will tell.

Best regards,
Luka Gejak
