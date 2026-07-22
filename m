Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B113C10AB
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 06:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784702230; cv=none; b=hm50CjJc5MKLYAXpSpudQ+SeV2YT1h+DhILjhGCYLXh49WqSucFk12H0uOhS5l9xn6rT8QN5DTOESzJe+wkwU6LsHNxL4Of4ccCV9U6g9IB2j+Hxv+subn/fq+4mFjYEKyGnEfiUuo5Abe1wO9VJAFm+XIeUNcPA13AL4CJkVc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784702230; c=relaxed/simple;
	bh=Hqt2c6vCC8J80fptgf8ifLlPQCuPMFsCa56ntsSAIWw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=aom8lV3b8jmMATrqnOG+WKXItoQyIg8PHym91RPFmny1INfAOOUl0xo8zQf+8NHLW+zwiCLHmM3EXY6903Adp1/wYbDy+1hU9KIAE/ZYm5ydYk0NvKfqvqTo3Z+nBCrYiYg4bIkTjtH3GidqZ5sWDmqYBgkPdxgEdIfrNZ8bLVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=hEu+6hc7; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="hEu+6hc7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:Cc:To:Subject:From:
	MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xObv0IeEv5bIjrcCZJOWk+O7jFM9/+bORNsCHem/yuA=; b=hEu+6hc7UUKhzf95SjSFkeCu+C
	DyjDZVaXCBglYGBQSdqe8eCQNwcfm9uC14nJcv78DgPkgZkBDNew0na/Up7cgEbQoFaeTN2AaFgrd
	vEId6wLwQR6rU13a0BuXhBPob2nKRis/2mUBG0i0FI4qB7IP0/dhfb0XTAKBTkJrkce8=;
Received: from p5b015c4b.dip0.t-ipconnect.de ([91.1.92.75] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmQZl-00589h-28;
	Wed, 22 Jul 2026 08:37:05 +0200
Message-ID: <f40382cf-9f75-4793-88b9-c50be5dad191@nbd.name>
Date: Wed, 22 Jul 2026 08:37:04 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Felix Fietkau <nbd@nbd.name>
Subject: pull request: mt76-fixes 2026-07-22
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Language: en-US
Autocrypt: addr=nbd@nbd.name; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCeMncXpbbWNT2AtoAYICrKyX5R3iMAoMhw
 cL98efvrjdstUfTCP2pfetyN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Here's my mt76-fixes pull request for 7.2

- Felix

The following changes since commit 29ab31f3f27157648f2f7e6d5e1fd9792fdf0614:

   wifi: brcmfmac: set F2 blocksize to 256 for BCM43752 (2026-07-21 18:55:36 +0200)

are available in the Git repository at:

   https://github.com/nbd168/wireless tags/mt76-fixes-2026-07-22

for you to fetch changes up to 2fffc472bec490c8357defcee9c075ca74467352:

   wifi: mt76: mt7996: fix possible NULL-pointer deref in mt7996_mcu_sta_bfer_eht() (2026-07-22 06:20:08 +0000)

----------------------------------------------------------------
mt76 fixes for 7.2

- fix warnings on removing device
- null pointer deref fixes
- fix for data structure confusion on USB/SDIO devices

----------------------------------------------------------------
Arnd Bergmann (1):
       wifi: mt76: fix airoha_npu dependency tracking

Devin Wittmayer (4):
       wifi: mt76: mt7921: drop TXRX_NOTIFY on non-mmio buses
       wifi: mt76: mt7925: drop TXRX_NOTIFY on non-mmio buses
       wifi: mt76: mt7615: drop TXRX_NOTIFY on non-mmio buses
       wifi: mt76: restrict NPU/PPE active checks to MMIO devices

Guangshuo Li (1):
       wifi: mt76: mt7925: guard link STA in decap offload

Lorenzo Bianconi (4):
       wifi: mt76: connac: fix possible NULL-pointer deref in mt76_connac_mcu_uni_bss_he_tlv()
       wifi: mt76: mt7925: fix possible NULL-pointer deref in mt7925_mcu_bss_he_tlv()
       wifi: mt76: mt7996: check pointer returned by mt76_connac_get_he_phy_cap()
       wifi: mt76: mt7996: fix possible NULL-pointer deref in mt7996_mcu_sta_bfer_eht()

Nicolas Cavallari (1):
       wifi: mt76: Disable napi when removing device

Rosen Penev (1):
       wifi: mt76: fix MAC address for non OF pcie cards

Ruoyu Wang (1):
       wifi: mt76: mt7915: guard HE capability lookups

Sean Wang (1):
       wifi: mt76: mt7925: fix crash in reset link replay

  drivers/net/wireless/mediatek/mt76/Kconfig           |  4 ++--
  drivers/net/wireless/mediatek/mt76/Makefile          |  6 +++++-
  drivers/net/wireless/mediatek/mt76/dma.c             |  5 ++++-
  drivers/net/wireless/mediatek/mt76/eeprom.c          |  2 +-
  drivers/net/wireless/mediatek/mt76/mt76.h            |  6 +++---
  drivers/net/wireless/mediatek/mt76/mt7615/mac.c      |  6 ++++++
  drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c |  2 ++
  drivers/net/wireless/mediatek/mt76/mt7915/mcu.c      | 18 +++++++++++++-----
  drivers/net/wireless/mediatek/mt76/mt7921/mac.c      | 10 +++++++---
  drivers/net/wireless/mediatek/mt76/mt7925/mac.c      | 13 ++++++++++---
  drivers/net/wireless/mediatek/mt76/mt7925/main.c     |  3 +++
  drivers/net/wireless/mediatek/mt76/mt7925/mcu.c      |  2 ++
  drivers/net/wireless/mediatek/mt76/mt7996/Kconfig    |  2 +-
  drivers/net/wireless/mediatek/mt76/mt7996/mcu.c      | 19 +++++++++++++------
  14 files changed, 72 insertions(+), 26 deletions(-)
