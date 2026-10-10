Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E66298CAB
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 13:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791639176; cv=pass; b=ZKImsi3zs9dbJgvByS2pve11ivAy/g/tFfuJGdXaRd+Zv7s1y5DO+jup11UcKhDVTwuih3TBCb73Vi4TbNDTgVtm3Rex8t7Acpdct7BROEZUc1Z+xGBYxJ0fQiHiU013km2eXBb0ufM0Djf76TdPZ+f7AQkW2wfTPb3j/ViH8aE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791639176; c=relaxed/simple;
	bh=mtsamemj69B3iRndW+JReJ4MdazWwyBzoeeClqSsfHI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pMm4Obxgd1bfTbtAm7D8gVhB4SLdNbfePwxwA+KHD6uLHj9i6LgNy++wcJb7cd4Hh7pw7cGjna11KuLiazTJW0slusVIrAhS21ORxwo5uJoV0yGNHI415kmE6snI5mECM7kiYOniWotCYciglRz9nT+t/31Sc5TpEqI6lZxKOBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Th08GXw0; arc=pass smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Th08GXw0"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3a6313cb899so5564151fa.0
        for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 06:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791639174; cv=none;
        d=google.com; s=arc-20260327;
        b=RdqzTqaq7lxexEe+l1Q0zGPkYDPMjGkAAD6wLsAYFmL48uHYhEisQDz+2il9jmQUX4
         sj8hs4CSe4juHNx4zJoHDr3e3e0L1TZefwGBQ2972v6YEof621Y/tblQSMUzvLOiD6mF
         z7j/6/0k/g4y2ljYFRpzIuf/nYbzF1jK0ij5p7st+83MkkOQVkZa9Vl+br5vPcmzYZzJ
         HHdSCXYuzYUCgqVWVDZEsFtL7HxAJ99Ydu/TO9Rugmw6OS52NGDZBUyh3tOkVEljCQkb
         QIHpzS3+dVJlca8o4VccIwqvQnDnzw++LtOEJhmvo7Ujt8SWGMSi+9wp068wQrF7B4iD
         Dpvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=pYVu/5x8kOjkfB1OLFe4Wb0FAXv3rimBPK2ZUX360S0=;
        fh=xphDmeiL7LVRrn5YvOU9y392Tjp64ULlTjJCIiuBvM0=;
        b=OwDOZdAkqwmdijVvtdSwibn7i9Qo9u0n22+wJ+bIA5wxcSp9dITMuf9h+5FWOzmMDh
         M23aJVAJW9RoVuHQn35x/Ql3D/MpsdVBpNPh1ihmHJALgbKFEBeE+7CozRxZD64rceLq
         Vmxd+QRI8z+O4OJCTir7U1/ZQzG3zFbmZ/f2pZCEWxU5V1bZgHdSa5KuV3fFFCLqu5tP
         VnvVT8M+mI8f720C9HiUrpgIrSpXQ6n06Lk6FinKGj9sypR7ZF1vD0hywL9S8ZUnEcAH
         4WPhRcxYYH5TnSwIzbnaw4HIWTgjwOb6b7AW0zkwEk7G/9Ve5jX0upfBEgmDvCY0cu8z
         zWKQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791639174; x=1792243974; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pYVu/5x8kOjkfB1OLFe4Wb0FAXv3rimBPK2ZUX360S0=;
        b=Th08GXw04g5oyZOZrcolN6lkThyeSPl0uFs26ILwRvrekmRRyU/ak6jLJM+6GPYtVy
         wjg5O0m+/GNnWrRGiPlZYAUiw15NdoT5TwXam9XdcOhy/rQNY/29Tqr7AtUtnZJoVp+U
         Ml6ezJ1q2rFvqi8kWNoiYmDTpJF+M/esoF+IaT+vimu9y8wu+kayoSOJ55OkDQSei1W7
         WUDnx2hR/Zs1EulcVkkhMUt/ExN/VC3PJpXCZ37leVxP5vbP4ssU6AsKvKWIUablkjCf
         3EwdwDIwaLNqQ+9gOH1cA0n13/pW55YRnhaaPylYTl3dTZ/0gTzMMBStVWX58ZZ+3yIX
         2OIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791639174; x=1792243974;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pYVu/5x8kOjkfB1OLFe4Wb0FAXv3rimBPK2ZUX360S0=;
        b=iPkg0aW/UO/B6ESdPkBqvXQ+c1ToufYJmNVGER35uy7a+nRPVuN+VT01ZADl4iyq2O
         3Y1/HUwgYFhKV5RfIS1UTcKrI8aaS+2BA6SNYLjAdNF01HxTNms1zlkfmoj54qcWc9E9
         CqxFC/eB8G79pigVZaSTAnnw/9XvOophxGfXVS3XzoFUE4N1btIxDGoGBWFVnBMLppnn
         FXs40pWxXKjHcKExUb3PCPVQBz517hKRb76rMaIJzYlbefkDtMJh6jQikAEZHRpLCcDv
         vZEDZrssNqiTpLcqugBYNz/wFy6OSgVMrS3XDMw/TNkhbS39J4pgTmUsO7i4Uk6YiWVf
         DWgQ==
