Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DE2422540
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 19:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786649605; cv=pass; b=shtrGOO4VjgpkCYnlNwBMTsHQkq3yr46LfkdUaHKUo2SJPJ6RgDklMPV5T/+XHDt/txSXZVMsxaGk5gvqsT9pATfcybVwUEfJbm/be2wXUI06YZvmWODrKxLiqd2lS2uEOPJnCxYmuGAMuxHjlgf8yhwQgFHxLlAWw2yrh4FlgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786649605; c=relaxed/simple;
	bh=3QZfHln560RCDvnk+V1j+UJC+TZGLqbIcb0VBhhIcvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q23gqW+fnFc9BeJizdiJg3oXvKZmR6YwTN0lFPw2Iy1O1lrkioppHGFR6ffX3uvOUOUvOKH5a2w/t0kQ+MlOQYpn1CSkysyrOIdAjX1uNXeGuGxDLfXqJDtmBa+d4CIeRI4xvgPyYUIbqmYKtFor5039UIha5gvcHQQ955jIBXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gRcGQ0S3; arc=pass smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gRcGQ0S3"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84eb992a881so85250b3a.2
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 12:33:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786649603; cv=none;
        d=google.com; s=arc-20260327;
        b=qH84taDFNV1sasUX8awE9DM06FiSHDxpuNK7O4ydqnkmRf2KXl+wKTcaQGRhJ/fZ28
         JfEm1Ev8DnLRAlpU2i2+BMt1ZOuldjWIwaY53T/srFWBkpkSaQ32IYnu7S8e13xrhGpL
         HfYnLhyyxRy21UGpBCTrAhv8XALTbFv8fOkHnCke5UjN7FxLedPz6QA+VCIFeOXjdrv2
         yhgncwqaCfYcd51wADs9GErhsJ3N3LVTaZR56gHa5vnNXM0/P4insDjwTPV7YLGEqGb0
         lvMW1mThScpnux3/vl1up93KgQI1ICQtLUB9t2bogwnfJNF4DTM8SMLq+fBjhqEzDc5Y
         BuTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3QZfHln560RCDvnk+V1j+UJC+TZGLqbIcb0VBhhIcvU=;
        fh=zFCB9yj6tbPtiNOgT9n/qK9LnQKfgtX1AWhCxXtoerY=;
        b=p2Ex2fvLFWG13q43Sa3ohvvOA9PdXh+zTNO9Z/6nDcaguxvVKkk5U/89OQwpGxp+UN
         3P3vguauX8jeyjlBIkvsaYcFBt8EmVDJou0rUrS7f+EStH1oOjHXdTnwsPKxJepTZPVO
         5wSTX9GF3hvBBWLouF7UpvkR9OqeSrnXe0ZR65jiWqTeJ7cnHQVabhQau+uOYwtihiVk
         SgSrtZZR0q4AsbizPNmmkw238yEMuzxd4Q1N0xNluZmQFo9lVc1gBLFz5VnbXSnhsydT
         71OZijFOPQamwaOjQhIyrzxn7E+YcN12t84t0qNQnl8x8gqmUiw2QH/tUW4RgekkY/js
         Uz4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786649603; x=1787254403; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3QZfHln560RCDvnk+V1j+UJC+TZGLqbIcb0VBhhIcvU=;
        b=gRcGQ0S3BNsRKd2v1jD2NjOEq6WrnnXNiLAqhD1Vu4PnEGjkUGy5oPH5Y/d+WJhN/j
         5mo8YKM3Z+bDSOquuyv23YsZ+rxr/5uquhC4xhaQ6YxLVAmTkS6rmwfqg+oAv/LS2ejZ
         AoSHf7g4caKIr4V8TbzRlBBvlPAg++pVQIsgTZZ7yrdxo9YqF9eUeQFMDhYLWw+TOSSK
         8HwiOX7qxsWaXtn9T0kZIUU8aY3GDepFqn0aDH9Q9EdL1CXWXJM2vN70wuUZgBmh95yY
         YaoMjIQu7Anv4+CKP0u+691yw1TRKNfAKQLoDJSENteTbYUVkOcKjhBodzVLOnnJXiqD
         LUgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786649603; x=1787254403;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3QZfHln560RCDvnk+V1j+UJC+TZGLqbIcb0VBhhIcvU=;
        b=J9O80d1pfB029dcl7FAHKpysDElXCdEG6a0KDTtpPFAOYkKw2a5ROoYeLHGGhgV+iI
         U0rmJFoGZosdNWryOrvduMeyLp+falk4jLeBvNsTSpHZRrLYMDMdTEItVW30rAy3RUHD
         qiiMBeALvDX3znrXX6QQlI1IGURZKCansgr+CgONPstg+qVeCpS6cwVIK04fEElb3UAb
         7JLrQK6E8WROUeKv9THxpXu3/YXvUpZ0Z8cTyfQhVinJNCAZYwZggRpp2QGKkBhmRMvZ
         l0zm3c7a82GIrGlBFUcFIdH6qIP+VQDF1kuIeZm0WTYAQ0lxBfKSSJTyzxYxyfxedvWO
         pI4A==
