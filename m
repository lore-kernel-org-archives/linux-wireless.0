Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF49247F2F3
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 11:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791200719; cv=none; b=lg8JkhkYpdyvpw408asjevMwBoD7hZ5hqlW8Mry6h3U8tjLc/HLlUjaZxKLWsqGUoWB/euUYhdjvCPPv+UbuhcHvYvj20UFEgGtrrcM7xf/L75iagEW2Ivhwd4lT5yhUfqahbtp1UTgROlvEbqltuiaXXyq8DexkubEsD8RMJsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791200719; c=relaxed/simple;
	bh=GUGLypkCq7YyINNli0BixsHVa6dNTI10V7iuxjWzub8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=EqPRuAGhole+kM78mKntFA1tp+8cvc0MbB+Wwmot+8e1uQG0zVSoLjIwX+eFUSmi0K8TCYC+rt+120pDdK5hA8djCFY0Vc0lKfkGN59fif7zjuCtmsB5zaC15LLiKosSiH/rIeblAMn7YS0+2+p5HA9jU6cePAzuzYlr8WvKujk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=qija9ruW; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="qija9ruW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:Cc:To:Subject:From:
	MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NA4uSncxZeQLcVmjMRkDK5D2AQS6SmV8PW8GDvVbGrs=; b=qija9ruWA0+mOVYtkYzHz501VU
	IcRXYaH+izs/d3rYLhSa3okpGrRv37l1l8p+sCXB30J6uP1VgNBMBidykm642+LFM/HoNQZhO4X/4
	NrU/IWqAUa2bkRkdFa90Vz6tbELALdG2D/1QHcF2Sa6VccAF0+/ZXfQ0Sm6jfvHjGN5w=;
