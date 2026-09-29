Received: from mail-24429.protonmail.ch (mail-24429.protonmail.ch [109.224.244.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990DF3264E7
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 06:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790663595; cv=none; b=kc6gvoUutBq+glepPzbHBEVuFDze0TfrtcYA5cQSi9OIzrflDpvlHRrkhj/ZhxZDyGsJ2s0eixy58KHlXDvzzom9TH4WwCA4QA8SXk80niiNwK0h8XP0BstzbmeQ1FikJ58OrF8YHqvHRFMTzLeEnWyT44UjLMuGEyu43EdRPD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790663595; c=relaxed/simple;
	bh=ZJLjf/XSBsakccCAtQa7ls6vt5asSHX0Q72kjasJRNM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mTSM5lrDVQv2k5UGXNzZ5zEok6zYHwXSo97Aaugo/ZGJQBbH9v4OR7hRU6zfk4XauAxKEfxkJzHVl63VHvpEGqIO2JJ6c+fv3/ktdiSVQ7fZXC0vrFJ+bB0Vv5722USnuP93YQhCBSBeBFjbUPCuIuCvHAayRRVCI3UURNNClfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=COOqX5FZ; arc=none smtp.client-ip=109.224.244.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="COOqX5FZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1790663582; x=1790922782;
	bh=ZJLjf/XSBsakccCAtQa7ls6vt5asSHX0Q72kjasJRNM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=COOqX5FZaIaG48mVHHU8Br/inrHruJQ1jN4lGcJ0pIRiIaP+HyMk0HC+krFH6qtOX
	 1ezOBKq2tCqwbz77rl1CEGF/kWeLKFImGUIAVSX2zg7kLyswzBsUThUwGxWfzDAiD5
	 ROk8e5MoDucKknj7i/PhS7z9xhtMocrFj/PgrgeCWT4IOa+dsGn8CDgoU1Y2AyN5AR
	 WCj+4CGv44W1uj2imblsjz7Bi/Tck8nMagMsS6xJbn3Gaq2koF8fERZyX2GLAKp9X6
	 lW3cnXlToUkkdgQXJX5qsOqPOEg7y9UGqvjERY5m9MbszcioBIQUcRb0oWy7Df3zV9
	 0PmGR5Httuf1A==
Date: Tue, 29 Sep 2026 06:32:57 +0000
To: =?utf-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
From: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: =?utf-8?Q?AW:_Re:_BCM4360_AC-PHY_support_for_b43_=E2=80=94_reverse-engineered,_seeking_guidance_on_a_clean_path_upstream?=
Message-ID: <zo8YVNaHZYNaNktRGNv_R6A9T0HZsUzzfs7_GFdLGK0Pt4kD8YIkowzbMySMQ3Td04j_h2HsfVwGy3d5w98pP4up1zGMPRj76g5dBGo1Ru8=@proton.me>
In-Reply-To: <20260929081403.6076a6da@barney>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me> <ih-lXs5OlHxMhydtcZFtKNhGg3cGlR137CEMZ07_zFQcfCYAImW6MRWPDjkdwy-xK9bIwpDK9ImgerqHmQMsAxX3ckEjsiN8QoCSlpvIsSM=@proton.me> <20260928200309.01a36f5e@barney> <DL5AS1oidqGRAmMHt0Jcp3X4T3ob_Fa-lfhTmMMak3ATUnfcyETDn65CQf3iLvVeg4ExYoc_0GW7QMoaB1jEW4nzKAKFDv8bD0hqBEtkUKg=@proton.me> <20260929081403.6076a6da@barney>
Feedback-ID: 189422222:user:proton
X-Pm-Message-ID: d0c8748c7560fce9e482a40ee3389e822e22ccf8
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> I think the number of people interested in working on this is probably ap=
proaching zero these days.

Probably.

> Maybe we can find somebody doing an AI implementation from specs.

Yes that should be fairly easy: Let AI write it and modprobe/rmmod it.

Maybe I can also start a new clean AI session with just the spec. Would tha=
t count?

> But then, why not publish yours instead?

I thought it would be easier if I don't do that, but of course I can make i=
t public.

Best regards,
Andreas

