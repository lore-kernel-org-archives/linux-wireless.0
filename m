Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3883CEBBB
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 07:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787642862; cv=none; b=W/V19R6AcHjUvU/CqmU115gvyoXWZ6aB8MBm3u5SjnxW5vbFdhjcgElRI6rXsY+Jvk4obyGhP9hxn2zytbc6efdpR08jLHCOjMFVFqzMpVByupDHII8SDGpLf2DsA27+2UcdQoW5hhoNnKd5NnHyPKmQLeFihL8NoSOPPoj12Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787642862; c=relaxed/simple;
	bh=ULc4ecBY+5/nyj5zanJ+5kJTiRfyfSTqD4TSlVKMqJM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=NYtxg9CWgGuM+76+ZnSpYLeO4vpspzWDLkJ9JWGOYO0Lo9puLmT3ERl4htZN/drIIUZQ1dX48c6yWVdbQsS4QdWSWSO5FXpCBEdz0DgVMszCCecCvC8+uigOWS/7tS+r4S6GSmb2m5yExCsd4yiREiUIHMspFmcBtp/QXIN3Wpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IXRqC0XZ; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IXRqC0XZ"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ULc4ecBY+5/nyj5zanJ+5kJTiRfyfSTqD4TSlVKMqJM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787642858; v=1; x=1788247658;
 b=IXRqC0XZx9x1/mfRTiXg8F/ZmaHvnoxgTr25URViMKSkTsliw3MCrjJ1UlEp/w/OmkKYyceX
 E14mWEfmNGUCAb0L9TMAWhGnXykGVQQ6f4kECNikp7gu1qtqJdGIpW2I1L+p7+doZxxrawVRrtz
 Mhccm8r0gKFSd/j1jw5LAFio=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (31.223.131.35)
	by smtp.migadu.com with ESMTPS id 045bb4db36933a61;
	Tue, 25 Aug 2026 07:27:28 +0000
X-Mizu-Trace-ID: 045bb4db36933a61
X-Migadu-Flow: FLOW_OUT
Date: Tue, 25 Aug 2026 09:27:26 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: RE: [PATCH v7 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
User-Agent: Thunderbird for Android
In-Reply-To: <803413aa2b1f44bbaa96b440b0693a58@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev> <44120736-F50E-4AD0-A380-3CEBB6A2F7F4@linux.dev> <C16E411D-37A6-484C-80ED-593AA5596A1B@linux.dev> <803413aa2b1f44bbaa96b440b0693a58@realtek.com>
Message-ID: <5970B165-077E-4A49-96BF-5AD15B583B45@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On August 25, 2026 9:08:02 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Ecom=
> wrote:

> Is this distribution of polling times?
> Does it mean 4 instances over 4 times of polling?

My fault for not explaining it=2E pollN counts wakes that finished on the =
Nth
read of REG_TCR, so poll1 needed one 20 ms sleep=2E fails counts the ones
still set after all five=2E So poll4=3D0 with fails=3D4 means nothing ever
succeeded on the last poll, yet four gave up completely=2E A budget that w=
as
merely too small should taper instead=2E The patch also keeps polling for
another 500 ms and the bit was still set in all four=2E

> One reason the firmware can't leave LPS properly is that some packets
> are still in hardware queue, so this might be highly related to
> environment=2E

That fits better than anything I had, since it explains why it is either
quick or never=2E I will dump the queue lengths, REG_SDIO_FREE_TXPG and
REG_SDIO_OQT_FREE_PG at the failure and report back=2E

> More, it is worth to try disable_lps_deep=3Dy=2E

Already off here, twice over: rtw8723b_hw_spec has
=2Elps_deep_mode_supported =3D 0 like rtw8723d and rtw8703b, and this firm=
ware
reports no feature bits, so rtw_update_lps_deep_mode() returns
LPS_DEEP_MODE_NONE either way=2E

Best regards,
Luka Gejak
