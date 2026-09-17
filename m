Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4996F3612EC
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 01:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789610263; cv=pass; b=ZRvPgSyyAPugI4ZsyLr5wM/+BTY/1oyoYLKLSFgqlQhk4qaGT7qwaeQZAgH/RSO6iGDm6DpJGUZ9fXsS7dpo4+bYmli/v2eVwLHErvdpu1mhaRNzALashFpQ3gR8NGTtr58pQo9lNs0qm9RIoQ1Lu5BQ1tpCtzuSOw5hPiW3V+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789610263; c=relaxed/simple;
	bh=OVuo97XMUoIoea64ilbyzme2krrsLcku+PGv1YrKHIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILzdtoN06G6vxl9yBcFWVq2LPQj8OBKXAkovTeVtDV81a35LxQdd4APijNhnjQZSYL2K8OGQzDcSIgsH90aub1cu8zWktiYeMGXe7p0kOLyFdsVWkbuDO3DKrabDpcr5WWqcmMtF0lxYdKZoLu5Wa5LHKg+gPGa/zlWqonMh8TY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr; spf=pass smtp.mailfrom=khu.ac.kr; dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b=IvwhEMby; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=khu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=khu.ac.kr header.i=@khu.ac.kr header.b="IvwhEMby"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f13d76so251472e87.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 18:57:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789610258; cv=none;
        d=google.com; s=arc-20260327;
        b=l5OvnLE7RZQVpsBV4+Fm1wtp4V1ifgTe96suAIsyJddvm96MPNsPy9AaPbQxknb+RL
         UbxrMuE+0o47PcKW9KaBmT3V1rynG31P4Y/MfD9GZtMo+WW1P/cNbls3k+g+Yzj20/2s
         i+xWzStRadJKLIj1CHyqOK7dnt8lHw0AhSIHuX8lclzWZUuQTe3oXXUaj5KrQ4qImTx8
         +iRBD9xz4d12QeuYk06ATE8XXbNrvomrhRXripZqiP+xAAKnV4TJjBZ7oQuLU/zjGRNY
         bUVAapaC1L7LfCjWu+7aPxlMzIwpu3XT/6TGu/KNeeVig3De01Yz5kT05k8dMWBUjGtR
         errA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OVuo97XMUoIoea64ilbyzme2krrsLcku+PGv1YrKHIw=;
        fh=MhtQkZecYlWmxg3DBRqEiMKK1vmKtO5bFPrMDotOrCs=;
        b=WXaUBczIDxdocLCYLBfMgI7EbuDIDRWCYQXqYwu2DzzmuWix545SoDdhP0U0zAURan
         b26bErjjhKSUsInmP8lLdltGz2+U2WBcGkj7C+ePs/vxehYT5OTHlH9RLedWZlN7ciE1
         lv6OmuNk9/RnIFtKU3n7U4N8T/Oy33xbXln6LN2EtFaIR/7B5/ZkRFOIwnnMMRCAARKm
         eO6qkcxxSOoJfo0dRMZtnPBQUn7un0miQq/JjDpCmSRfB5HF+WjfZCXbMibW/zzHkFAo
         6hteAINlhJy9UlHMdGj/twB3+tApz2PxUmp6uGY/wy9+gRKWGgDorq9rjZKF2VhJ3fuM
         tHJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=khu.ac.kr; s=google; t=1789610258; x=1790215058; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OVuo97XMUoIoea64ilbyzme2krrsLcku+PGv1YrKHIw=;
        b=IvwhEMby4OtlMHgVR9TStFBs0e01NjyFym2BEDERnCJgRiV/uzAS/Pl++24MjhqE+/
         AaDvcpfvFk5QKQ3kTYJOqzbC/5voIkAUJKtiRG/d6RgMk+7zdCG8R6JfiTkHMuYM5Rld
         0qnx5FhwUfTALpeakjIYRyFJBrGHwZi6Nx7MU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789610258; x=1790215058;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OVuo97XMUoIoea64ilbyzme2krrsLcku+PGv1YrKHIw=;
        b=ptKBnMIdJ1I7A5m4hG942GZriG+DZZXcgH/BbwPAwdMhDiHggkc9XsG4PP/4JGkJJO
         6EO02G3JBETPfbfEhd/fY82eHsPQlSWNmhHtqZYlVHUFumfWBywwzrrUL1c6XbR8a7q7
         3MT5eDJOw5++Ins2M/OLVNwaAiX7ZzJ3lG7fJqOmS4QalsEE7xg6c4torwnNM6WHWkMT
         +q3Le3TyuUzbg996wOsPYAE2AiWMoGSVTe54Oa/wkFNZs2cgVAHvuOoTvyYAiSbZjYwC
         VBmbTEbRILzvF9XryoKbPSuNWh+ogClvL+brphLZhBCRyg54xsV08peMB05Mu1yzAm8p
         qLxQ==