X-Gm-Message-State: AOJu0YziJ1K1b3kPdB2exnNq9cdcNJGDFfSrwp3FgHBstypeWfB7jGGw
	qi5hE5PXwxBHAj47kAU9AW4ejz/0HcbUVA9aAdQfgBsoxWWgNlEWyFdTx5ePFUvHqtPPDHl71bN
	JshhGuXqMFRccmJaYPl1d9hnlNnmR3gtw68Rq
X-Gm-Gg: AR+sD10UC8urou/Xv2QbLxU1QdJDLNVHtG1Tuq0+wdglMnmzdo+zS/MJZUEuK/1ET0p
	c4OjomspIKf4btoiRV5W8ovs2NmSwOgN8uIB5DQ4KLKDZpWs7M9M69hcFotAriClbA2B6/TDBOi
	95uNh/z6lRP2HQVSVu/ZSCwrC3CyxF5JxrDnHbQ4CC84DDYnVeLoxxlCN5Xw/Li8T+Bo5l7gV52
	HA7yHzs7GEeOMdPchNSiFJMM+2gLXGXRlFz6NaJ6ROvV7CwNTVjgxR/+Jz+a4dWcUAWNQ93pOgg
	jsD/6lYoTdZO62L37saMui3eehQ6a5FKDzYaj4RGQc4FXuvzDRTv5I4y3nx8mmWRm+WBg9Lw+iF
	jS/FDnnvp5HRvn7bghoYgdrbE6UQIKF3y
X-Received: by 2002:a05:6a21:b94:b0:3c4:3767:adb2 with SMTP id
 adf61e73a8af0-3cc719fe496mr181108637.1.1786649603377; Thu, 13 Aug 2026
 12:33:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com> <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
 <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
 <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
 <fe2f2e2a52ed4565b5c2927d872d82cc@realtek.com> <CAOQMLZU31dc6ZvNi_veM6uU1fSXYNBdnWLkOwH5xXR45uOFx1w@mail.gmail.com>
 <CAOQMLZWPMq=CCFpdg5wwsJ_QnrUKx_0YouTxdaSePO_0YPqcLA@mail.gmail.com>
 <CAOQMLZUn30NJwU4pR0hL=nz38Mbp=73wgqd+CoQE2qSO3cf4_w@mail.gmail.com>
 <013f7d3cf223417c94df41a2a45fa540@realtek.com> <CAOQMLZXiOBsjn=UEO6UryngzkfCzKdo+Xa1RmE_vTtZoFKN0Ew@mail.gmail.com>
 <CAOQMLZVMALBLeCZUB3Jdvk75znt0D7HxrXyPMhGPvcKLx3j-Yg@mail.gmail.com>
 <0912165f66394229b4f2b4114ae28a50@realtek.com> <CAOQMLZUbZhNhOQyxGXW7YSOU-z6w-4jWqfqVkaeMhdx2kLDrmg@mail.gmail.com>
 <c52840cf65464f659635eec6fcd6de12@realtek.com>
In-Reply-To: <c52840cf65464f659635eec6fcd6de12@realtek.com>
From: Adrodoc <adrodoc55@googlemail.com>
Date: Thu, 13 Aug 2026 21:33:11 +0200
X-Gm-Features: AUfX_mypaFLQW0bV0-HlFqVLq9_-16eY4FgkaTZ4QTpsdJEEmr_hSF6PtB2ECNk
Message-ID: <CAOQMLZU9fzaFNh+vbFR=ZpvkyG=T9UDwaeBVXpRj3fvYZt2D-g@mail.gmail.com>
Subject: Re: Error in rtw89 using Kernel 7.1.4
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I have been running kernel 7.1.5-1-cachyos with "sudo iw dev wlan0 set
power_save off" for the last 3 days (monday to wednesday).
On monday I had a very bad disconnect, but there was absolutely
nothing to be seen in dmesg or journalctl, so that was probably some
router or provider issue.
Other than that I had no disconnect issues during that time also the
SER L1 did not occur a single time in those 3 days.
So now I am pretty sure that the disconnects and SER L1 were due to power_save.
This makes sense to me given the message "firmware failed to ack for
leaving ps mode".
This is the same kernel where I previously had multiple disconnects per day.

So I guess the next step would be to ignore ASPM and bisect kernels
for "firmware failed to ack for leaving ps mode", right?
Is there anything I should know about power_save going forward?
Are there some known issues I should be aware of given that power
saving is mentioned in
https://wiki.archlinux.org/title/Network_configuration/Wireless#Random_disconnections
