Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4FC468C1F
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 08:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789116147; cv=none; b=AEfMtUeh8TK098LmzumJfhbv/MESLlkjG0Y1QZPkjL/Q2J+dCqZaAMjnYKJSVfe/mu2pAgzjyM28hu0zcCfRfGnAVhCUpEhN/YF4sJ1mKvemk62xsojRUpLeLSpMnRmD5o0oLx22qowHVffpP6X1p2Gj3pLyQU/YQz6JVO8+/cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789116147; c=relaxed/simple;
	bh=9Rl/2Dwn3EBk+1V6E1oPPEJyovJn7q/s0zuVVE8xjh0=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=t6ALKmvIGoUO5SKlPSHFxGvyh9u396UyeS/tXGhhjCFNW/RXOiUQQ61b/e2s7rM4Xmrb2MchBaahN9guuPMXJFLZdKxicHvcT/VCXwa4Ox3dFa0m1gf3UX1eX/5l9Jogu27LmkeKXN80lnNoBXepv0aDP3wxOQ9Ij2NzjgRybxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X96zHCbu; arc=none smtp.client-ip=91.218.175.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X96zHCbu"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9Rl/2Dwn3EBk+1V6E1oPPEJyovJn7q/s0zuVVE8xjh0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789116143; v=1; x=1789720943;
 b=X96zHCbuB/DkrSwQley0oOzN2twP7wNqcj0/c3XrQFXtwyoovOH1U7n68fc/3unfqmBWoUqQ
 trK4pFwnh0cqP2o6H5F7nfRDeeubnRH9q+GTWpU74kYttbbVxm1KoO8q20NxzHMuqUyO/8KGUPB
 wqsS7Uwdu8Ytu/JyL4D8GzxE=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4511d20fe87ed201;
	Fri, 11 Sep 2026 08:42:13 +0000
X-Mizu-Trace-ID: 4511d20fe87ed201
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 11 Sep 2026 08:42:13 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <108d4da2ab381d6e22d4f84f1c1254aa59b20d88@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v11 4/7] wifi: rtw88: sdio: zero the padding added to a
 TX transfer
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael 
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <a0a617f1b7e34b979a801e7c10ad98f3@realtek.com>
References: <20260909074556.55709-1-luka.gejak@linux.dev>
 <20260909074556.55709-5-luka.gejak@linux.dev>
 <d6507fd0447c4c09a9c80bb57dfef35c@realtek.com>
 <DLBQ2H40DC71.2Z3B32X9JQ17I@linux.dev>
 <DLBR915C5L0S.1TEYXZ8LADNTH@linux.dev>
 <2294d792e937441fbf4ef8169c03df18@realtek.com>
 <a17a665d7d4c47fbb33e038d122ed200@realtek.com>
 <DLCBFNKN09SW.2SIEDXTB4PGJD@linux.dev>
 <a0a617f1b7e34b979a801e7c10ad98f3@realtek.com>

September 11, 2026 at 9:45 AM, "Ping-Ke Shih" <pkshih@realtek.com mailto:=
pkshih@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E=
 > wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> I can write that up for Johannes as a separate mac80211 patch, with=
 the
> >  rtw88 side as a follow up. It is independent of this series, but con=
sidering
> >  your question was about CPU usage and this change doesn't overall re=
duce it,
> >  it is probably not worth it.
> >=20
>=20Thanks for the experiments. I think it is not worth...
>

I agree, just let me know when the series is merged so I can send driver =
series.
Best regards,
Luka Gejak