Received: from p54a434bb.dip0.t-ipconnect.de ([84.164.52.187] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xDh81-00GH3w-2o;
	Mon, 05 Oct 2026 13:45:09 +0200
Message-ID: <3c23dd44-ccea-41f7-90e9-93da8889a13e@nbd.name>
Date: Mon, 5 Oct 2026 13:45:09 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Felix Fietkau <nbd@nbd.name>
Subject: pull request: mt76-fixes 2026-10-05
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

Here's my mt76-fixes pull request for 7.3

- Felix

The following changes since commit d24e8ac715de2e16a53c144005b1863660a5fbea:

   Merge tag 'net-7.3-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-10-01 06:41:59 -0700)

are available in the Git repository at:

   https://github.com/nbd168/wireless tags/mt76-fixes-2026-10-05

for you to fetch changes up to 26aaf96f4a40af38318447c9592b983841f85628:

   wifi: mt76: move the channel survey when the channel changes (2026-10-05 10:48:07 +0200)

----------------------------------------------------------------
mt76 fixes for 7.3

- fix mt792x locking issues
- fix race conditions
- mt7996 offchannel fixes
- other minor fixes

----------------------------------------------------------------
Aaron Ma (1):
       wifi: mt76: mt7925: restore the legacy BSS after MLO teardown

Charlie-cy Wu (1):
       wifi: mt76: connac2: fill TXD spe_idx for connac2 fixed-rate frames

Cristian Papa (1):
       wifi: mt76: mt7603: initialize global station WCID

Devin Wittmayer (12):
       wifi: mt76: mt7921: fix lock inversion between dev->mutex and iflist_mtx
       wifi: mt76: mt7925: fix lock inversion between dev->mutex and iflist_mtx
       wifi: mt76: mt7921: check drv_pmctrl return in the PCIe reset path
       wifi: mt76: mt7925: check drv_pmctrl return in the PCIe reset path
       wifi: mt76: mt7921: fix the lock inversion in suspend and resume
       wifi: mt76: mt7925: fix the lock inversion in suspend and resume
       wifi: mt76: mt7921: honour FIF_FCSFAIL instead of hardcoding drop_err
       wifi: mt76: mt7925: don't put the band auto marker in TGID
       wifi: mt76: mt792x: pick the SAR table layout from the table itself
       wifi: mt76: take rcu_read_lock in the USB/SDIO tx completion path
       wifi: mt76: mt7925: cancel mlo_pm_work on the USB stop path
       wifi: mt76: move the channel survey when the channel changes

Eason Lai (2):
       wifi: mt76: mt792x: fix UAF in SDIO TX path when out of memory
       wifi: mt76: fix memory leak in USB TX path

Felix Fietkau (7):
       wifi: mt76: mt7996: program a link again if the driver holds it
       wifi: mt76: check the owner of a remain-on-channel request
       wifi: mt76: mt7996: take over connection monitoring
       wifi: mt76: clear offchannel state if a scan has no channel to restore
       wifi: mt76: account non-AQL frames per peer rather than per link
       wifi: mt76: mt7925: restore the reset state when fw_pmctrl fails
       wifi: mt76: use ALTX queue for packets to disassociated stations

Junjie Cao (1):
       wifi: mt76: mt792x: treat 0xff ACPI SAR entries as no limit

Mark Anthony Agarro (3):
       wifi: mt76: mt76x02: validate TX-status rate index before mac80211 handoff
       wifi: mt76: mt7925: honour mac80211's FIF_FCSFAIL instead of hardcoding drop_err
       wifi: mt76: mt7615: do not tear down BSS/STA state for monitor vifs

Myeonghun Pak (1):
       wifi: mt76: mt7615: restore DBDC state after ext PHY failure

Nicolas Cavallari (1):
       wifi: mt76: mt7915: disable rx napi when removing device

Ryan Leung (3):
       wifi: mt76: mt7915: publish wcid before MCU add commands
       wifi: mt76: fix unlocked wcid check in mt76_tx_status_skb_add()
       wifi: mt76: fix wcid teardown ordering in mt76_reset_device()

Tao Gong (1):
       wifi: mt76: mt7996: fix struct mt7996_mcu_wed_rro_ba_delete_event layout

Zhao Li (1):
       wifi: mt76: mt7996: unlink TWT flow if the MCU rejects the agreement

  drivers/net/wireless/mediatek/mt76/channel.c         |   4 +++-
  drivers/net/wireless/mediatek/mt76/mac80211.c        |  18 ++++++++++++++--
  drivers/net/wireless/mediatek/mt76/mt76.h            |   9 ++++++++
  drivers/net/wireless/mediatek/mt76/mt7603/init.c     |   1 +
  drivers/net/wireless/mediatek/mt76/mt7615/init.c     |  17 +++++++++++----
  drivers/net/wireless/mediatek/mt76/mt7615/main.c     |   6 ++++--
  drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c |  20 ++++++++++++------
  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c     |  19 +++++++++++------
  drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c |   2 +-
  drivers/net/wireless/mediatek/mt76/mt7915/init.c     |   6 ++++++
  drivers/net/wireless/mediatek/mt76/mt7915/main.c     |   4 +++-
  drivers/net/wireless/mediatek/mt76/mt7921/mac.c      |   3 +++
  drivers/net/wireless/mediatek/mt76/mt7921/main.c     |  31 +++++++++++++--------------
  drivers/net/wireless/mediatek/mt76/mt7921/mcu.c      |   2 +-
  drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h   |   5 +++++
  drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c  |   4 +++-
  drivers/net/wireless/mediatek/mt76/mt7925/mac.c      |   6 +++++-
  drivers/net/wireless/mediatek/mt76/mt7925/main.c     |  43 ++++++++++++++++++++++++-------------
  drivers/net/wireless/mediatek/mt76/mt7925/mcu.c      |   2 +-
  drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h   |   5 +++++
  drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c  |   6 ++++--
  drivers/net/wireless/mediatek/mt76/mt7925/usb.c      |  11 +++++++++-
  drivers/net/wireless/mediatek/mt76/mt792x.h          |   1 +
  drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c | 134 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------
  drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h |   2 ++
  drivers/net/wireless/mediatek/mt76/mt792x_core.c     |   1 +
  drivers/net/wireless/mediatek/mt76/mt7996/init.c     |   1 +
  drivers/net/wireless/mediatek/mt76/mt7996/mac.c      |   4 +++-
  drivers/net/wireless/mediatek/mt76/mt7996/main.c     |  10 ++++++++-
  drivers/net/wireless/mediatek/mt76/mt7996/mcu.h      |   3 +++
  drivers/net/wireless/mediatek/mt76/scan.c            |   7 ++++++
  drivers/net/wireless/mediatek/mt76/tx.c              |  23 ++++++++++++++------
  drivers/net/wireless/mediatek/mt76/usb.c             |  31 ++++++++++++++++++++++-----
  33 files changed, 320 insertions(+), 121 deletions(-)