X-Forwarded-Encrypted: i=1; AKwUvBxZXskhNiwVhE+rZKYwmLnb6dGF35Wlp6VWxTn048FM1wNb8kSI/0Z9EwbPRWxcuTEZNTvDOwbmLwDb9ejuZg==@vger.kernel.org
X-Gm-Message-State: AFq9FYIGdDqct6+IKoyAF2KwapaGdhYLxpDHjfM5qJz8dL6YxNSds1AD
	5lOF8PiiuZoH8yZXIkFplOtRBmjbZVdF4C3osDlZkZVOsa+aVv828dIZP4l+jN06c1muAk+ETjw
	vX1y/BOI4iGKYVgKmJzNiBtoooqGgr4A=
X-Gm-Gg: AYBFou0AYMj7Rosrb+wTcuTkgQiOaDE7qqpcJ5OAVhXtA0X/7SEj3ujjGsBm+HjvK+Z
	6qBkCwTPyw6dMSCLqjnnheg/8lFIfNb/hG+pDhjOf5xL2DDGG5jBfE0nngTGdEIFJrMzr4eEbzl
	+3wcosUIuRc/O/XikMn7vEw/JuSZSBpR7bYHWgsgOdniNvLWGbWJ9iuJMxuaXwkN3ryXptyvqb9
	Z92BhLkEeRaZ3FajjYlosL7+oRWbYSIXKP5f3kVc/JEGQmN7KSAY+WWxhgYjMXYVnC5mPYvnB+P
	WoReBn9ftrtbKdrJFGK+/rHXymtZZIzYzmiOJFU48UzKN61lPc/3pmsx/g0aG72+7CW08hIsmCd
	19p5Hxe2SMWwlvEUCTrrcZimz702av1Xz5JkLE4JQwroVlHY9e7D6V4pW
X-Received: by 2002:a05:651c:144c:b0:3a9:707e:ad9c with SMTP id
 38308e7fff4ca-3a9c5399cb7mr11669841fa.4.1791639173378; Sat, 10 Oct 2026
 06:32:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007115821.11332-4-sigefriedhyy@gmail.com> <179154713053.434549.11454657718901075006@kernel.org>
In-Reply-To: <179154713053.434549.11454657718901075006@kernel.org>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Sat, 10 Oct 2026 22:32:42 +0900
X-Gm-Features: AclHuK8XHLLXtzmhhgPNwPEtq6aAUTQyZKtjE1IommkdRmUGkoYJ9BfWJQP14DE
Message-ID: <CA+7S2v+=pQv4OGqcK5Gw=ZdnQJ9FAhsYXwdbichThiTd4sVH7A@mail.gmail.com>
Subject: Re: [PATCH net-next v10 3/6] net: add a generation counter for
 dev->mc changes
To: netdev-bot+sashiko@kernel.org
Cc: ajay.kathat@microchip.com, aleksandr.loktionov@intel.com, 
	andrew+netdev@lunn.ch, claudiu.beznea@tuxon.dev, davem@davemloft.net, 
	dsahern@kernel.org, donald.hunter@gmail.com, edumazet@google.com, 
	idosch@nvidia.com, jacob.e.keller@intel.com, kuba@kernel.org, 
	johannes@sipsolutions.net, kees@kernel.org, kory.maincent@bootlin.com, 
	kuniyu@google.com, nicolas.dichtel@6wind.com, nickgarlis@gmail.com, 
	pabeni@redhat.com, sd@queasysnail.net, shuah@kernel.org, horms@kernel.org, 
	sdf.kernel@gmail.com, vadim.fedorenko@linux.dev, willemb@google.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> - [Medium] netlink: AF_PACKET multicast dump misses changes due to
>   reading sequence after loop

This  seems real, I will send a v11 patch, will sample before the
walk, and once more after it for the
NLMSG_DONE check.

> - [Low] __hw_addr_changed() (net/core/dev_addr_lists.c) does
>   atomic_inc(&dev_net(list->mc_dev)->dev_mc_genid).

Same as every other dev->mc writer under the address lock, nothing new.
