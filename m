Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0293AEF55;
	Wed, 16 Sep 2026 03:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789528261; cv=none; b=uhIn5k893yjihZtUdzwwKiHlzWpdzW8nO8qDzuAzg0Auarv/2sVE+05EBjy1+OBCdW0VBUNn30YyVhYKk1CpJJrLp/0IS2sCd0VvcSbvx3EX3umQFXZ3HyWp1XjYpTfCUxPZ/oXFMXOy7SXLEJjeM0DnoMXSofsENRVhJ4luGqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789528261; c=relaxed/simple;
	bh=V6LqlEbPt0A0Lp78KWUkHtb6iedfYEEg+2B6EBW94IQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=lOgiMda7lBZlv2uLruxhNpIQcjjkYJ04Efv9FLK5m9tdqy5wzZhQriXsjffsPxPEi1f27rsNU6ZEla4d470rPT75GK7k0dmaQ01RBz6jIhSg3IV7BiMQMHmTmpWOw3IDLcmjVAq8W/cOLHs+5tTmV1TuarCiAgQmx1CaTNjenRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=vrn+5yRb; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="vrn+5yRb"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G3AsPF22054135, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789528255; bh=JFlDBbSEnU1fUZVk+Ffaz2//JSFpvwBkSELkLPs+wco=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=vrn+5yRbVbZ0SF90psUg75LuIIEdmyGbHwdkj5WQBOX0iemGvFoBZleGDwmem6tmi
	 B557yJ5kKFQE9DNBQGk0YQUD9/njb0djR9nWZ6e/O7HYW9V2Fyymg6nsw97o0GHkL2
	 2xg8HhSuj6nlpAqjGLWMU88L8uh6Qtmu+VsnMXQXJbsm99Z2KlEZ2muqrVWetc11SG
	 Y5u68y961I1loGUx+8Xf/tcieWREivwwzHrgTcRX0IuOi8claLWo11qLM7/1z+Q100
	 oxEkAhfcI79wVjndE9FydrWzvYzqb9dz7gGjwqHRttEN2ZO/Q4gFvfMFWDHJe9fwvQ
	 FKB2gJuLf0CZg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G3AsPF22054135
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 11:10:55 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 11:10:54 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 11:10:53 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 11:10:53 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hemanth Selam <hemanth.selam@gmail.com>, Jes Sorensen
	<Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] wifi: rtlwifi: fix typos in comments
In-Reply-To: <20260907044851.9884-3-hemanth.selam@gmail.com>
References: <20260907044851.9884-1-hemanth.selam@gmail.com> <20260907044851.9884-3-hemanth.selam@gmail.com>
Message-ID: <fd6f5077-f696-4b6a-94a4-5af49df5dee9@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 16 Sep 2026 11:10:53 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hemanth Selam <hemanth.selam@gmail.com> wrote:

> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
> 
> Since v1 this is split out of a single "wifi: realtek:" patch, and the
> single-line comments it touches now carry exactly one space after "/*"
> and before "*/", as Ping-Ke Shih asked.  Comment blocks are left alone.
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

834fc28d7880 wifi: rtlwifi: fix typos in comments

---
https://github.com/pkshih/rtw.git

