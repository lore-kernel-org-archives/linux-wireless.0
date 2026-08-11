Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D69B2E285C
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 22:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786487434; cv=pass; b=GwbfdDvJBK7rps2Ve9QaNp5XwzzgjcCx7biX/t3Qw5UFiw4H6dt0jbRNuDxh8gRmbFIgbEvi36mSN4RD5X0cp5avz7nF3/B1F6ylHo27dKCaaGmSCrUu+TmLkOYLF6qQ5tRQ7NTYxA9WAKydPBA57UPJk00ETHWXJbwlvC1FURo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786487434; c=relaxed/simple;
	bh=WjeF5H9DpNVCYc/EMdaqQaRCP697dc9B5k9hEFOpSuA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U/bnj0jGmlIV78TUShLRhoA8ArRnLyJGGKmAX0NH4CGz01I8oFFjr9YJNonqxHP7WlAraOsvHG2kSNEA04cKiTWXEh1N1I44tqaQDMJ0Ae2jBFJSnbGe0oCWqd89+wXgmD9B8dMobiqPeKlu0qJB+77Cyo9tk8ZmNzBCn+8+dY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KE5a2CbB; arc=pass smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KE5a2CbB"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7e9ef94c0e2so244081a34.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 15:30:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786487430; cv=none;
        d=google.com; s=arc-20260327;
        b=Ljm6Ok0wcXvBCeWs8O0y6XMflDOq6mxraR+6eqRNi3X4EABhF8z+Aa20APgK5jLy1K
         ePSgTeI44Pjn3BFFwSW6hNyfN9u00zVU8s96D2MLtK8Pi7nD4Ks5olXqNYs+y31W7I7K
         GM3FGnNovafdx4UAC6SZ7VddyoXhLhcUx8yUgpgk7VkqH4ZspYKyzPdKsvOxs24FAUDP
         yuyE1RGofaj9BRFcFFU2IAdQGcNNATkK/P6UHlElxMVm02FBQBkr0qSeCFVbZ9xWk9c5
         D5irEZs1EAvc4cQND1iUSdrIrEHs0SUOguIsjymLm/DDssd2WauQTFWtIwwBbfIoSEom
         XwKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GAluQTC1HpvjZU0entrIRv7rLBpoBCi0VS32rmx7Aj8=;
        fh=Mz/asAR3ggdihtuM5UdB+zcTbGKq1ca0UHRe5lu+S20=;
        b=Ebp2WTU59Rw3SCv69eqBLAXTqlSym6x9ld4lJiVp/jjFboQiuT/TSWVrycey+RJe+q
         tJklfN5Vl4oAjFuq/SCvATN4THePQQOK8ep9HLQ5e/uqfNibVPa4WODW00qrSPBtNzPz
         +/kw6AX57M6Uia6q0dt0VniUVp5U1yhiOytpK/kJccW5tCwi4O68PaZBJYGahNoJ0iEe
         4QsUkebVvXNnq+L5nH1sC5J6n8+lDIvJ6Z19MwPLVBvYCJFKvxf+h1/cllCkjl7mscQ/
         KnhqbAOp6HkDpqp9J527vP+wtBDMJdhd6f3YBKpbEhyLEvNs9KZttksXGgJi2m2zZVNu
         SNKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786487430; x=1787092230; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GAluQTC1HpvjZU0entrIRv7rLBpoBCi0VS32rmx7Aj8=;
        b=KE5a2CbB7zKXbJZkA0fU9QI6zSPUfGRVSLOqgT/mkJMAqXtrkNmAoKDWwSsG5AzFSf
         lVynhAQPBX00wzkiB0Drz4GQgd/E6uCByeH6O9D1wHwoM8K+YMkIrTQM8UUVE0dQfG7J
         fHsN0vepWEkHHgqgd9qIaacLahXzT2R5VO8idAR1CuZkt9QrqJbOEoSUaTI/2bpyP5Cb
         GhckeMiqJvGVotgC3CB125eQg/1zHsFFAKQIh27xrfsRdA6DRotY+E/2CuHGY3Zy8R9v
         by1RyNsP4YHJMzSAoW8eMH/VsU1HUF3eNSWQER6LqSntcgKG2r10qADvzYoqUTnj7F0n
         oHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786487430; x=1787092230;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GAluQTC1HpvjZU0entrIRv7rLBpoBCi0VS32rmx7Aj8=;
        b=oUTerHzOYHzfs5wFYEVU7eaXdjAhp60tr/djIoRKPpqW7P4nTV+epzmkj6dACsZTOM
         cq4vZEXK+o+GkmQvgV778u6Uw3lYenKSve55ajsyW5dDIx6jQKKnKfVo4v8JIeYvm60k
         Y2vlx3Xn7jJXxq2Df5zchInx2YSapkwpMqh/s+PDQZvDeansNVjK+ON+LIY/S+BzqAfP
         CApLFam0tyriGrywlQekiom8OFYg8vMeCBUZqIqhUzAOGJSnk7lv5rdttQmk1uJRSwW4
         Zht8nzr/rZwdp68ZAM9etEwLlUSnW76KsA5XiV0sZKRg1rW5PLIRrA4jgQbcZHpostdE
         w2pg==