X-Gm-Message-State: AFuF++npTEIBl6aCob2IhwkSmvDz9U2FV5FixnlAW8TkPaoCNaY7bOOT
	XTSgiQyxy4DajsKC+cFxzMVskR9pNCs7HdnQFTDLpts/QdekKDhiPHYC+94qSEKPMHOpcFTFS8n
	WT5sIJrrSRunYebfq6gXPHudPCZULAHi9WW4UwMe1lw==
X-Gm-Gg: AYBFou3lzd5TT2qCYApj8ad5/Q1BTcW/VDcRteKE+xc2I2+9T+f6H7lzuIK2f17r3aL
	y+QIYSwRmyijl41hvV9hWaYhzQsdUVBqrNDYuMGEW/D9et9xKQqFCRFrHQX7jhHpiR6QtowDTme
	OtScg+K+hZHOuhYHWMuRloo2AdBzbc1wAusDKSwMYzZg/7msU1D+lf74r+GH0cTJKJhHCC/styu
	xCUdk/fggSEH9+NHNc7gEN1Ob+lBbavW05BSLLINOD9iCdQ8xUGa7XYnTrZ6bQvEyTABC5fHX8l
	xKKPDAOtCwqSC5/9qfKFNU6d99otOhmx9E6gZ147DDKCtMsi7fITseM=
X-Received: by 2002:a05:6512:251f:b0:5b6:4ae:5b82 with SMTP id
 2adb3069b0e04-5b8b6649be0mr1252947e87.32.1789610258067; Wed, 16 Sep 2026
 18:57:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260913-codex-rtw-rx-v2-v2-0-f09c964e0b96@khu.ac.kr>
 <20260913-codex-rtw-rx-v2-v2-1-f09c964e0b96@khu.ac.kr> <de086af71cc346d9ac8ca4e7bf8787e0@realtek.com>
In-Reply-To: <de086af71cc346d9ac8ca4e7bf8787e0@realtek.com>
From: =?UTF-8?B?4oCN6rmA7Jqw7ISdW+2VmeyDnV0o7KCE7J6Q7KCV67O064yA7ZWZIOyghOyekOqzte2VmeqzvA==?=
	=?UTF-8?B?KQ==?= <5mghybrid@khu.ac.kr>
Date: Thu, 17 Sep 2026 10:57:24 +0900
X-Gm-Features: AcwNN1WIT0733jVhCBZTpclD_qLBOl00l4tmau6fIT9YXpXIFhaoVivvV1ifv1w
Message-ID: <CAH1Bc_xaD2kjBRp7aVjmAcz4Pv=zK2Tx7ro38UsdZZtXRY3Oig@mail.gmail.com>
Subject: Re: [PATCH rtw-next v2 1/4] wifi: rtl8xxxu: free RX skb when URB
 submission fails
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Ping-Ke,

Sure. Please use:
Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>

Thanks
