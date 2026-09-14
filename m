Received: from mail-oa1-f99.google.com (mail-oa1-f99.google.com [209.85.160.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EA8443E4E
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 20:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416300; cv=none; b=SqODaVdqU8vLZ8Ivl/+vOAAsF0jbzQyNG4DowGXcBY1ednQ9TSxq0/vcJlRQYeyzCx1DmT4B7vk7ec7uA88R3tK0XpXKYgsEGF7415TgJa5eSPqULEilTiEq7JbbMkVYqn9V/OKWAmWn88byW/I+du6a6f67PIw0xXxGkvaEzd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416300; c=relaxed/simple;
	bh=vQ5BcgY5sdG1CQBpmPGsw0919m9BDRY1Jb3LHemijU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PekFzSY/wRjHCSEerD1Zvo9syu5PghFc6+0qPlxsTKYxx0MpNY5ZIm0xM/lwzkjHGz5xRzyA9q0cwaa3APJXNtG6ffe8rZBy4c1B101tX0EpkK5Sov4fpssYv0YrQERORBwNUSYEcNSFFe2277NHYOneXQWnHBwmOGCZBG+uENA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=G9FE+5/o; arc=none smtp.client-ip=209.85.160.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="G9FE+5/o"
Received: by mail-oa1-f99.google.com with SMTP id 586e51a60fabf-46ac24346b1so142998fac.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416297; x=1790021097;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5HCcEwGsZkXP6qM0+jBu8phPLOnSGjxwqZlmClhGp2w=;
        b=gHex1dGM1g5PBGfb3iDI3Lwx/bYLjDlTuOYtZArZFiC0jxmXL/Mfju7Ak8GwVrKQ/g
         lTVOSrWDt9iLvHH936Dq5qXCuM1tx0ohAQ9v6PXXcXJfN2pBlq+x1TWYrMCdA9XHQuc2
         OA3hzZfxpMEw8FkLYUarLd37Fr0LrgE47rgSsl3Jg4nlNL3+8SPrVG0II8jWBON5buiF
         wTzwIO31xHlmn3SOGZ3jMxndLyYGg0+PnYK59OdJemnlQvGnOfD8IXESotde8NDpQyM9
         kUL1zqGcX1sFfCYEA5nawuV+3mpEjpUKGQR/aSVvFDDdK0CIiArzyg31QdQLY80oq2oa
         N51A==
X-Forwarded-Encrypted: i=1; AKwUvBz1km6nD+EOVPN5lV22dbvId9i6vwedtyCsq/BIkFM5YPOCKpO7UaU133cYlRCPuYjILEfXNAWv8NmwacJ2Pw==@vger.kernel.org
X-Gm-Message-State: AFuF++kZnp/UuOX6+/HrMAu3Qj6kLyF0RX67jAleglGhOpx9xZd/QeZX
	9MOYl1JMubzNIeCycArLU1wZdFXUdau5QHEIEuBDzPlp2lPg9koG93HeqzYcprzyjd4O3GRR4n7
	XH1kQat839ReJy7Z2L+50ZZyp6xzukGwDvFyO0bZA3RZX7q5ZBIIiTEZ9nDvBirE0PuJDg85jr0
	M3OciF2ZazUogUZcgZ5dXOsMXMIndQzQouW5+9WTD0fHhZtG5Y+2AsRCeOfvmNw2vkYqG3iPKnM
	by0HyPa5x45m7HlUbH9TxqBq41f
X-Gm-Gg: AYBFou1RXiyMJox0Z/V4xNsdMPSul5WUyK+yknDnLB31h6DJCKzBIGVazMGNU1UhwkF
	cPzHV5o9cHMM4YdM4G29ysOo6Sz0AOAhE1od0Jedkwg77y8oKGVeHr5FkPrW0FscJIo0Npyc9DV
	UDXYrRlXvf2ctCCG6V5Jq3oHZmARFIe9x8mN7C+xAjpv0UL5IK6o7jlPqieNKVul7FSPYr4p0Om
	YlAJWmjGZSOPZ13WK9dvTVBnoh+B0xLYJF0nPK+zeBn/DAy7eBPjBWxXTaGlrAknWg81nayR6OP
	uU6xVSP9GbgPVt6wE8EAHnGA0ifAFEYAm2rZx4vAWi7yGTgDizQRAnGl2TbdD0QzCVOTxjNnmQ1
	5qYg5rbvUB4m1tZ8x1bxDO+0VPAdJo+nRebCmFpExDoGRebWHtvZ2av7Vu+pWfodRO2K2nouirU
	L5z9F5W4aJJJFhNjAh4Q+Gl25bCe9AKsCy1ZtlAmJGsg==
X-Received: by 2002:a05:6871:5822:b0:44c:3269:4d40 with SMTP id 586e51a60fabf-481f7d378f0mr2787123fac.7.1789416297091;
        Mon, 14 Sep 2026 13:04:57 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-47df9312392sm166459fac.9.2026.09.14.13.04.55
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:04:57 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93a08ff8451so369809785a.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789416295; x=1790021095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5HCcEwGsZkXP6qM0+jBu8phPLOnSGjxwqZlmClhGp2w=;
        b=G9FE+5/o4+KH2sgkVN1PeyWDIrP3CR6pEHfkcIwxF0GUyYZnwnZVP2y4/UbpoiA8Jm
         1X9sXNanTetdDD/MEmWaVRdC7hukyc8V3y+Fjk5qzE01LZkjuDElnLVazsARWeFILjEe
         PueyHMHulQfXvjmP+u+nq0ax3yVORpPwjrMOo=
X-Forwarded-Encrypted: i=1; AKwUvBxHBo4Pm7d/6HY0znb/9O5N/PxLSkvNd9P5OxMzbpHP8iNfKsAUjDr2GC0kHTcZaWgB6B8U3LpOWIPiZahOkQ==@vger.kernel.org
X-Received: by 2002:a05:620a:2590:b0:93a:14c:3296 with SMTP id af79cd13be357-93a2985552emr600514285a.15.1789416294930;
        Mon, 14 Sep 2026 13:04:54 -0700 (PDT)
X-Received: by 2002:a05:620a:2590:b0:93a:14c:3296 with SMTP id af79cd13be357-93a2985552emr600505585a.15.1789416294251;
        Mon, 14 Sep 2026 13:04:54 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939ebda519bsm1038790085a.26.2026.09.14.13.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:04:53 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Janne Grunau <j@jannau.net>
Cc: Hante Meuleman <meuleman@broadcom.com>,
	Gautam Shukla <gautams@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Jason Huang <jason.huang2@infineon.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	asahi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH] wifi: brcmfmac: cfg80211: Report port_authorized for 4-way HS offload
Date: Mon, 14 Sep 2026 22:04:49 +0200
Message-ID: <20260914200449.1747117-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260912-brcmfmac-4way-handshake-offload-authenticated-event-v1-1-e41a6a8281a2@jannau.net>
References: <20260912-brcmfmac-4way-handshake-offload-authenticated-event-v1-1-e41a6a8281a2@jannau.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Sat, 12 Sep 2026 11:40:51 +0200, Janne Grunau wrote:
> Since commit 416386060 ("Mark authorization completed on driver
> indication during 4-way HS offload") [0] wpa_supplicant expects
> NL80211_CMD_PORT_AUTHORIZED to complete the authentication when the
> driver supports 4-way handshake offload.

In brcmfmac for 4way offload the driver waits for two dongle events before brcmf_is_linkup()
returns true and subsequently brcmf_bss_connect_done() is called to inform wpa_supplicant. At
that time the supplicant did not rely on NL80211_CMD_PORT_AUTHORIZED.

[...]

> Link: https://github.com/zephyrproject-rtos/hostap/commit/41638606054a09867fe3f9a2b5523aa4678cbfa5 [0]
> Link: https://lists.infradead.org/pipermail/hostap/2024-August/042893.html [1]
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=2302577 [2]
> Link: https://lore.kernel.org/linux-wireless/20260911065656.1269623-5-Jason.Huang2@infineon.com/ [3]
> Cc: stable@vger.kernel.org
> Fixes: b8a64f0e96c2 ("brcmfmac: support 4-way handshake offloading for WPA/WPA2-PSK")

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Janne Grunau <j@jannau.net>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
