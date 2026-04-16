Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB011F131A
	for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2026 06:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776321255; cv=pass; b=fMvzg64JwcwzHYg8IicbKCo3E8miyyE2BUhMQYJtFccTMqmBR/ZpMKnflOoJFoSoVR0u3lqHsBZDs35ihRMjVzfjbSKTAwOhlmRlvN881us87OgE2oXIbwuxB4nfBvaaPmY2bIv47hW8/k5nKNcQqp3Tvl0wCIBQv2vUzn+5yi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776321255; c=relaxed/simple;
	bh=ZaLCLLVusWMatJ1Wrfk2al1TSqAPJzMf15F5vKkCGCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GixZPPZi9hLskLZi6bcbxNjnE5VF4WjR2wJn+r54tNWpdXOP3swnwhHCkQHkAzHGvmLifeFyntGCN6ZYq2KLgLk5yELaVF6GYDANTJIcUcivwWcdidpCKaxltPpnmBKvsLd4oMp5WvNzgjcB/9Drrws5J8B+GbkCVK4P4XYwkk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PwhbqbuA; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PwhbqbuA"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6501d242e2fso7338732d50.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2026 23:34:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776321252; cv=none;
        d=google.com; s=arc-20240605;
        b=NSGRVOYOSBG3xmElCMY6aPo4BIWc/S5K8P0CabUCxTIbafUvud6cxrbzuk4su7x4Rq
         xdNOLffbUnDnVQFkKd3koJNqa/v790QeNziuYHHlfhRE5lCnjc0OWyiy5F0vbD90Ykei
         bsGVSzCNKCOCJuzBj5udL35SSBB4t0y6HKUcbE3BC103u9o7NEzhBxxQwuht+8X1+xcO
         NrNzDU1TBkBKEmjrVr0J/jWjz5VILafA8pe8vYrT6kCWJ81nNmrVmGj7lkyEotqb2HIs
         Lsr0Xlj+Ca9fwSacfFmd2mFeURV+F0cGWZjlW/lfeHaleBLRoQqgSMlD4U2HQOjVPTqw
         VQeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ohAIqVNFWeW5tgnSvTKQEG5CsHX/rC4S8Y4fjn1RWXM=;
        fh=s379drQ7+8HDSTR6TxW4QW7pcC52n1MCo8KK6XwLkNE=;
        b=Z+VNhki+EDCrTBMX4jXPtJ1htcIy8j0kByxRtBUl9pKrESFNI1VeyfP2EVIj6BslOD
         czn3nmroIKOz7QnlUQTfi/9QiE70Y1GSUAwjpstdbb1J01ZkZbNqxmFt0+WbrQ7RVbl3
         0hcNslOq8WEyTY/RWqFcwy1XvstltKjfWTbXZmps+ZXUjTVfUwlpxyvRMVXXm6rock0k
         TRERmi48GH26HHJlpgrO99NYJlympoGCWxxilGFqX6PrZ9SNhUMm0RnNM4Z5DZfXf9H/
         QnnTWvsJR2bXJX2yTVroRd5IbxbdgCEFiD0V8wk/28aJPBzZjIMBRCtu/atM9o9mawPx
         BRlA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776321252; x=1776926052; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohAIqVNFWeW5tgnSvTKQEG5CsHX/rC4S8Y4fjn1RWXM=;
        b=PwhbqbuA+M77sgdD02M0wFO+MLtu302PZ2cOdp0cTZZWen4andlNqPGtJwMKzRysoP
         zERnRZYhJ2lQvZ4MkJTCU6stbU2vjzK1QoOQtydvKUqWqSWCUGDz4DYZu555T0pLlUaY
         T/8BMSmgTBuu3W+oXT9WQ+vUtLwQOaCYlPvh6Z95Cxl5CdtS2iy0GL/L8hcbAUlFyVMw
         BkwyMSW1ZGJyn39YF48intCpII0JQ0gW3wi5P4t3NJhxF9XFrsFRvmuLDh9IJCpFCYAC
         NZYwSR3zGJhBw10egX+nSDh5T3DU8VxSQaE2cAB4s7Ipp/MCmCfitYEPIEFWKNjeD27Y
         FvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776321252; x=1776926052;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ohAIqVNFWeW5tgnSvTKQEG5CsHX/rC4S8Y4fjn1RWXM=;
        b=s29UhSLM55BJ1klzpWgg1p0KhP2lkWhpjbjr+1XWZK2nuvpBnpXowQ5JYkNIHDQu5q
         hOxwbbPWlL1aIZUdhsKEnuwiLW0UdbqOt3/3GNtHbr9SL/1EyxH/h473CtSbZHiVSlNX
         7J24ytFj5JiGtGsvkniALZowsIArxG6Xugmro3OedtOE/nbbhMF4PYU8Zn3NUkLEuGt4
         SbhRfN1x4EiHdlYFiUSFAIl7WaA1S8sCTemJfhXGFvCPnN2y4KMg9BYpD1bYeCCpYOsE
         8vYIJ92iMPvgqzEmVyLw1iAy4hCrxyCSMwovDNlv3jlnNWhrAyAZRZjJNeJWz1ibPijH
         27wQ==
