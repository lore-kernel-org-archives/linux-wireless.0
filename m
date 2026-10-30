Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793395477;
	b=zXtd+316eROSer4KZ2XaS6MbpAdC1O5xXTN6KjWYbUAVCY60nR8O0EOLIgTmE/svtOMo
	 ANb7UT7SHVlXsePc9Bf4RrAVVpZBgO8L5YzwHQdB+mykh+F2PiPmo59MoWhUW029oybB/
	 l00oHp4G0j7FfSrPQ+XH12g9ZjrwdH8wym8XlXnCYM1rIHTfNBMyAUVQy97YD15cf2Uch
	 y4U85m3ujE7OiCKATStnwGhAz06ZpdGsfAkYZNbtWi+DfEDSq3KkGQ9WmOFCvSNSwU0Ty
	 0FTRaF6XNex5U4CHNIXaJSi/BjS5iOtixTiQYo39lrvD1dAgBIDx121VWcoezXIlFNA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793395477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=VD5yToGOxft/iAlbljIC7sImw3W+GTcv6yvpKGraM1E=;
	b=KvgjgcFQDUxhh16A0tcmG/FkVGdiDQt21TMC8MrJkD6OOQJT4Wid5PPo0+fv1QcLbBrO
	 92OaSBAmAj2b2mpgzodfOzR/86CGuAXMvGMy7fIaGBtVbyAYyhqYVGir3ywqLsk4sxUJo
	 XChixhhJgVuy3ElaY8QvT4bvpXDXbYnwBCuuhj2l/I5bn6HR3iwjEEw4ALY4akcPcvY56
	 QwZ+pvRhaylFkFer0zXQ7iPd4kHH8MRzHX1i/E08WlqQlY2mVn8iToY6ARAqKV1ksCiWf
	 5uGs6flbCBsdYZZyX6tZDZi+Gj05n6v+cvhl4man12LP4O54K/3nVca3zpnzbXKUVFw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=karpenko.ca;
	spf=pass smtp.mailfrom=karpenko.ca;
	dkim=pass header.d=karpenko.ca header.i=@karpenko.ca header.a=rsa-sha256 header.s=google header.b="Px4hgcJ/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.52
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F02E606A9B9
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 21:24:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F02E606A9B9
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=karpenko.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=karpenko.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=karpenko.ca header.i=@karpenko.ca header.a=rsa-sha256 header.s=google header.b=Px4hgcJ/
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-49e08af5fd4so541112fac.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 14:24:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793395475; cv=none;
        d=google.com; s=arc-20260327;
        b=hTjsAx4gmQZg4C3YAK+X/tYmtaRlmqGFXwE+mOugZ5ZwGQWqGiNeVCEhdzzj8u1y7U
         trGl8vt8GNXfhRbqP5Cngakx2SACBSLtV9yX1CHK1F/nPK+MZsHrJ2hBDN6CJ7CmBwcO
         xSplUT4V/KiWvVtxyZnCyVwKBm+Y3+8F+KN3OmMgfrj3v7QLQqoerI1qHavojSL2BB0Y
         X4YQByrxyipYt4q9Ng6Ce9rQnGcwtw1u1ckFnHJxdxqfIVHmNhUp1wGqHvmnrjKSrbhP
         DCNs5uv1RNPltFC+Vob2bnDQnf5KtwJm46GGXwNwutRh0t0h8zwYrPtjEFIjE8EkhP8N
         QYTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=VD5yToGOxft/iAlbljIC7sImw3W+GTcv6yvpKGraM1E=;
        fh=S2kTH8TVJzzg0VICz768S6nlu3JbZQ7Gvvl4gHcFg2w=;
        b=c3xdvnvEOC2J/KFJ81nEdYc6q4fJ6H5KIuN70W1PB5I2nQsKOKoKRWngnNeQatGOF8
         KkARq3Sfkm9rgxrpAjvDJM3imRbxtLlM013neRz0hPr8f5UrFWfaAMt3anAtmBDFbJd6
         ikXY1F28XQqcr7l480tep5XK7pKjOeYmkkT6WQOI4UwNyVCg70yvYVl/i8O0bF/EpkoL
         vdBfvwgHYDKnj9LB9QTzRggaZP9s1+xMs2cKzrXUPFYoFozpEfvwmAhMRW0Tf06kveg9
         tA8C0m5SujQDAkUb+iRfs3FeZZc0oHfhUmla0s7aj8L7nIAmdBsLp7DdZMBSuje5H8yA
         pzkg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=karpenko.ca; s=google; t=1793395475; x=1794000275; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VD5yToGOxft/iAlbljIC7sImw3W+GTcv6yvpKGraM1E=;
        b=Px4hgcJ/sYaCuC00ri6gDqqWDKcid5bvvhe7LNPjmP7qRqhJOY7Q1MGFSALjyJjAKt
         uYYPOG7lEcpIBxeblxHwXQtHnct7HMzaPlzVGc8iILQLpN0Musn0XAl0Tc1ORGTmrYFy
         5E/OoE89iFQDYxuTAkHwAYkVxNNV6EWtQgnHGrYmKm+IzVB7D6tUcY4eCI20izFUkCqJ
         4QXEhbZSiWBoYtCNBeNZFQrW2GvcfRsu4LFC6KBccZe/s1T/VVVKGSQylenEvcA0WgMR
         i0CPi6g80YGDWCJLhyaK8f7Nm41yyLhrwMPzYl8Tk+aQnF5eQCSaFoca66Pu5dXf1WTo
         P+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793395475; x=1794000275;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VD5yToGOxft/iAlbljIC7sImw3W+GTcv6yvpKGraM1E=;
        b=sBwEhp6Mt7VV3BbSfJm4TDOX+T7eCl6ghFXo7e4Zdthh35bQztzdPEIcaeT0LmxPfo
         exDtWR+nKq9mRUf9mV//nYJtOPGH5wtnbcDxXTCOiuvJsFaTTSeVvBKTf+9L+dKGE+Da
         muwVKQbuo+IUOaLyMrqKF/05JnSPJKi31r2nIqR6q9gZjyrL6tA7dUbGE6y8TKXQ4RPT
         0S1/Giun4OnKe6NRsSCglMxy+kEIWM3Z5EdT8hBnmcvXeN5dE7TaStns7J5gAFJWRwkV
         HfQT19Ajio+qopv7a0BaM2Mw3N8S3l/enP2uBwK63JYYn8j/ClGeDZa0YRaM+XKXDTBT
         w/9w==
