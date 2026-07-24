Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7865C3264CC
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 17:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784912933; cv=pass; b=lAjxsG8aa8cW1nFS2eHXgY/8/1ByMuWxXJGkj7Z8YfzSNBOw1bo6174xsZuSXBeWLB81MkYh3lrY6dtyiLA1+CqJDbn4ApMgo9WVZCbpnAsLFvJo3ttnLHZgpF8puA7lFxys3Z+A0D6izNAHOigH+qBXP0JzAdrHYkKHpOd6Cb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784912933; c=relaxed/simple;
	bh=o6QFhMA78xOTT6DqNK4oOLhsB/pOTYepo8N9N6WpM3o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=oYphD23HAOyfdHD/B/VWGpYxjCQpQ8AdjY30C+8eSRXiMu9a9lQdiOk/7CtvgmW4RnxuIh3GcLAWlWmQunPL0jWINTBovwSdQCozJQzqzFZkUF2NcS45RDQaSDiltqQ/DigSnHSQRUEUsC5J/PnkFfzO187zUk0c18ozY3dAXKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bEHhPAdi; arc=pass smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bEHhPAdi"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6a38d83a480so855076eaf.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 10:08:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784912931; cv=none;
        d=google.com; s=arc-20260327;
        b=mZ/aHrtlP5WWrgewo35p6TQprb8IVE9DoeiZT1sVru7d8/M+QdBcQFPJDTzzm6PxDY
         fr/k+z2AfRXWoaoRKQ+plJjoaQ/GHYCCE7n9qejrBLQuq9SIpLBQb1ueno78bpZ2ZgR+
         Nh5LHhDlYNYSnrApU3cI6ZVG9b+/Z1KyAyriYn4uBf0DnhvprmRFpd7GPpxCDW7IqNyz
         ton4ylb2EZQsCcFSJm4U+eYbIgrPglwD1SSCCAVkSmDad2TvaRK8+c9rDPSxveyHWaQa
         u0xh+8K3TifRYojfanFX7LVrpYK7Y6c+06XGJL4Kcy0R4NLehG/F3LLWI+6hAnYaY3x4
         dqCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=o6QFhMA78xOTT6DqNK4oOLhsB/pOTYepo8N9N6WpM3o=;
        fh=8w1dYds+YaEGgOo/KnlI8cxnzi/17EonZLG7q/5pdaE=;
        b=E3O9QBcDBlxkESBC+VNkDMkVWnlcKJj/ICMkVdt9FcCqsqhVS9yLXYbvh+OrPi/B1Q
         cgitcqRFmbVUgZeAqbKUkNs3Maoh67SV7xH7XXGJKlmBMsrElbHYEpVvt6o+EWEQtBhb
         eEQihyM0hZTVCFJpWMWV89t4w0X3Qc7itT6UkFSy7gU39eT0xhNAiPspMJ3o34M3Ipqy
         1AZ4Jkf8felFECQ3g97X3gE3YXmqXYPnWEeF2mBNoqRW8iU3VQ9HK/mNd6sh9MIUVEQU
         R0tHZkJNB1lHTYoDRY7wDHxB2FKx8h5LdYhbKDR8pTnKNyV7lWTjEtmjaot3LAmEU9BP
         fxuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784912931; x=1785517731; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=o6QFhMA78xOTT6DqNK4oOLhsB/pOTYepo8N9N6WpM3o=;
        b=bEHhPAdidNjE7QpJL28E0ughPPUGmB5zegNgzBzrROZ6lK6Rc4oQmm2cxWvDA6sEpl
         wgPutnlkppaFVdXdQj6mLCQV16OwuRXIDPoiEPqhH/RH77CZCNueLkzxs7HNdjXTccoE
         28FQmus9QY8vDGwal70bPeE0tZtPANkZJGykY8thznmEI6u8MGvp8r4lN32v8vQJdMPp
         r7OqFJaoAGYTgwjbA+6Eo58Mp+HZblVga79tBjn5R+3EiolWY7+cySWVYzUPvnvszCje
         o6609vw2gJzKkoTCBJARYQusXUPBr1gPqZg1zPMkmYzW7A1qjCiA1D1q/SyeEWwg7CHD
         BpWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784912931; x=1785517731;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o6QFhMA78xOTT6DqNK4oOLhsB/pOTYepo8N9N6WpM3o=;
        b=F+GQ9wQ1rPgFDDuhJ2mz3p9E9urrUPQSdxgXAr63f7alI0go8I7a8wEcuXur3Unfan
         CsiGichS43DbIsP4IW4NdadkSresYzumcCykoTwzsYwWgPF6L28P0DS6XU4civLgL/on
         Fg2SrC5VpJ1kGmXexUSO8DUvHhe56GeSjcgpYjn6SEKz2ZUxYmMunpTQ1ggD9PvXASoH
         Ckcj4xBUINYqbe3JEeddx+R/x9sQravFXKqf9fLE24Yvn7M+0n4A/Qd4wtjiGoPMje6a
         nOAUC3uq0kVhgFJ/WE/bIoRgFuoX4QgcATkfa1xNqRiyq9jd4cfLb7i//EUY3GNx5IGD
         0MIQ==
