Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E49B23AB88
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 00:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788654118; cv=none; b=GZu7g1ZKuAmnNM6eK7wqyPJPvHWvv8ueI4sYmlHP+0bntsjqozP0wnCzG8Hl+rbL40PQI3AMhQ2Y54lBtO/VI7w+cr9NdzRJPtq/n9cZp3SagqMfVaW3oUjU8GTcVlpZryFhWJq6V2efhsLTxqsUMdRyJlEQW0GYJ2WPM2c4J54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788654118; c=relaxed/simple;
	bh=bANCkv74bjVkNmw2i1bBp4PEjTFYNJHoUrMGPwTQrbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRlu+8VZSsQqrlbvh5DF6E+XUBlBcfEE1t4D6LPrptjTHN6MqkMgJiR8vj7QjJUBIsGJbm8Arf7DA6DlMmL291jNxNDiiMWGiR+NKzt7QRKML8mn817bRgMbI1PQBHXz57ohf6TrX2g0tGFyhe/NlFdl67gYctuK9t/4CIQ69yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rj+3jhmB; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rj+3jhmB"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5b60bcf9051so2060795e87.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 17:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788654115; x=1789258915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mbngxJwnoEkVcJ+SwI6uR0MJaawYw2SIyOrsYxc60no=;
        b=rj+3jhmBB9xlmH8ZQKUyNwBFumHOmxXmOQIUr8GW4uIRQxE/qvoWRJp7JBpJJnpk24
         dDUwSz3FSFp8k5snQEXt5k4xaIJAl2qkv1jPLFHo9qjgTICsf6fKks2ZxAADRdaRllTb
         HzHaF54GyLAftp8qQ3gjo03JWQS+kK2aEWI6QFmciypOsl0Baw8aEIeuaj65er4lzY43
         gC1GYpAhyR3r+XXufFEabTDw/uNbBXcIx7a5iqPSfTHAWaleTgGgdRdOMjz1v6CPYW73
         z3iteVVHcBxSMKGtgR2//FvV+NTF5EFVTilFxI+3QvXK8dgIFmOLa2VhFP8OfwcgfRFf
         Tr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788654115; x=1789258915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mbngxJwnoEkVcJ+SwI6uR0MJaawYw2SIyOrsYxc60no=;
        b=WSY+wIqM01k+dQj+gHe9O1k+RjKbterl4EbEQLuytMQmczKlRYInPfpVolxT3ueHUd
         Jb/ZmEku12pC0pGTYVlmOnBIjqJoT+I3/cLdFqNp00A2VnYeYHkb3oUrRHBxocfFHwNi
         ONUstxxIZS8yVTM/WZmXNVm5bI8iG8sPpgXzy5JqnORJRJoR2wMgphStDqdR0qYptol0
         kL5T2vKAPMJuhadSLuxUIOs76No9JDQ1X+xaZb224JuTewCdiME5k5QtaMMVH4gJdGyz
         J4JaSTdh246QVM1QqY0GpEQ3ifQJDbqDhLihw0yAq2SwW+hyTZSfzZ/QaIDb9k6RCZkN
         MKsw==
X-Gm-Message-State: AFuF++mh356JzGX6usIHHAbGPkU9n87DpdQazfjx2aNVo7GSuB9lzJPc
	TQdqIeAuC25Wa82FNY2t4JH0ElE88tB3HeZr8NAKWkcJSmMgeD6ibULH
X-Gm-Gg: AYBFou2b4NfNd269zAQEKOIrdjsPognWJcKS07cd9ORHtShsMR6bndIXsnfApU6uCT/
	WlU5SFo7Vzc9YFtkD+rCn7l8dPG52jhuP4rfJE4p6K5+0pdoXwR4xjn+FTzZBcdS44V7l9Wn9Wg
	vuh02epmk0fUhreeemsZcwqy9hAsb6In3P8lQkHsR3bC33vWa91EBcCxCCaakdMowYZsUvpGkcx
	3iWD5hNWscryJ9GM8/EWjPCq3yCx8XLScyXAi55+aRekDi3i8deQkrqfzV1aC5UNSXtXfYb3cOb
	ST+eGBjEFHqOAvOvPOXtDYrPbzC2rJCgE2/MEC6GAhJ2HKIHg55o6lR0MblSvyMf48TRh7XSGe1
	QUquSUk4aq4BPWbs1A54GWd7NKczoj78gTqdkT51TIhpUQukN8PjlcZTG39NYuTNA6hVzT/lDGQ
	YjyxI3Vuc/vn4j+LQ060BIr01khR+zd/btNJKc/kvCvFh39qVBHwvy91zOaeiPorACetGy4BucS
	XgFcA==