X-Forwarded-Encrypted: i=1; AKwUvBxzJdK255Kg440x0CEY4l7oY0pGt5xav4sNPjdVNSI25PrsEZ9RUxmrFMIzQHTzg5WDIzK5GBHXh2+tGxNeJQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYK4DkMJ9Ad14s3YSrBVygZI5QearXpzRJuOqtcUHancrlcgw3cV
	9YhGiwr5UqMUe+ca1byMYItloek+87uKjZ6hSOUo1cbCl9cxdykk0pNprQ7pKTBNaNgIhjxKruZ
	ze0y2CkACXYWRUOqeCS/TKTSmZEY8WCQyt1cLkPJL1CEOdNdcqAusA6A=
X-Gm-Gg: AYBFou2Zx2/9Y2nftjzFp+naeMP2U/kyEmO2PzayiBoZgqmRHwxU06qzlBfO8NbAjfq
	LNW8AkE+rvwvd5/rXjoiZXPJ2f8IP4gDeTnzDHENxtljY5sOzqKS1/62Eku7mHTgf8snFWZ6ygN
	yPClPEK1R/d8JSU8MPfwW5xTxYnU3O1MDFaTgMWmELui6b1AxEVP5oNROpnMF4IZDZ6DcYJM7aV
	n2mtpPn4aY51aIx+xqESt+uyzIVS8YYlOhTd04lkrMtrdoR/4I812MUZFrEzexTfYI2jSbsbUyJ
	4rWhKv9mHGYoIxeN0ObObMfvIN8NhodKFjPRhNTeBROOXGwTehOV32F+m3psL6auc2PrAnmnn2l
	FyXJgJhDIKDj9eP50K1ymRqJqW7EGw+ibcPXtvayLT0qyxJey15xJ4Vn2+jBmdozYCQZHkmOGhB
	AEdPOTFY2gd2XgQw==
X-Received: by 2002:a05:6870:d3ca:b0:4a6:942c:7b05 with SMTP id
 586e51a60fabf-4a9076f991amr2445401fac.32.1793395475309; Fri, 30 Oct 2026
 14:24:35 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Alexei Karpenko <alexei@karpenko.ca>
Date: Fri, 30 Oct 2026 14:24:24 -0700
X-Gm-Features: AclHuK_LC0lC8hHw_UwEONtzcp3mlVEURddifkSfuchxQbiy1tD1SUIUgYTw23g
Message-ID: <CAOHMRc8bR13o3BpkMbBhs44TpQYbjTUQsoah0xvtB5-Yo5fd_w@mail.gmail.com>
Subject: [RFC] ath11k: firmware RX cache-clean range
To: ath11k@lists.infradead.org
Cc: jjohnson@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Firmware: WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.41

RX refill clears descriptor offsets 0x50-0x5c, but cleans only 12 bytes
from descriptor-8. Dirty writeback can overwrite hardware-updated status,
including msdu_done.

Proposed correction at 0x01500fa8: r1 = #12 -> r1 = #104.
This covers all cleared attention words before buffer reuse.

Could you incorporate this into the firmware source?

Alexei
