Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=93.90.53.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793480909;
	b=X4+zDgf+I4tf0r0vA0DGNmsHMYQnrtIUMrb+1DwJR3sqEI+4aMu38bE1Iv8hEK0Cey+x
	 YinBp5EJBger07oYHFdRNLj2wloSt9fu9IeP4YdLL8EZyn6NinUzReO85RSn9lg2f00wO
	 L/Conp+mFGbXGr56r015YVjgFhEEzYWP8gpptuvu4xPpnVKAOqHJFavlZ8yvGB25v5I2o
	 wxvaFpROSGBfEdzy7QPRTc48KhAw3N3ci3eUcEoPDjn9yPSy6nE3TivP0XRRvPpQ1/vth
	 jtFkGzf9ZdqKE70PcxQEBv2js2AMGqr2yS7ORpI8eLcwUj0kClgdon8km+IsPOrna8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793480909;
	h=DMARC-Filter:DKIM-Filter:DKIM-Signature:Received:DKIM-Filter:
	 DKIM-Signature:Received:X-Spam-Checker-Version:X-Spam-Level:
	 X-Spam-Status:X-Spam-Report:DKIM-Filter:DKIM-Signature:Received:
	 Received:Message-ID:Date:Subject:From:To:Cc:User-Agent:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Virus-Scanned:
	 X-Virus-Status;
	bh=T6P3a6ZwAQif6vDEcf5hO/dFGNibgXA0GRLBb01OIW8=;
	b=VMMoVVSpH1z9Jh9SIcTxsd7wI+6E/AmOQ2IjzI6gZaNawGEeBspFpEHr/9RPu3v1sv2Z
	 nLGz4971Oxt9L9J3eCcLApQatn2C4iTs9RmQ/Ma5+jhaxdwYYTQRIv/MBvoW4pU0VqZSa
	 khR/WzErWoPso4YQ0yr+lkPXnJFPzJUjVPvuOWi7S4gRm7pg17opahn1eFtOutgvt1zh0
	 zMx33LGuPL2ZAapnMerGt6Zu6NFc4KHr/tuwzKpyqenn6SuTo0/O+6AqOvwNT0aGeNQpj
	 5lyFWlfwzHm3evS6pZAqt7qCn+xzq9JC/Hn2/QjVD/YMR25wBbLoUkxGG56Ps/4HLXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=takio.fi;
	spf=pass smtp.mailfrom=takio.fi;
	dkim=pass header.d=takio.fi header.i=@takio.fi header.a=rsa-sha256 header.s=201711 header.b=J+Jflpsa;
	dkim=pass header.d=takio.fi header.i=@takio.fi header.a=rsa-sha256 header.s=201711 header.b=J+Jflpsa;
	dkim=pass header.d=takio.fi header.i=@takio.fi header.a=rsa-sha256 header.s=201711 header.b=Da7CJl2E;
	arc=none smtp.remote-ip=93.90.53.5
Received: from takio.fi (takio.fi [93.90.53.5])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF543606A31C
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 21:08:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF543606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=takio.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=takio.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=takio.fi header.i=@takio.fi header.a=rsa-sha256 header.s=201711 header.b=J+Jflpsa;
	dkim=pass (2048-bit key) header.d=takio.fi header.i=@takio.fi header.a=rsa-sha256 header.s=201711 header.b=J+Jflpsa;
	dkim=pass (2048-bit key) header.d=takio.fi header.i=@takio.fi header.a=rsa-sha256 header.s=201711 header.b=Da7CJl2E
DKIM-Filter: OpenDKIM Filter v2.11.0 takio.fi 4jH9YK3HYnz2wRY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=takio.fi; s=201711;
	t=1793480901; bh=XYl4sKkizH+z2SuIA4IWSop0wkFoGNRqrW7N5iUdk6A=;
	h=Date:Subject:From:To:Cc:From;
	b=J+Jflpsas0vApQtlO4cRjzBLizgzH4zatpBCEYytXgZJGObbWs/s4mBni5iRhyOZn
	 ZkSZgcd/ElOqlg3oXaTsmneq8oo08Hy9ygxsespYHun2qFJf/H1T+FBfkBP6FEPsYf
	 KRSMwhY32swwqYPKxI7diuOE39Ug3HrIW/fiDeJWPmZx2nuCzw+57OT2C03Le3RPF1
	 MWPcjA7UfGhQOqYSG57ncjeG0ClIw+NdnxlBo7d3bH+psgdUzD45tyhkUxKNjjJpfn
	 xAx0o2quvaeYtEcMkbHD2yaAry7WMF8Y67yxZhn5xJJq2bUT68fVOwBXLnSm/NVMw0
	 BafSZU//ISTZw==