X-Received: by 2002:a05:6512:224c:b0:5b6:425:4bef with SMTP id 2adb3069b0e04-5b61706a350mr3872124e87.32.1788654114805;
        Sat, 05 Sep 2026 17:21:54 -0700 (PDT)
Received: from localhost.localdomain ([80.66.93.17])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b6166ecf3dsm1352411e87.15.2026.09.05.17.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 17:21:53 -0700 (PDT)
From: Maxim Skokov <skokovmaksimevg@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Maxim Skokov <skokovmaksimevg@gmail.com>
Subject: Re: [PATCH rtw-next v2 00/14] wifi: rtw89: update RTL8922D capabilities and settings, and enable P2P device
Date: Sun,  6 Sep 2026 03:20:50 +0300
Message-ID: <20260906002135.5118-1-skokovmaksimevg@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902052958.50371-1-pkshih@realtek.com>
References: <20260902052958.50371-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Sep 02, 2026 at 01:29:44PM +0800, Ping-Ke Shih wrote:
> This series updates RTL8922D capabilities and settings, and enables
> P2P device.

Tested the chip-independent parts of this series on RTL8851BE
(rtw89_8851be), a 1x1 Wi-Fi 6 part, since patches 3 and 11-14 touch
common code and thus change behaviour for every rtw89 device.  The
8922d-specific patches (1-2, 4-10) were not exercised, I don't have
that hardware.

Applied on top of rtw-next commit 81510c3d6f21 ("wifi: rtw88: debugfs:
don't vzalloc(0) when rsvd_page is read unconfigured").  All 14 patches
applied cleanly and the build is free of new warnings.

Patch 3 and 14, interface combinations as reported by 'iw phy':

  before:
    #{ managed } <= 1, #{ AP, P2P-client, P2P-GO } <= 1,
    total <= 2, #channels <= 1

  after:
    #{ managed } <= 2, #{ AP, P2P-client, P2P-GO } <= 1,
    #{ P2P-device } <= 1, total <= 3, #channels <= 1

Patch 3, two station interfaces in SCC.  Second station vif added with
'iw interface add', given its own MAC and associated to the same BSSID
as the first one, so both links are on the same channel by construction
(5180 MHz).  Both associate, and both carry traffic at the same time:

  30 s of concurrent ping to the gateway, one flow per interface

    wlp2s0  90 packets transmitted, 90 received, 0% packet loss
    wlan1   90 packets transmitted, 90 received, 0% packet loss

  station dump after the run

    wlp2s0  rx 1225221  tx 27526  tx failed 1  beacon loss 15
    wlan1   rx  128239  tx 16140  tx failed 2  beacon loss  0

The first interface is unaffected when the second one is torn down.

Patch 14, P2P device.  wpa_supplicant creates it on its own during boot
now that the driver advertises the iftype, and NetworkManager lists it
as a wifi-p2p device.  The driver runs with three vifs at once
(two managed plus the P2P device) without complaints.

No WARNs, no backtraces and no rtw89 error messages in dmesg during any
of this.  Association, DHCP and switching between 2.4 GHz and 5 GHz all
keep working.

Patches 11-13 were only exercised indirectly, through the absence of
regressions in association and channel switching.  Patch 12 is a no-op
here, RTL8851BE has no 6 GHz band.

Tested-by: Maxim Skokov <skokovmaksimevg@gmail.com> # RTL8851BE, patches 3 and 11-14

One observation that may be worth a note in the cover letter.  Since
patch 14 declares #{ P2P-device } <= 1, a second wpa_supplicant instance
on the same phy cannot start: it tries to create its own P2P device,
hits the limit, and then gives up on the whole interface rather than
falling back:

  nl80211: Could not set interface 'p2p-dev-wlan1' UP
  P2P: Failed to enable P2P Device interface
  p2p-dev-wlan1: Failed to initialize driver interface

So the two-station setup that patch 3 enables needs p2p_disabled=1 in
the second supplicant config.  The driver behaves correctly here, it
just means the new capability is not reachable with a default
wpa_supplicant, which someone trying this out is likely to hit.

Thanks,
Maxim