X-Forwarded-Encrypted: i=1; AFNElJ+195vhw3k1je3sYLDwko327TtfkqbkRJii3xSlduidhz4ufxb7Ix98OtbiRXJaN9qE54b2ZWUpUedrBrrSqg==@vger.kernel.org
X-Gm-Message-State: AOJu0YykvoZsgw5x8kR+7EIdvekPpO/ft7eaTKEaPAfhLTxW+5XXp9UG
	2hfICKnPF4q0mxC/5fJI2Z0xToInX7dofF0cvTdm74OAAepHWD5CpcVc0PCIlns3Ie6Xvqn4Vaq
	6/Re6Z3ig3vG/+7oum1oET2FEUVbMz8o=
X-Gm-Gg: AeBDiesNehdHRPyyt+LRUWoagOF1Ca4PdtQZeVEIF0nLL1h2Jw0OLlcKFONhZqF6VS5
	uneqUDkJwYxbGn+4/l1A3Og1yGqwie3N9CNd3jlE0syf41+cKnIzSRQQUn8Lqi4uuUYG+K+Hnzy
	IvdjtNbzOfmnyNaRfkKDtvxPWIT+shtY4RTvXMA370ketbrKJIsXYElauw1oLD3RvQYVQKAAt6e
	Qb/q4fQ8WPCe17Qdz7zFnUkWzenXO+VrZN+qs6rc38pUHjVyL3iHCzlfWDeqYqJWWl5uZm7kSuD
	Lt+oEi53LvKFdHNaJ79KitQaq8IzmBFBIl2/MjbBvxWZWfz0Yl/yzAbY/M6zBm8Y8Q==
X-Received: by 2002:a05:690e:b48:b0:651:b73f:2046 with SMTP id
 956f58d0204a3-651b73f26fbmr15448092d50.59.1776321252113; Wed, 15 Apr 2026
 23:34:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260415222425.1544638-1-tristmd@gmail.com> <20260415222425.1544638-2-tristmd@gmail.com>
In-Reply-To: <20260415222425.1544638-2-tristmd@gmail.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 16 Apr 2026 08:34:00 +0200
X-Gm-Features: AQROBzCQGSycL_FiW1klCKpwdUQrdt6fQm8Yx0hL54YnaAFFXmZplvFsiMyW7iU
Message-ID: <CAOiHx=nuUvf31J5khj4e4Kzv2wK4++TeZevXu3Z53qB66RagdQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] wifi: b43: fix infinite loop from invalid hardware
 DMA RX slot
To: Tristan Madani <tristmd@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org, 
	b43-dev@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 16, 2026 at 12:24=E2=80=AFAM Tristan Madani <tristmd@gmail.com>=
 wrote:
>
> From: Tristan Madani <tristan@talencesecurity.com>
>
> b43_dma_rx() reads current_slot from hardware via get_current_rxslot().
> If the value is >=3D ring->nr_slots, the B43_WARN_ON only warns but
> continues. The for loop then never terminates because next_slot() wraps
> modulo nr_slots and can never reach the out-of-range current_slot.
>
> Replace the B43_WARN_ON with an explicit bounds check that returns
> early when the hardware reports an invalid slot index.
>
> Fixes: e4d6b7951812 ("[B43]: add mac80211-based driver for modern BCM43xx=
 devices")
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
> ---
> drivers/net/wireless/broadcom/b43/dma.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wirele=
ss/broadcom/b43/dma.c
> index XXXXXXX..XXXXXXX 100644
> --- a/drivers/net/wireless/broadcom/b43/dma.c
> +++ b/drivers/net/wireless/broadcom/b43/dma.c
> @@ -1693,7 +1693,10 @@ void b43_dma_rx(struct b43_dmaring *ring)
>         B43_WARN_ON(ring->tx);
>         current_slot =3D ops->get_current_rxslot(ring);
> -       B43_WARN_ON(!(current_slot >=3D 0 && current_slot < ring->nr_slot=
s));
> +       if (!(current_slot >=3D 0 && current_slot < ring->nr_slots)) {
> +               B43_WARN_ON(1);
> +               return;
> +       }

B43_WARN_ON() returns the condition's result, so you can shorten this to

if (B43_WARN_ON(!(current_slot >=3D 0 && current_slot < ring->nr_slots)))
        return;

Best regards,
Jonas
