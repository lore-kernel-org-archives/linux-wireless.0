Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9AA2FD69D
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 07:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788160606; cv=none; b=T7GLGP5XM2DUZ+JQMeDYOPtywXben+NgYl7AhVFiSr93jiyqocEn+qC8YgoB+I+DqQgfL09bVA/3eOF5l7le/donQEraSs/m2s5OT19+HA7vhHa9txqLlyL5eVUZitsBzMFUAggncVdwzYOOoqlUrSkzV7hNqWWydXNlCV8zYIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788160606; c=relaxed/simple;
	bh=V15gEU3nF7lHT94F1KN0+5/4dDjO3y9sQ0nL8buWCGA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kuwtJ5DsB//xxeqbv7UiSgr9wdp4vhGp5S7lSfMRJzXzD+B1gIEGHoU4XsIj3KDff144kFcPrCkiEeuUmrIUo0ZgeZ8e6qRR+ZNOuOWmlAihaHrnLheUMKUiG5cwna26eur4stU9Mvb1oZrKFx8b0dTjnU1PfQ7wqNryTrGEP9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b97Mnant; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b97Mnant"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39c953950dfso31318721fa.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 00:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788160603; x=1788765403; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=trfHiKNxLwKts3a9TkQ/McrWvv/qxtbxcDQ/ll2fJu0=;
        b=b97MnanthQFawrEKJJKity5y1EUwVpQU1nZ3a5DC6MysgS23YYttzvffA+W/aRHRDq
         8rBgvkGb5wdzAkicyulxcGupSN/DuzBqhj/DilAIWPc2o9i1MwbYZMob5AP6bLPxTAan
         1Y7OayTB/2xj63qjkIe4nhIRmoiH8JIBx9710G6SKIm25wJPaDqMRAvVz+GPzXypynrR
         /IWByX9e1X9tCeP47mzPiOwkOsRVHl4mIllV/0K2uP3NitTA2S5v8LJhyG+NnGXLicGi
         j7NVtbcNWEQlPRobHPeTur9Rw1eHY2oRgye6EEpzFSmrz70biDYVeP9nFfMqt/0SJJFo
         Qtmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788160603; x=1788765403;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=trfHiKNxLwKts3a9TkQ/McrWvv/qxtbxcDQ/ll2fJu0=;
        b=dfeQqsRYczot/grQVDHJKsT8AMteVPn8REc3y3Sw+1uzENIaVU8FgoUNx0M06VOJML
         NywGCPTvL/bEBtOSmS50UgfszWYykeIXVWf17kw4T7nr6QNDlpN40Rlwwrvwgx6OyDLu
         h47l7ehg23WVEtUQAEdLT7wdOy/sDhKn5dDzb6H9WNTBsOLVZ250nF+aPV490jljgROK
         TVqVjaAAhymASvtcrmO4ectessFbAFuioqe4joy9XiIxjzxjy64ynKdwUDvqtwHkhXgm
         l/3+hGpzCFII9jIKPD0ADHihK0qynGaNNwLxe7ftC14wopV5dBo+I4kLfJqz6zDnoZ37
         PC9w==
X-Gm-Message-State: AFuF++mqk3E1aR3FtpoC7cBaKbf8F+6aRb8fj156bUX0RbnuxypHfH5F
	6Wg3Zc/J7LeXWy7ui12LPX/WfGvIJHIXmq4xaxr/fFoF7t/v2/kIe1oa
X-Gm-Gg: AYBFou3uAEP84xtm+WP5VU567YHZSkvuhx0r8JWWbGiBgG3VrDMuSivJzGlUAxao1eg
	gdReUDtnX8l/tc5YeCAzNE7CsZJJz9WlZB83dQzykRKaWEZ2RtmOxjVSwtr5aGxC+7rWDG2Yhpb
	TumoPYZRJ98qjZohHxXSSfndpKthMyuicnxeQZar66dvk6SRVTErdbI3OPAjUUQoWIRbfAslBzN
	4bhmwD7+THciyvSOcXeNFJoM8E7fvMN7U7PyxuNJgRiINSFjYvfQc0H077HZbgJFZM5CyClfbY9
	FISETfc6yxX0nFJOC1S8lm+NtlKJfQsv+JeNBFLmQPQSYtgbLePZviXcdwKmakH3+njzyxENgJ8
	Ee9Y2th6SqeOVyHwl/XThViKfvIba/aPLDqGdEnvU57aQaSnSvSVtPrnxxLUu7C4N7yftRjNNMi
	+oBIXC+M4sHqz67Thr7AytR+6/JV4OdJnkee3vDIxLeF1ReYucXbSr6d6gj4E6Nl46EQVW6TwqO
	PAihxJ4QzXxIMXxOw==
