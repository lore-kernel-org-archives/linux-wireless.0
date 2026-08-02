Received: from mail-oa1-f97.google.com (mail-oa1-f97.google.com [209.85.160.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EF6390C85
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785659964; cv=none; b=JZCs+2C0seeRVqTuoe8HzPL9Tnl04AurbKuORbeqViKWe6y9lZiUQWTRTOQ3vVtu6u7EZNJtbywHjZskjkOrg3391nFMf89A+YOyZGCor2t8ikm5dYWHJ9/YxO/UtzXJeMdNqj2DQm0QoMp998StbYAB7v892jy8CwmUwDHaKnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785659964; c=relaxed/simple;
	bh=oDoM+/kafg5WMLv7D3QMC31ArtQ7F9a/PGEZvbw8C6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptrzQvax7ddtuB/z6kACxKr8hznGaPvC/tyT6fSHjO+FmoXjIEdrFMZVx7jT3QhSRx/7+ORriREqRYxt0k+SQN1IKRuSmo55IoVXB1m/ilWmAdbChJSsP9hEHdNcC37+ktFKvjBoheBxf6Dh4hWzipX01HwpdXCJkCyX11CA8cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=euyT78vr; arc=none smtp.client-ip=209.85.160.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="euyT78vr"
Received: by mail-oa1-f97.google.com with SMTP id 586e51a60fabf-456d267da8cso1054807fac.2
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785659961; x=1786264761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sh/ryW93h595xQs8WsIHCf/E5GVTDNcp/Vf4OJp+tiA=;
        b=kKOAGPSx973Fs2uyI7UZSjS1+LDCz8/zPdMMtIUQ0nQeoEDzLbb759y4h88yUPMrsz
         Hr2o0EYD+UdbLrEFgYd5KIDy9Z+Sn2+L0L1dFS7wQMMPE6mxjoiEmysAHXcTv+Xtat+c
         dhyfZ7pqWB8K8COdyI3lyZ4Q3SWIK1g6WiNJqqcTmlMmAWjMyL/Lz4d5Zp8aTt86xdkV
         7Ip/wF1XHy0gh2U+/mAeSkw2WU0Fyc+HYuDyXoLZDGZ138AZzanyw7AjVxYtMZCbVfbK
         qQFgJmYVOLe24qhMHYbPc2f0acNPRLsJXl4trsBnaNxlri5l4C3JZL7NORMCVsmeGG5q
         CHYA==
X-Gm-Message-State: AOJu0YwiFO+udPm6LYsbvsDSclP/wy6epJqiCv3eAWuVrCUebO3bTdbw
	c780DK1RvykvFT2Hq3avTcrRSLRCOC6EZwl9RO+afGP+RnLEt2q9XYJlwnOJouUBBhWowO5pjXI
	MndQlm0PVwKd7oQQC7D2YAVE+OS1TKNhOAoS81cYHCKw3RoUY7dvv86PgNzKo4m7BklV0hNzna6
	Ec4Sp+jdEyIB7BaOkYdh2x456Ca53WK7v0bq0BMTPDFGw2NvBsPOTYgEmxOv+2Q5SiApqXwnt2G
	ET21RIElTwHONoISHg6wlsx7nT2
X-Gm-Gg: AR+sD108jb8cerSMb+nIb9VxISt9XPmR4mFiIZu0RX8Cu07VHtbsp0lvKinrPyKyV+h
	tvEOlBhKQxkvnaKH4iZc8bmwf2ayuYwVBo2KdIsTmYLvhE23IuxxAZOtCQtsJZ8lAhYAqsLJsvk
	yOUdcsJjBd5XfYQVGudcduBMg8vlLLIQSy7pouHK3cIvMv55gmGujAKgPTAUwcFhg7g5F9qKIfC
	hLK6gSbPNTN8+32VxGbyjbN4CaNGEP1K1wg1ZiLG9MfzAHdy4J/VHCGHQifeIjszRG7yTMueUbW
	mcSdH8J1VIeEcBH5GZn13OSlmylL3sjXOutRpA0WcbP2GiB/IVagtq5NVuV5SpF73YAukKIiHRL
	r7D2q52+PgOV5N8TDQr/sYDXQG6CTeZFUB3gORBF8JuRyIYZ2mLQEaZYTpogzyMARuAvTJ3elA0
	z4NhB0x2jmL5JBiLKKnQ4woKXGL1bvgAWJkaElx84=
X-Received: by 2002:a05:6871:107:b0:43c:44c9:b87e with SMTP id 586e51a60fabf-4590573ba10mr10046177fac.3.1785659961188;
        Sun, 02 Aug 2026 01:39:21 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-458f66c1849sm537288fac.13.2026.08.02.01.39.20
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2026 01:39:21 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c1d137a68so44423381cf.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 01:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785659960; x=1786264760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sh/ryW93h595xQs8WsIHCf/E5GVTDNcp/Vf4OJp+tiA=;
        b=euyT78vrVQjOnHmQa4As/usMhcd6aDH+jfLi+AlWlnFLdBPCK/tlGo/Maw+XGWF/Eh
         yLn+2a6Ifz3WIHce5b3X0pxxdNGZi8AnxDKVi/LpXNmw0PfmRkF3I3NgUWb+tL5hv8tG
         C4NH09kzHnX7+8wHpcrnFUc1ptFWOmTQR/onQ=
X-Received: by 2002:a05:622a:1aa8:b0:528:32c0:8237 with SMTP id d75a77b69052e-52b567cfad9mr117236991cf.44.1785659960301;
        Sun, 02 Aug 2026 01:39:20 -0700 (PDT)
X-Received: by 2002:a05:622a:1aa8:b0:528:32c0:8237 with SMTP id d75a77b69052e-52b567cfad9mr117236841cf.44.1785659959906;
        Sun, 02 Aug 2026 01:39:19 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435def8fsm49457956d6.38.2026.08.02.01.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 01:39:19 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wifi: brcmfmac: cyw: set a unique cookie for mgmt tx
Date: Sun,  2 Aug 2026 10:39:03 +0200
Message-ID: <20260802083905.3819981-6-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725014411.170340-1-bogdan.nicolae@gmail.com>
References: <20260725014411.170340-1-bogdan.nicolae@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 24 Jul 2026 20:44:11 -0500, Bogdan Nicolae wrote:
> Set cookie using an increasing atomic counter. Avoids mismatches of completion
> events later in brcmf_notify_mgmt_tx_status, where packet_id != vif->mgmt_tx_id
> is checked.
>
> Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

As agreed I will mark this as superseded.

Regards,
Arend
