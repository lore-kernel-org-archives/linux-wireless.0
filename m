Received: from mail-oo1-f97.google.com (mail-oo1-f97.google.com [209.85.161.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEEA3BCD0A
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 20:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416254; cv=none; b=cYSHwO+O/0Mx9ZWABxF7L0szi75Yoy33uwECj2Zskl2k612BJMlPAQWHJACbXuuGJaFqNXVty9XHkdWiypXZVPmVhgaU4ExVhTlu8YQlD/gbBoCaxmUD8B8C3EYHtVNMvmsp6+0ZvzJBHtEGP7qRpAbMGWAlhFuu3SCWpw4R9/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416254; c=relaxed/simple;
	bh=gVBPMHDvUFZ7LHqXksbl0G8iSclpJgOhQy7Cg7sDOSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AS5RM6ODPGavUeB7B1gBpqYHQo0kcjzLN0Pw3rVeZz+aym6XuRXScXyQAGjIOk0N5Gd2gGgL/2F2uIhBMT4vh7P8+GHMHXEEOCV5r309DzY68iYnge8P1mrUwrxM5LL4ixq9SKe86TmG1QgCeECKDkXsQVyIt1055VPCS2VL2z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Rpu7H0X1; arc=none smtp.client-ip=209.85.161.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Rpu7H0X1"
Received: by mail-oo1-f97.google.com with SMTP id 006d021491bc7-6b8ef7de4bdso810014eaf.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416252; x=1790021052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pp623zgj8rh3D0bcXBH5BWiFVK6JWL+1hwJlGhtfFXM=;
        b=nwhFw3ldcdYUSr9WMU8cpnVqKH48qdQZ+FQC4b/gA14qebeG2l8gmuWL4ajNj1f8X4
         PybjA8+aE1nqAllGv3LrUQwv8ImzNqFiGjLf3u2ccUZuu7RHbFYlRRZR1jLpgUqYWT7F
         19Yx4Ai+DfNfx2DhzH0IN6S4Gm78RrHAfDhqXKr/udnpMYkI+v09he5aNwLiONfTWTCU
         z/5zR/z9m3YtMk/uMIkdN8Y02ELWPxIB7IvweBvYDlHqYVFu75oE8OmGfYHxaaUhOWKU
         QuMpbdW3kGY0s9v3wGHlEi3eQeiMaH4gqFhUHppbO4ZBddtG7DUzZx+iBEIZ14GN7BBQ
         V1Jw==
X-Gm-Message-State: AFuF++kwDgjitfguCfIci8yutLSdg1EAuc2D9zfVET3Yjf3S7oYIMAnc
	b96V7Mjb0RtH2JL/0Nhzgjml6zO6rWozDmWtio3B9gbP4UPJYQQvewI6+qF1cjDLRwoNYWlufPR
	2L06dgwHRlcDJ5gmGIQAka0x5dDCaZl5Sm+p0A3lv1u36P6TEMwNn1nqR9FNT8ghFhpgIAR1p6A
	ysQqNlocbgj7/j2M44PFy2tCQlh6QSN8R4Ok+xyUeCIu/oO9ehFcXEii6UeydE+ko4I3/rkYZKR
	assE+nqykiGhzU65wravw2zgxeq
X-Gm-Gg: AYBFou0KmPUU9qCgEhs44APFRK0tk2MCinbiOnByi0rHCZCgzggqctcu0hvhiD3iZYt
	t6KBY77BceGXOIAjuvGauiZ5rsI9PsgF1utEh2xAoGUro06uz186ohi6HKsflFTy+IQ+AieXMCT
	Glv2qkqHyDXxIMcWPLp4V8zvBOcwnv7m/0d74OkdHIlOCfXIDR2bFM7EOnrMh/Ug/4pZQOkRwro
	Po3WxE3UM4y8JLXCov+e699emg6e9zMJR+C3GjjpGKSJxgC8JRJzoPaDmmJglg1PpFRl5ljkxyf
	8cvzbO3ISBckOgolDO+sbkXp18AODtYjJ3UcfblufOPpboZUW1ZQJZvXkHkHgFJjyofbaW6ymGR
	aWtbz3e+/629jdpsmoaZN/bjlYwaoxr3+49WXx+WoAOGKxSv0rlqS9jpy3oYYZHrX6TOznrsY6c
	+4GDw4r73iOlSI7DffQb+1IWYXbOF7gX60ls4V4SQ=
X-Received: by 2002:a05:6820:2085:b0:6b7:8396:f3c7 with SMTP id 006d021491bc7-6c541456a7dmr2426988eaf.41.1789416251950;
        Mon, 14 Sep 2026 13:04:11 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 006d021491bc7-6c4665a3980sm46282eaf.19.2026.09.14.13.04.11
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:04:11 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90c8da50f8dso99461336d6.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789416251; x=1790021051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pp623zgj8rh3D0bcXBH5BWiFVK6JWL+1hwJlGhtfFXM=;
        b=Rpu7H0X1Tii1yxIZq1bHIi0yR3axnErBWjd20QH/vtit4oNfT35Qxm62yiSah+YmFg
         tvmRyJse7AEcORwi7IpnSk4J0NuQp35+/RRr5VPnC3j9gs686sC2pSJZLSBfKnkt7/2s
         lWB2YjyD2EqOyoU6xyEiNED6MEvaUGtr2C7bc=
X-Received: by 2002:a05:6214:d8e:b0:90e:96a9:4c5d with SMTP id 6a1803df08f44-9122e4f371dmr67123576d6.15.1789416250688;
        Mon, 14 Sep 2026 13:04:10 -0700 (PDT)
X-Received: by 2002:a05:6214:d8e:b0:90e:96a9:4c5d with SMTP id 6a1803df08f44-9122e4f371dmr67122906d6.15.1789416250177;
        Mon, 14 Sep 2026 13:04:10 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f47afc2sm102712366d6.20.2026.09.14.13.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:04:09 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-rockchip@vger.kernel.org,
	kernel@collabora.com
Subject: Re: [PATCH net-next] wifi: brcmfmac: Improve D3 substate entering timeout handling
Date: Mon, 14 Sep 2026 22:04:07 +0200
Message-ID: <20260914200407.1743850-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908-brcmfmac-bcm43752-suspend-fix-v1-1-32585639d763@collabora.com>
References: <20260908-brcmfmac-bcm43752-suspend-fix-v1-1-32585639d763@collabora.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Tue, 08 Sep 2026 17:26:12 +0200, Sebastian Reichel wrote:
> Some firmwares (e.g. BCM43752) do not service the D3_INFORM mailbox
> handshake when idle, so the D3 ACK never arrives. If WoWL is not armed
> the device is going to be powered off during system suspend and
> re-probed on resume anyway (brcmf_pcie_pm_leave_D3() handles that), so
> the missing ACK is harmless and must not abort the whole system suspend.
> When WoWL is active the device has to stay powered with its state
> preserved, so keep treating the timeout as fatal.
> 
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>

[...]

> @@ -2653,8 +2653,13 @@ static int brcmf_pcie_pm_enter_D3(struct device *dev)
>  			   BRCMF_PCIE_MBDATA_TIMEOUT);
>  	if (!devinfo->mbdata_completed) {
>  		brcmf_err(bus, "Timeout on response for entering D3 substate\n");
> -		brcmf_bus_change_state(bus, BRCMF_BUS_UP);
> -		return -EIO;
> +
> +		if (devinfo->wowl_enabled) {
> +			brcmf_bus_change_state(bus, BRCMF_BUS_UP);
> +			return -EIO;
> +		}
> +
> +		brcmf_dbg(PCIE, "No D3 ACK, continuing to power the device off\n");
>  	}
>  
>  	devinfo->state = BRCMFMAC_PCIE_STATE_DOWN;

brcmf_err() is still emitted unconditionally on timeout, which means
affected devices will log an error message to dmesg on every suspend
even when WoWL is not armed and the missing ACK is expected/harmless.
Please move brcmf_err() inside the if (devinfo->wowl_enabled) check.

Also, please target wireless-next instead of net-next in the subject prefix
for the next version.

Regards,
Arend