X-Received: by 2002:a05:651c:1505:b0:3a1:ab57:ea2c with SMTP id 38308e7fff4ca-3a33545f5e6mr2923771fa.2.1788160602452;
        Mon, 31 Aug 2026 00:16:42 -0700 (PDT)
Received: from smtpclient.apple ([87.200.95.144])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a32702b31asm7257761fa.6.2026.08.31.00.16.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Aug 2026 00:16:41 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [RFC PATCH wireless-next v4 0/4] wifi: aic: add AIC8800D80 SDIO
 FullMAC driver
From: Christian Hewitt <christianshewitt@gmail.com>
In-Reply-To: <cover.1787991457.git.yanli.yang@bedmex.com>
Date: Mon, 31 Aug 2026 11:16:27 +0400
Cc: linux-wireless@vger.kernel.org,
 Johannes Berg <johannes@sipsolutions.net>,
 Zhirun Liu <zhirunliu@aicsemi.com>,
 Dijia Xu <dijiaxu@aicsemi.com>,
 Chunqiu Liu <chunqiuliu@aicsemi.com>,
 Liheng Wei <liheng.wei@bedmex.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E0243DAE-3690-40EF-B38E-BEE2A226BC50@gmail.com>
References: <cover.1787903339.git.yanli.yang@bedmex.com>
 <cover.1787991457.git.yanli.yang@bedmex.com>
To: Yanli Yang <yanli.yang@bedmex.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)

> On 29 Aug 2026, at 12:21=E2=80=AFpm, Yanli Yang =
<yanli.yang@bedmex.com> wrote:
>=20
> Johannes,
>=20
> This v4 fixes the build failure in v3 against current wireless-next.
>=20
> Commit 914781c72813 ("wifi: cfg80211: convert cookie output to input
> parameter") changed the cfg80211 remain_on_channel and mgmt_tx =
callbacks
> from u64 pointer output parameters to preassigned u64 input =
parameters.
> The driver now accepts each cookie by value, carries it through the
> remain-on-channel and management-TX state, and reports the same cookie =
in
> the corresponding cfg80211 completion notification.  The obsolete =
local
> remain-on-channel cookie counter has been removed.
>=20
> This revision also removes two unused global definitions found during =
the
> rebuild.  The feature scope and the status of the outstanding RFC =
review
> items are otherwise unchanged from v3.
>=20
> Validation performed for v4 against wireless-next at ca800a9302764:
>=20
>  - x86-64 GCC build with AIC8800_BSP_SUPPORT=3Dm,
>    AIC8800_WLAN_SUPPORT=3Dm and W=3D1;
>  - sequential application of all four patches; and
>  - comparison of the applied series with the current AIC source tree.
>=20
> No runtime retest was performed for v4.  The AIC8800D80 U02 SDIO =
hardware
> validation reported with v3 is unchanged.

I picked the four patches in this series into my rockchip-7.2.y kernel
branch [0] and compile failed. Claude Opus suggested fixes [1] which
allowed compile to succeed. Sadly I've no idea if the changes resulted
in a working driver as I've enthusiastically powered up a Radxa Rock4D
board and rediscovered its AIC8800 is connected via USB not SDIO; but I
figured I'd share the finding anyway, in case it's valid.

Keep up the good work, I look forward to USB support in the future!

Christian

[0] https://github.com/chewitt/linux/commits/rockchip-7.2.y
[1] =
https://github.com/chewitt/linux/commit/9bc092d55a76ec5a647494223147dfc1f1=
700853


