Received: from forward501a.mail.yandex.net (forward501a.mail.yandex.net [178.154.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B4C4EE84F;
	Fri,  4 Sep 2026 20:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788554074; cv=none; b=LcroRpcDC8S/nVx6zfAaPK6/Zfc2VN1Wkry3iU61TauZq6wjgmXHu/iga1MaPhP44jycdPElgTsAdD7+Y0vTwK5qsK40JlyEUtGZejiBTRTTqLaJNOdipg73YhhnWS/06NjWDLooqB6TeK2RydoviSDPJzvgh91xv6nwCGtQTOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788554074; c=relaxed/simple;
	bh=sR+0WNfssNxtim3D/P9pfgpNA/3kSbSSJjWH6uIexUs=;
	h=From:To:Cc:In-Reply-To:References:Subject:MIME-Version:Date:
	 Message-Id:Content-Type; b=hoJu96Xasr78EvHEgv6x3G+ik6gqS4rLX3LJpoymFHIvbXqDy8vXJ1Xb/xtx++6zM7QFW2fF5wMo4/8eR1yDFxmTRAXu7sJ4nvNlT0oCzLyOlGaVWYSSj271Hw9jpwq1a0FF3peFt9G+X+50D7Crb/fqh+/6Aj1kEdPMnC9jPig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me; spf=pass smtp.mailfrom=0upti.me; dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b=EZrj/uT/; arc=none smtp.client-ip=178.154.239.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=0upti.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0upti.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0upti.me header.i=@0upti.me header.b="EZrj/uT/"
Received: from mail-nwsmtp-mxback-production-main-78.vla.yp-c.yandex.net (mail-nwsmtp-mxback-production-main-78.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:271d:0:640:8641:0])
	by forward501a.mail.yandex.net (postfix) with ESMTPS id 047DE81EE9;
	Fri, 04 Sep 2026 23:26:11 +0300 (MSK)
Received: from mail.yandex.ru (2a02:6b8:c17:113:0:640:1378:0 [2a02:6b8:c17:113:0:640:1378:0])
	by mail-nwsmtp-mxback-production-main-78.vla.yp-c.yandex.net (mxback) with HTTPS id 3QQO6pGvl8c0-r6OUKqYf;
	Fri, 04 Sep 2026 23:26:10 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=0upti.me; s=mail;
	t=1788553570; bh=5tgwyDUIfpZVa1/3xlDMO4/b3eL1WpVfvtjoXWCT41s=;
	h=Message-Id:References:Date:Cc:Subject:In-Reply-To:To:From;
	b=EZrj/uT/5346TglerQz1Jsa8Xp/i2Os+iRs+UbhsUPxAq80pLPIx9IR0HtfbQd9hL
	 3kiXv+fsmWzpZCA+6T9G6ogcMznI25Vz+U8oqY8rmxmce4ko8RWv2vYa0IJ+YV4TCY
	 oI7P837Fwa3qetV2RgjesUi58Euiprex5xmpI0oE=
Authentication-Results: mail-nwsmtp-mxback-production-main-78.vla.yp-c.yandex.net; dkim=pass header.i=@0upti.me
Received: by yl7572a6ptr6ppfv.vla.yp-c.yandex.net (sendbernar) with HTTPS id 8423d0dad5cd213045de646daeeb8739;
	Fri, 04 Sep 2026 23:26:09 +0300
From: Ilya K <me@0upti.me>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org
In-Reply-To: <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com>
References: <1767631788532094@64c4e675-cd08-4a74-816f-886742f9bfcd> <529a79bc-dab7-aa41-00bd-c47ecbefaa00@candelatech.com> <471221788538289@323ca970-5bd2-4c6b-b52d-2b863a718615> <3acf531c-bcc7-412b-b3bb-665069260e46@candelatech.com>
Subject: Re:[bug] Triple whammy of mt7996e bugs on 7.2+
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 04 Sep 2026 23:26:09 +0300
Message-Id: <2028561788553569@f088f4ec-f441-47a1-b7e4-75a1052aa4df>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

> If you can get it to compile for your system by adding any needed patches on top, that is likely best
approach, and if that actually solves the problem, we'd be happy to consider adding any bpi4 patches
to our tree.

OK, so curiosity got the better of me, and I ended up with https://github.com/K900/linux/tree/bpi-r4-72-ct, which is kind of a horrible frankentree of my changes rebased on (your tree rebased on 7.2.3 minus bpi-r4 changes).

More specifically, here's the commits from your side that got dropped (courtesy of git range-diff):

 234:  846c09f2d40e <    -:  ------------ arm: dts: mt7623: swap mmc and put uart2 first
 235:  0c7af9986c06 <    -:  ------------ utils: firmware: add r3mini phy firmware
 236:  e977a0c57579 <    -:  ------------ net: sfp: Fixup for OEM SFP-2.5G-T(-R-RM) module
 238:  2510cb2b3cf1 <    -:  ------------ dt-bindings: phy: mediatek,xfi-tphy: add new bindings
 239:  3ae8358d3a61 <    -:  ------------ dt-bindings: mt76: support setting per-band MAC address
 240:  654e6eeb87d9 <    -:  ------------ hwrng: add driver for MediaTek TRNG SMC
 244:  c5a3d787c53f <    -:  ------------ dt-bindings: net: mediatek: remove wrongly added clocks and SerDes
 245:  8387ae94bbd7 <    -:  ------------ dt-bindings: net: mediatek,net: fix and complete mt7988-eth binding
 247:  5ddb838fc0b1 <    -:  ------------ Add some build scripts for combining Adtran SDG-8734v and SDG-8733v in a single fit-multi.itb file
 249:  e34f830292ad <    -:  ------------ net: ethernet: mtk_eth_soc: Enable legacy SRAM behavior for v3 devices
 250:  3a1f3125a1cd <    -:  ------------ arm64: dts: mt7622: add pstore reserved memory
 251:  8e9dd16ebaae <    -:  ------------ arm64: dts: mediatek: add symbols to dtb
 252:  8585e7d77269 <    -:  ------------ Example files to copy the boot and modules.
 253:  64a808bc3c0c <    -:  ------------ Scripts to make the .itb boot file. Place the bpi-r4.itb in the /boot directory of the BPI-R4. The .itb file contains the Linux kernel and Device tree files.
 254:  3f4e69730a4f <    -:  ------------ Some example .config files to use when building the kernel.
 255:  5bd6a36c14b1 <    -:  ------------ build: add the .its files that are used to make the .itb boot file for the bpi-r4
 256:  3a252445e488 <    -:  ------------ build: Add a README.BPI file with instructions on how to build the Linux kernel for the BPI-R4.
 257:  9538b07c0635 <    -:  ------------ CT: Add BPI4 kernel .config file.
 258:  c6a7e4315557 <    -:  ------------ BPI4: Update readme with a few pkgs needed for building on Fedora.
 259:  b13df740e737 <    -:  ------------ BPI4: Add packaging script for bpi4 kernel and modules.
 260:  4c9c807e3d41 <    -:  ------------ BPI: Package mtk and intel firmware in kernel pkg.
 264:  92df0e28ed0b <    -:  ------------ arch: arm64: boot: dts: mediatek: Add .dts files for adtran wifi router.
 265:  d6d28e6f0a3d <    -:  ------------ arch: arm64: boot: dts: mediatek: Add .dts file for Adtran SDG-8734v wifi router.
 266:  7956efe1b195 <    -:  ------------ Add "config-sdg-8734v" and "make-itb-adtran.sh"
 267:  7a0b10a1a8cb <    -:  ------------ Add "adtran.its"
 268:  0abd83c3500e <    -:  ------------ arch: arm64: boot: dts: mediatek: Add some more items to the .dts file for Adtran SDG-8734v wifi router.
 269:  35e22fd5a813 <    -:  ------------ arch: arm64: boot: dts: mediatek: Add some more items around the fxs fon ports to the .dts file for Adtran SDG-8734v wifi router.
 270:  9a308285aee4 <    -:  ------------ Adtran kernel pkg script.
 271:  11894e8c8b42 <    -:  ------------ pkg: Fix up adtran AP pkg script.
 272:  1c98cd76a009 <    -:  ------------ Add some build scripts for Adtran SDG-8734v and SDG-8733v
 273:  d1433e1eb59a <    -:  ------------ arch: arm64: boot: dts: mediatek: Add some ethernet port labels and add file for Adtran SDG-8733v wifi router.
 274:  eb8730a4900e <    -:  ------------ Build multi-target adtran itb, and check for build failures.
 275:  09624f3c3c3b <    -:  ------------ adtran: Add dts file for 8733 (no v) platform.
 276:  e8b33db1b68b <    -:  ------------ mediatek: dts: Hack in mt7988a from our 6.11 kernel.
 905:  95d57af187cf <    -:  ------------ cfg: Update bpi4 cfg for 6.10 kernel.
 906:  140e2059ed2b <    -:  ------------ bpi4 kernel config: Enable piles of USB device support.
 924:  6377fb541899 <    -:  ------------ bpi: Added environment setup instructions for Debian/Ubuntu users.
 935:  c7424426111a <    -:  ------------ Adtran sdg 8733 readme.
 942:  43e9a3e2f391 <    -:  ------------ adtran: Disable usb3 to work around RF interference.
 943:  068d8f8543e9 <    -:  ------------ adtran: force usb to 2.0 properly
 944:  493b2cab2a8b <    -:  ------------ adtran: Force usb2 for other variants
1013:  46f9ae768fc3 <    -:  ------------ net: ethernet: mtk_wed: add ppe drop
1014:  0b8db8e83a54 <    -:  ------------ mtk7996: Fix pppe drop build issue.
1077:  93d44e506bc3 <    -:  ------------ Revert "net: ethernet: mtk_eth_soc: Enable legacy SRAM behavior for v3 devices"
1078:  4a591d110b55 <    -:  ------------ Revert "net: ethernet: mtk_eth_soc: use generic allocator for SRAM"
1165:  1113c075457f <    -:  ------------ pkg:  Ensure adtran image shows current build date.

The adtran stuff didn't want to compile so I just deleted as much of it as I could find and crossed my fingers, that was probably unnecessary.

The dropping of mtk_eth_soc stuff _was_ necessary to get Ethernet to probe at all.

I also had to enable CONFIG_ATH10K_DEBUGFS, CONFIG_IWLWIFI_DEBUGFS and CONFIG_NL80211_TESTMODE in the kernel config
to get some bits to build (I'm building this with a distro defconfig that enables way too many things and I have yet to find time to trim it down;
maybe one day).

This abomination is now booted on my hardware and I'll get back to you if it explodes again, which I'd expect to happen at some point
during the weekend at worst (and if it survives longer, that's already an improvement).

Also, I _just_ realized that the logs from the original message did not make it to the list, so here they are in gist form instead: https://gist.github.com/K900/a0a27551d5955fefe2976bda3816f021