Received: from takio.fi (localhost [127.0.0.1])
	by takio.fi (Postfix) with ESMTP id 4jH9YK3HYnz2wRY
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 23:08:21 +0200 (EET)
DKIM-Filter: OpenDKIM Filter v2.11.0 takio.fi 4jH9YK2lfJz2wRy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=takio.fi; s=201711;
	t=1793480901; bh=XYl4sKkizH+z2SuIA4IWSop0wkFoGNRqrW7N5iUdk6A=;
	h=Date:Subject:From:To:Cc:From;
	b=J+Jflpsas0vApQtlO4cRjzBLizgzH4zatpBCEYytXgZJGObbWs/s4mBni5iRhyOZn
	 ZkSZgcd/ElOqlg3oXaTsmneq8oo08Hy9ygxsespYHun2qFJf/H1T+FBfkBP6FEPsYf
	 KRSMwhY32swwqYPKxI7diuOE39Ug3HrIW/fiDeJWPmZx2nuCzw+57OT2C03Le3RPF1
	 MWPcjA7UfGhQOqYSG57ncjeG0ClIw+NdnxlBo7d3bH+psgdUzD45tyhkUxKNjjJpfn
	 xAx0o2quvaeYtEcMkbHD2yaAry7WMF8Y67yxZhn5xJJq2bUT68fVOwBXLnSm/NVMw0
	 BafSZU//ISTZw==
Received: by takio.fi (Postfix, from userid 109)
	id 4jH9YK2lfJz2wRy; Sat, 31 Oct 2026 23:08:21 +0200 (EET)
X-Spam-Level: 
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 URIBL_DBL_BLOCKED_OPENDNS ADMINISTRATOR NOTICE: The query to
	*      dbl.spamhaus.org was blocked due to usage of an open resolver. See
	*      https://www.spamhaus.org/returnc/pub/
	*      [URI: takio.fi]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URI: takio.fi]
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
DKIM-Filter: OpenDKIM Filter v2.11.0 takio.fi 4jH9Y865hBz2wNj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=takio.fi; s=201711;
	t=1793480892; bh=XYl4sKkizH+z2SuIA4IWSop0wkFoGNRqrW7N5iUdk6A=;
	h=Date:Subject:From:To:Cc:From;
	b=Da7CJl2EkW0iz1qCdPXzKvzzUgTr5rq8HhA5vRoQG7aKdMNbt8RamIvDysj9INeA2
	 sbtFnGDRGZd34e7oKHaAyr/+MkM8o8SISrylUlQaia1ZepG7lNKE5jlki5ZP489sAR
	 PJQNXO1WlMiTkGd4ga/FT1zwtxElXSipM/2evMjExM6DwmxDONV9MtLFtIH4f9v109
	 AZFf+yueQhRJy8ao2suQS7W6M5DEKzJ+UBxBtGvn3MOPFGid3010NTCZaXyy230oVy
	 QpCjblsPo3gROiR2QaZ3QcoBmn4BtvkEGlKCCJodJeQyFKUINHtsWo6DxUq7oWeYgb
	 YiBz8o8IreSng==