X-Forwarded-Encrypted: i=1; AHgh+RomNmvIdSZDoc0eog1QekAhCynhMpBjACRNDEBmBSG9gNPPkv7Q9uvxJEt149Z0xmdHA7cuKZgjTSTNiRuqmQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw34jZ8LvWWBrhB8uWzO0Mx3a7eoKSOR3ozXdYAZRm0hEZ5qERk
	7fFP0LnQ63poEbfDW4Ey5ZpAVYRo7ELGvNC0zFJQ1mbBbNDUMN/ac5meojUWtzJTrYYoMz1Ol8J
	j+m9m33wF1EiBKwUW5nAnJkVcSgU0L0yzz1O4
X-Gm-Gg: AR+sD10WXuOPrS4IzjkcKXvZZvuJtwVsV5Xqhsurv7taG/Xs8SlHgfYmxqXuCZvfE0i
	2rsoN2PUeTwWcApiHCWvHmNEml+2CnUGYDMzN1vaIGUZN9q/wtO6BYWEm4cImC557NgvhvdSIy9
	1+WBWuTmtIPXKjQ/wGvSCIyQ2Zgr2YA47QY+2OfkmK7zy21veLBuL11BCxELjGJBFIILGEgYRY9
	mXyNO044NiJgi44fvmGxIcDdQIWMO/WgGtDapHQCAvSLDqFEjOSBnBVMCOBVg==
X-Received: by 2002:a05:6820:625:b0:6aa:e267:f11 with SMTP id
 006d021491bc7-6aaf42b4d9fmr1237502eaf.12.1784912929865; Fri, 24 Jul 2026
 10:08:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Rakesh <alasyamrakesh77@gmail.com>
Date: Fri, 24 Jul 2026 22:38:38 +0530
X-Gm-Features: AUfX_mzbWe3GYvVDnp3WU_ceLnxCwN-vmMePwoPWJ7VRJ2N2_wSwXtM0XDqkowA
Message-ID: <CAMizObnmGPi9rt49LfMCK-XFrjfZSBkJWwp4_84X+PbeRUrNrg@mail.gmail.com>
Subject: [BUG] QCA9377 (168c:0042): recurring PCIe AER RxErr/BadDLLP errors
 with ASPM enabled
To: linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I would like to report what appears to be a reproducible PCIe
ASPM-related issue affecting the Qualcomm Atheros QCA9377 wireless
adapter.

Hardware:

Dell Latitude 3500

BIOS 1.37.0

Intel PCIe Root Port: 8086:9db1

Qualcomm Atheros QCA9377 (168c:0042), subsystem 1028:1810

Driver: ath10k_pci

Observed behavior:
With ASPM enabled, the system repeatedly reports correctable PCIe AER
errors, including RxErr and BadDLLP. The issue has been reproduced on
Ubuntu 20.04 (Linux 5.15.x) and a recent Ubuntu development kernel
(7.0.0-14).

Workaround:
Booting with:

pcie_aspm=off

eliminates the errors completely.

Additional observations:

ASPM L1 is enabled on the link.

L1.1/L1.2 substates are enabled on both the root port and endpoint.

The ath10k_pci driver temporarily disables ASPM during initialization
before restoring it.

I did not find an existing QCA9377-specific ASPM/AER quirk during my
investigation.

I have filed a Bugzilla report containing the full description, logs,
and supporting information:

https://bugzilla.kernel.org/show_bug.cgi?id=221784

If additional diagnostics or testing would be helpful, I would be
happy to provide them.

Thank you for your time.

Best regards,
Alasyam Rakesh
