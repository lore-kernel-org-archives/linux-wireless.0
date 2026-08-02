Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED86390C81
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785659959; cv=none; b=WrfzKmv3w861wHtS+YS17m+GKSXlXOIe9kHATlI2wgEbbq2uiqHs4fkUvMqO8pE9QWEEpFLJKh+wJs+UFx6oMsXuKCWI53of1TpHuNeq3KEXM1tvFv0kbXUPPegeNroXe7U80HY1Vepf0nGXdV78dzHT8j4dCqfB6Ln/h4weQMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785659959; c=relaxed/simple;
	bh=qBzJRPSIwfkZH2tMi/hPWOxxUFCnhOzk5IKDuNq0wkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlSEahPH5DDsxQSnP+pAQnTq3MagrGf6lg+4Oyr7zysQcOGj4UmTyGNlyhWrlB69Ai0O+29cq9N5GV9eRlpZ3eLrhi3RFNYk1VlmeH0AMbx3yExCQE6pNaMBr2UGsLFX2fecaH1T0Cz7hTs8b5iSZ7rXvH39e79Tx2WnxOzl7ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JPl6Zjuo; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JPl6Zjuo"
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-ca7bea5e5b3so1812656a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785659957; x=1786264757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B+VjNc7Cj5tMz12o6jEVSiidd0PWIOvTtdYHTchu4Pc=;
        b=o+XRfKdxG2bwKWEG6M35I9T0aKe5iJVQa+ZtiQWCO4LLyk7z7B+Bx/FAkLCuQ1jyaz
         KVTTIfoLHxW4eymEEnZREZrjjImMZu8R+G+PvBo/2YkmZuBr36Z2o3ZkWWhbkVCjSV2R
         OiPtDL7dd+i3mT3DqQNi/NrKmgYJ+YvWl7Z4VmxaNfPWTERAwmTKJ5mQJiZoKolV0lxQ
         TAFGViTxLIH7v9Z3NN1f+3pIezJcx9ZXsyiFjh/42a0zRakTTNsm+YWl/do/ZEoMwG1v
         FauY7lalbDGKVMAyL/sScJkgUbyFPrG3JVkesusLJjevKrQmJrG20gv4bObNiuFHqD7O
         h9uA==
X-Gm-Message-State: AOJu0YxLKeuONuHCvNEJkrcH75ylQs8YRh9JWnwRmehp7t9ahJGmzMaA
	21RjCkDelhbHlp9ElJknRWHVvX64TBJ48ixlIP8r4UEgSWLD7oe8R9+j+AqSRD6tcJuon8ukT9v
	lSR0FbPVLrt5fPCGJQmYZiAfShtz0rq09ZQ6RzC6aPHFHw82IDRCmFX04xeoTjTtZECRoc8DEhg
	lrXGa5X5e7iaKGTSwrChCZj8oMq42NMCH3fyovO80G/CII6XIWO9JZrbns8K5t8jD0LO75WPx/Q
	NeWcsH/jbd6vqmWA+IssReiy3EA
X-Gm-Gg: AR+sD10NzLL53eok1Vi79ngrJtdqfEGMJeu4PpFr9fY0US8mW2M7tObCkGVpPTRiSn7
	TGnl4JL5wZfIyhjwpQjY+6MqFhG1rlvp4m9Luaz+KxK5xcotJHAIBwFyUh86cnX+rwQl3Gm9lAs
	AzmX/bL8nu89hlCj24mGcZSN3omSOywhkuY5FUdAxNZJrsT+b378GWgsJHS1JD41/rPWnDsUxSI
	PRQ/5ayJci6czB/3Piq5nJC8VAfG0lpAEa1N7rLXAOkRI7v7C0FV5SNtnTvBnElxVS4MugLD3A9
	ZO9uhd9K9ME2y8d9FjUbTqh2VmdjYf8YCqCPoyybof/1F4G5TYmuZ2gjANvW29tFXrb8OLwD8hR
	KKlktohbaanZvQCh/Izkg2QjbgH2McNOubWFNu3E9ssSkgpKiivDatIqXSkXpf8wGkwYuBCAE1b
	+TDGegoE4/SBODfEAEyyJVrDE6sfzKRJExF8BttK4=
X-Received: by 2002:a05:6a20:6a26:b0:3bf:6222:2e7e with SMTP id adf61e73a8af0-3c92a51779fmr6228977637.4.1785659956663;
        Sun, 02 Aug 2026 01:39:16 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-3153e2af19bsm476615eec.29.2026.08.02.01.39.15
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2026 01:39:16 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8ec3314f65fso22974656d6.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785659954; x=1786264754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B+VjNc7Cj5tMz12o6jEVSiidd0PWIOvTtdYHTchu4Pc=;
        b=JPl6Zjuo+q4J61UJ3U64bxa4d2CtFDi5KYA/ogHJ+1tPDIeGS/bXYQevkOndtTubjF
         gi06KgJLnYg0Cc58DFKUfYNs8Dvf+eFtjs6mp1xxAAadh6OLWh5zFPFKBl8cloQoE/5c
         4y5QewlPeWclwgc7iXPOH4e7GgNaoaqNTjD/4=
X-Received: by 2002:a05:6214:5b06:b0:8f6:2588:778a with SMTP id 6a1803df08f44-90849558b55mr131975796d6.4.1785659954727;
        Sun, 02 Aug 2026 01:39:14 -0700 (PDT)
X-Received: by 2002:a05:6214:5b06:b0:8f6:2588:778a with SMTP id 6a1803df08f44-90849558b55mr131975596d6.4.1785659954328;
        Sun, 02 Aug 2026 01:39:14 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435def8fsm49457956d6.38.2026.08.02.01.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 01:39:12 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Can Peng <pengcan@kylinos.cn>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH wireless] wifi: brcmfmac: validate msgbuf flowring IDs before use
Date: Sun,  2 Aug 2026 10:39:00 +0200
Message-ID: <20260802083905.3819981-3-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723055618.550834-1-pengcan@kylinos.cn>
References: <20260723055618.550834-1-pengcan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Thu, 23 Jul 2026 13:56:17 +0800, Can Peng <pengcan@kylinos.cn> wrote:
> Firmware messages carry flow_ring_id values which brcmfmac converts
> to an internal flowid by subtracting
> BRCMF_H2D_MSGRING_FLOWRING_IDSTART. The resulting value is used as
> a bit index in txstatus_done_map and as an array index into
> msgbuf->flowrings and the flowring state.
>
> Validate the firmware supplied flow_ring_id before using it. This
> prevents flow_ring_id values below BRCMF_H2D_MSGRING_FLOWRING_IDSTART
> from underflowing and rejects values outside msgbuf->max_flowrings.
>
> In the tx status path, complete the packet with an error after
> removing a valid packet id so the skb is not leaked when the flow
> ring id is invalid.
>
> Fixes: 9a1bb60250d2 ("brcmfmac: Adding msgbuf protocol.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Can Peng <pengcan@kylinos.cn>
> ---
>  .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 46 +++++++++++++++++++---
>  1 file changed, 40 insertions(+), 6 deletions(-)

One nit: there is a double blank line between brcmf_msgbuf_get_flowid()
and brcmf_msgbuf_dequeue_work() in the resulting code. This comes from
the pre-existing double blank line that was between
brcmf_msgbuf_remove_flowring() and brcmf_msgbuf_dequeue_work() -- worth
cleaning up to a single blank line.

Minor enough that I will take care of it while applying if you do not
send a v2.

To be applied to wireless tree.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend
