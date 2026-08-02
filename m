Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2657D390615
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785659955; cv=none; b=lZzbOYcjvyFNjqG6aTXBSu1U+Zi6Wq3r4KdhEMEeQcBxQFA6T6Q1ecia0miZ+HIshcGorxdZ2IWb7IFezgjFcRrCJ1xIInFNXDiEy0ozlLxK1AVYyuRZkaBT/wNrJpY+Agn0BMIl+lOjDpBepxLvciUHAj7qDCzp3DL1I9oC2ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785659955; c=relaxed/simple;
	bh=jdjGUbkBcV0dBBL5aNWg2VRyEgEe8YXwInGBRXnUr+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVPtgqXvFbSh8W86Lnv0H5PvyRCu8bpO/1/icHkfGlYY+MvGCBLdUx+gsKw8VpQhqhnh1Ls5TN0IjnNrbOqAKbw6TmTm3IVuIRXRj2PAi6sJMMyLXkTxGtNPynD6Qul8RlIwCq6pVpZJ1ytM1eTls9m635PaUXeopeCtP+0sFNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=MNSJJRjO; arc=none smtp.client-ip=209.85.216.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MNSJJRjO"
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso1718108a91.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785659953; x=1786264753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PSsJZEdiBtDK2B70Vi/SVAEmECezuO0RlJM9j9BqAkc=;
        b=Wu9aAo6gKBJAlbQ2h4GWMG67Fff6I0/hXLgRBG0Le49TbMpG7OT5+5/83YcjK82c69
         EVMWfvUNSaOo09mkiqmFGox0LRRMGvaMPiffW6NRmCWi2B6+yqiNfW4ufNSGge5JVbGh
         S7FWBZgP4ipQLqyCXuN5v9Nn4BxTPvDW/ZypFmvFKmd6oM8D3p15fLKRI7krdgU37P7j
         UqpisME5VeOt5d7efVwdDBFWCeNuYfdT7KzpvyzWz3kNcOSnomWZ7mFi//uMHGLA4nds
         ACGwpIpP7IsW0UgqT30Lp3W2c9tJkmaCw8TBMB7OAcGF2iBFhsI+DqbInNAI+NTP20bn
         JJgQ==
X-Forwarded-Encrypted: i=1; AHgh+RoIrf2NoXPHsuF6wPHxaTrORyzNw8Fbn/MUxdp6TWmd0bUckQRdutZc71ROeMd2nfjbxwwxcIS0X7loS4paEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOB/kaNDeChUhS37xjAmsmcq2/5shk33bZqn6JAhqn5GLjXsb5
	6ynmx8AiFo5wod/XYurNLQO3dtPfvCN5X7P4KoTOycauvpNw+yyf7zaOB8DWSPZfoU+H215pTB9
	XSMaBwuCUC5TvIYUFjFKrNYitJ34SAG0rfkE4TtTD7W80qSP7cFrnPRdFRF/biHTe+ag+wPbHXd
	vzN7oSb0md7nvLbY6mv821rkvj+rVuPh5jPzd+Y5Xl4PnhwEmO9izibNCnaIrgGuIapGM+Jhbvo
	ipVEReyl1CdAHFNd0sdyJtgVQ3i
X-Gm-Gg: AR+sD10VilYu3FMjqRk+hcqw4SMJzdFNci2YaU2HsD9MbiX+SrSAC7yGroLEelmht3X
	b450CGOvxaN+rGoLHekChi5ebKA/RYiW69//xS6FXLHfhrkLWmj0VudPGl/CU4B/7WY/Zlolml5
	p+D8Plqyd3MerxIEUIB/wcAsBrwOORMG/LwJu/eNnqybqgnJR1Eu/Cfsu/R67DKgkEo51rqVJcG
	Exe0ezho+ieWLwg9i+SB+j1XuVp74oJUPWQgx2hIFZBuYYP/lqxkIVzGEfou6nPcUTdL0Wlw5wl
	KjbFOkF2MTuMG2lu1DAVfTimORwG29hgTzlln+f811I+jHG1ZUR1290D0se7wdaqF4o3d8ORs9R
	6LQkmsR4wT/fcSkmZaado3gVBnU7zMO76Y2iI2caB9JXjvjVKiiwbqJncXwM3mKSp6Y6kbQvG3h
	H0T7KBVUMeIfoZItabHqXZsqXGqSkyHDuYkzRUHQo=
X-Received: by 2002:a17:90b:2dca:b0:38e:6dd:a9ad with SMTP id 98e67ed59e1d1-38fbc0baf26mr5847421a91.0.1785659953327;
        Sun, 02 Aug 2026 01:39:13 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-38fb3054792sm542581a91.8.2026.08.02.01.39.12
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2026 01:39:13 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5276aa86d00so24594491cf.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785659952; x=1786264752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PSsJZEdiBtDK2B70Vi/SVAEmECezuO0RlJM9j9BqAkc=;
        b=MNSJJRjO4AMo52+Us9XXHZHO1kqXx+FQ5hDLWNrupVBxrXPy/UFSZxEJQwMRABQTGw
         5oERSDsjiJgNnJKyCILuaDfuBFKuNl/DWhB6p0zWDPuGfnjyOijS01wDHZeJajXisfSO
         J6H4mnuYTafq2/O2UC9IsNMtiI2io6WZ4anXU=
X-Forwarded-Encrypted: i=1; AHgh+RpwMkIJf9GchxjvaG6YSDc3Qm8k9MFgv07uMYkZgTLjZBPtXxboqMc/088knQMhyMDYTPd8WpWUbM00t6oHSA==@vger.kernel.org
X-Received: by 2002:a05:622a:141:b0:51c:7d0:7ed7 with SMTP id d75a77b69052e-52b567da7acmr119734351cf.39.1785659951952;
        Sun, 02 Aug 2026 01:39:11 -0700 (PDT)
X-Received: by 2002:a05:622a:141:b0:51c:7d0:7ed7 with SMTP id d75a77b69052e-52b567da7acmr119734161cf.39.1785659951525;
        Sun, 02 Aug 2026 01:39:11 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435def8fsm49457956d6.38.2026.08.02.01.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 01:39:10 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Cc: arend.vanspriel@broadcom.com,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()
Date: Sun,  2 Aug 2026 10:38:59 +0200
Message-ID: <20260802083905.3819981-2-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722110713.115988-1-nihaal@cse.iitm.ac.in>
References: <20260722110713.115988-1-nihaal@cse.iitm.ac.in>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Wed, 22 Jul 2026 16:37:12 +0530, Abdun Nihaal <nihaal@cse.iitm.ac.in> wrote:
> The memory allocated for buf is not freed in some of the error paths in
> brcmf_sdio_read_control(). Fix that by adding vfree() calls.
>
> Fixes: dd43a01c5cdb ("brcmfmac: use dynamically allocated control frame buffer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
> ---
> Compile tested only. Issue found using static analysis.
>
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
>  1 file changed, 3 insertions(+)

To be applied to wireless tree.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend
