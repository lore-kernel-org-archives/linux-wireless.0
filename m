Received: from mta0.migadu.com (out-157.mta0.migadu.com [91.218.175.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663963AAF65
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 09:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787910155; cv=none; b=Je+5NZx1yiInvN99AMGqTsRZUrW7Kw/t6Jx5u6opD2hXaV26gEhm124C1cP4TwigY+h+GUmN3PaIcY2UEni9zhGyygha9JFQYmcv2fq4YJX6TP2gy+UiI8CF/TnDJwTRjW6KbIPh51ip+/kMiN+O4A5vYPeaGUgoGfQ3lQa3raY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787910155; c=relaxed/simple;
	bh=v9vCeFjjWdCaZX0qUFMhQUFMMGJjCoSdwhKrwSMC+v8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=hLentKW/q7gNBjUk2cTN4SBtXR/g1PcBDiAd2L1yVRNR8cr00aTb1jgfSqvgelH9DD7Z/Tw7MUflA5YjnpYZUXa3kPECnCJESQS434IwNHtaOpY8q1MKFt/LAQBjpiW8cpDTMPnc/NK0QrVRFUS/a1Dilhi6nij1iLlm/Hjjxgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=griu3GK6; arc=none smtp.client-ip=91.218.175.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="griu3GK6"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=v9vCeFjjWdCaZX0qUFMhQUFMMGJjCoSdwhKrwSMC+v8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787910150; v=1; x=1788514950;
 b=griu3GK6yvYBqxcKacrqcrMGjG0DcovwNuIl6zUXe18iYpctKimfLVmQGAiJ5Ep0xmR89UiW
 CC9QNjDcVAmo8Gh9lH7wGHMBr7wsvJasUKqbXvKgaGEljv4v5B3qZjObGf5RjkCX73GmkXquxsw
 qdRVPbYqbyJDmssBhzbBHJDY=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8e3f9164ce0b4e86;
	Fri, 28 Aug 2026 09:42:30 +0000
X-Mizu-Trace-ID: 8e3f9164ce0b4e86
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 11:40:04 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v8_4/6=5D_wifi=3A_rtw88=3A_sdio=3A_track?=
 =?US-ASCII?Q?_free_TX_pages_and_OQT_credits_for_RTL8723BS?=
User-Agent: Thunderbird for Android
In-Reply-To: <068b8747563444869e19399fbfa78654@realtek.com>
References: <20260825163314.1590-1-luka.gejak@linux.dev> <20260825163314.1590-5-luka.gejak@linux.dev> <068b8747563444869e19399fbfa78654@realtek.com>
Message-ID: <78117767-9F3F-4A53-A1C0-02B22ED32C52@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Ping-Ke,

On August 28, 2026 11:23:26 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Ec=
om> wrote:

> Since you have two branches for RTL8723BS and others, let's implement
> them by individual functions=2E Here can just dispatch, like

Will do in v9=2E

Two details I would rather ask about than decide on my own, since both
touch the other SDIO parts rather than this chip=2E

The unaligned SKB warning uses __func__, and today that resolves to
rtw_sdio_write_port on every chip=2E Once the generic path moves into its
own function the string becomes that function's name for 8703b, 8723d,
8821c, 8822b and 8822c=2E Nothing reads it, but it is still a visible
change to parts this series is not about=2E The options I see are to let
it change and say so in the change log, to drop __func__ and word the
message without a function name, or to keep the check in the dispatcher
so the string stays as it is=2E

I would take the first, since the name then simply follows whichever
function ran=2E The third is the only one that leaves the other parts
completely alone, but it would move the warning ahead of
rtw_sdio_check_free_txpg() on the generic path, so a page shortage would
start logging a line it does not log today=2E That seems worse than the
string changing=2E Say if you would rather have it either of the other
ways=2E

> rtw_sdio_write_port_8723bs()

The chip specific helpers already use the _8723bs_ prefix, which is the
convention you asked for in v4, so I plan to keep
rtw_sdio_8723bs_write_port() and add rtw_sdio_write_port_common()
next to it=2E Happy to rename them to match your sketch if you would
rather they read that way=2E

Best regards,
Luka Gejak