Received: from webmail.takio.fi (takio.fi [93.90.53.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by takio.fi (Postfix) with ESMTPSA id 4jH9Y865hBz2wNj;
	Sat, 31 Oct 2026 23:08:12 +0200 (EET)
Received: from 93.90.53.6
        by webmail.takio.fi with HTTP;
        Sat, 31 Oct 2026 23:08:12 +0200
Message-ID: <2e7baa7fbf1f2e5a282a2330d04ad41a.squirrel@webmail.takio.fi>
Date: Sat, 31 Oct 2026 23:08:12 +0200
Subject: [RFC] b43: working AC-PHY support for BCM4352/BCM4360
From: "Ville Takio" <ville+git@takio.fi>
To: linux-wireless@vger.kernel.org,
 b43-dev@lists.infradead.org
Cc: =?UTF-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22?= <zajec5@gmail.com>,
 "Michael Buesch" <m@bues.ch>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Alessio Ferri" <alessio.ferri.3012@gmail.com>,
 "Rosen Penev" <rosenp@gmail.com>
User-Agent: SquirrelMail/1.5.2 [SVN]
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 1.4.6 at takio.fi
X-Virus-Status: Clean

Hi,

b43 has carried an AC-PHY stub (B43_PHY_AC, "BROKEN") since 2015. Alessio
Ferri has since written a working AC-PHY and radio 2069 implementation
[1], and I have spent the last months bringing it up on a Northstar router
and fixing what was missing. It now runs as an access point on both bands
at throughput comparable to Broadcom's wl driver on the same board. Before
preparing a series for wireless-next I would like to ask how, or whether,
you would like to receive it.

Hardware tested
  ASUS RT-AC66U B1 (same board as RT-AC68U): BCM4708 SoC, two BCM4360
  (core rev 42, AC-PHY rev 1, radio 2069 rev 4, femctrl 3) on PCIe/bcma.
  Kernel 6.18 with backports 7.2, as OpenWrt [2].

Firmware
  784.2 from Broadcom's 6.30.163.46 driver (ucode42 and the ac1 initvals),
  extracted with the existing b43-fwcutter.

Results (1x1 client at short range, iperf3 down/up, Mbit/s)
  2.4 GHz HT20      40-47 / 51-55
  2.4 GHz HT40      59 / 94
  5 GHz VHT80       134-137 / 139-163
  wl 7.14 measured on the same router: 119/164 on 5 GHz and 49/50 on 2.4 GHz.

What works
  - PHY/radio init, channel switching across 20/40/80 MHz, both bands
  - TX IQ/LO and RX IQ calibration, temperature-driven recalibration
  - TX power from the SROM (rev 11), including the 2.4 GHz 40 MHz
    power-detector offset
  - FEM control for femctrl 3; AGC init/clip gains computed from the SROM
    RX gain context per sub-band (the AGC registers now match wl on all
    three cores of both bands except one 2-bit field at 5 GHz 20 MHz)
  - AP mode via mac80211/hostapd; DFS behind a separate Kconfig option
    that depends on CFG80211_CERTIFICATION_ONUS

What does not / is untested
  - only femctrl 3 has a FEM table; other boards are refused on purpose
    rather than given a table that might damage the front end
  - only the 4352/4360 family; no 4350/43602
  - STA mode is untested; no TX beamforming
  - many values are tables and register writes specific to these chips;
    they are tied to chip and PHY revision where I could verify it

Size and layout
  About 18k added lines. Most of it is in new files under b43/ (phy_ac.c,
  radio_2069.c, tables_phy_ac.c, ppr_ac.c, helpers_phy_ac.c); the rest
  touches main.c, dma.c, xmit.c and phy_common.c. bcma and ssb need about
  700 lines for the BCM4352/BCM4360 family and SROM rev 11 fields
  (PMU/PLL setup, SROM extraction, NVRAM fallbacks on bcm47xx).

How the values were obtained
  Register and table values were captured from the running hardware
  under Broadcom's wl driver (stock ASUS firmware and DD-WRT). The
  sequencing and the formulas (gain split, calibration ladders, power
  offsets) were derived from analysing the wl 7.14 binary. This is not
  the two-team clean-room process the original b43 specifications used.
  If that rules the code out for mainline, I would rather know now.

Questions
  1. Is a new PHY in b43 (Orphan) still welcome, and through which tree:
     wireless-next directly, or via bcma first for the bus parts?
  2. Preferred split? I would propose bcma/ssb first, then the b43 core
     changes, then the AC-PHY in a few large patches (tables, radio,
     PHY, calibration), then the fixes on top.
  3. Is anyone willing to review or co-maintain it? I can test on the
     BCM4360 boards I have and keep it working.

Authorship: the base AC-PHY implementation is Alessio Ferri's; I have
asked him for his Signed-off-by and whether he wants to submit his part
himself [3]. Rosen Penev has N-PHY and HT-PHY patches and suggested
carrying all of this out of tree in OpenWrt for now [4], which is the
plan until upstream direction is clear.

The current patches (against backports 7.2) are in [2].

[1] https://github.com/aleferri/b43-ac-wip
[2] https://github.com/openwrt/openwrt/pull/26349
[3] https://github.com/aleferri/b43-ac-wip/issues/10
[4] https://github.com/openwrt/openwrt/pull/26349#issuecomment-6549024998

Thanks,
Ville Takio