X-Gm-Message-State: AOJu0YzJ8uJLeNlN6Da04jetntHxosF93Tb9RWhv2BaA6vDY95uhYmCb
	Q47M/RQy2Or+Bri1hWn3TvEzZVZuSxsQLxRO03rH6otkRUcZZjiFx5+CbgZIXm/EpeXfXesmIoC
	x2MTEi9EmZtTVptfXHO2tU67jg7yFzn8=
X-Gm-Gg: AR+sD10tDnpdqbPJDeEjtG6NoJpK/ZbaseSefBCkDQQglbr3WG1b1X6mkLKb35oZrXz
	s9FkgBH/bLRDyAuhF0D9egxfoJWAnIsXK9tMoBnkZxrFgbX9wWj/K1APl8QHsSwur7dgfRnDsQ2
	wjpQaRp8KscwWh1565yfHgrwBkjtZYRsJeMWRo8HYuxAnNyLXzwUxtmHxte+9pdBjxc1G13C71s
	GEDOWfWVCQJDQ5MsNtwha2qkRE0DD8gIqCyALBEHEIHcqsIbc94J3GKu6SZHx7k/y0yiRG/uBAz
	0GogT7Zx4OxJIyc+Npcxes0dKQE3qH72ZOpTn73+fq/+uoWwoFVd0fxZvhtk7aRVU597lwd0mcb
	thx39FomzefbLWJT+e8npmw7z1y7Krwg=
X-Received: by 2002:a05:6830:710c:b0:7e9:bd00:c6ad with SMTP id
 46e09a7af769-7f3b7a23167mr511244a34.16.1786487430342; Tue, 11 Aug 2026
 15:30:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804120004.523934-1-mikhail.v.gavrilov@gmail.com> <18b018d0-7f7d-4975-b0b3-5e3c9f413698@leemhuis.info>
In-Reply-To: <18b018d0-7f7d-4975-b0b3-5e3c9f413698@leemhuis.info>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Wed, 12 Aug 2026 03:30:19 +0500
X-Gm-Features: AUfX_mxvZd9umIL-RShv2edCLQha08PkNNHjtYVDzPOfUnTe4RAPFxDGdW_lE6g
Message-ID: <CABXGCsMhfR-fOwUgKuQrojM8jEpdco_m9aYA9ph_EOrCfaPxeA@mail.gmail.com>
Subject: Re: [PATCH wireless] Revert "wifi: mt76: Disable napi when removing device"
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>, 
	Bert Karwatzki <spasswolf@web.de>, Devin Wittmayer <lucid_duck@justthetip.ca>, 
	Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org, 
	Linux kernel regressions list <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 2:11=E2=80=AFPM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> What's the status of this? Looks like things stalled.
>

Nothing is blocked on my side - the patch is unchanged and ready to be
applied as posted.  Since it went out it has collected:

  Acked-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
  Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>

and Nicolas supplied the tag wifibot asked for, which I agree with:

  Fixes: 13b7e6a96a00 ("wifi: mt76: Disable napi when removing device")

I have not resent it, since the diff is byte for byte the same and those
trailers are in this thread for b4 to pick up.  Happy to send a v2 with
them folded in if that is easier for whoever applies it.

Nicolas has also posted the proper fix for the mt7915e WARNs that this
revert reintroduces, which depends on the revert going in first:

  https://patchwork.kernel.org/project/linux-wireless/patch/20260810154923.=
32546-1-nicolas.cavallari@green-communications.fr/

So the pair is complete.  Both are still sitting at "new" in patchwork:

  revert: https://patchwork.kernel.org/project/linux-wireless/patch/2026080=
4120004.523934-1-mikhail.v.gavrilov@gmail.com/
  mt7915: https://patchwork.kernel.org/project/linux-wireless/patch/2026081=
0154923.32546-1-nicolas.cavallari@green-communications.fr/

Felix, could you also mark my withdrawn first attempt as superseded?  It
is still at "new" too, and it must not be applied - it replaces the hang
with a use-after-free:

  https://patchwork.kernel.org/project/linux-wireless/patch/20260728002048.=
19351-1-mikhail.v.gavrilov@gmail.com/

--=20
Thanks,
Mikhail Gavrilov.
