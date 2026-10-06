Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03AE32A3C9
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 09:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791280653; cv=none; b=JtDB1g7jXmFnmcF3KRgaW7AKuPMbv0lHTFxzal5OfTASUYaX0a/NPOQ3bhVWbWg2LHU60Qh1y96IsEQdhViNpOgXQl8SV2zDZa1on/JEm0qupkrlYP92WzT0INtFKPqc3xaFktMzEbHgX1rqzLUmWh5i8VxXzgpQ2p+3oU9A0e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791280653; c=relaxed/simple;
	bh=yJFht4V2iJltpVGCKvx6nYIJCuYiPSgmeMC13XysX8k=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=gOTU14LvaCP4fr8fWOmyKNywZuN5X1UWNklI2ManhjTc+lBwUGjkOJjc8KC1eEsInD3wkoaw7T+dW0UrTaKSCy2TwVAAP637vPwg9xD0bz2TxT3WM1zlb4vltI6cpyldwO0GCZDKFE9A2PSFO/PNzrcnczsuLg2DlM/3h3wKsro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=i1xWxA2t; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="i1xWxA2t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:Content-Type:Cc:To:Subject:From:
	MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Zo6fdLQ/fx63w8CriAI1TihPzK+FMMG0FW/YWlDOsmw=; b=i1xWxA2t5dYQSovTMp4MFgDpVI
	J7LZMvYzBVNaVwYoMrKKTur5f+FCDvfnkZ5rrKEuIA99DpDeWCX+dYKIY7vPCyeWyzaN8/fESyk2L
	HtPOz3veGi/hi6cmp56nOZlTI99csgqN7blLdb95UsfJTozfGCmgP/DDk7jsvdTnkIIU=;
Received: from p54a434bb.dip0.t-ipconnect.de ([84.164.52.187] helo=nf.local)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xE1vM-00GrQn-1c;
	Tue, 06 Oct 2026 11:57:28 +0200
Message-ID: <897a86ce-a8ba-436b-9564-085932423487@nbd.name>
Date: Tue, 6 Oct 2026 11:57:26 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Felix Fietkau <nbd@nbd.name>
Subject: pull request: mt76-fixes 2026-10-05 v2
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

Here's my updated mt76-fixes pull request for 7.3
It contains fewer patches now.

- Felix

The following changes since commit d24e8ac715de2e16a53c144005b1863660a5fbea:

   Merge tag 'net-7.3-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-10-01 06:41:59 -0700)

are available in the Git repository at:

   https://github.com/nbd168/wireless tags/mt76-fixes-2026-10-05

for you to fetch changes up to 52f6a065e0810c739a5dabd33a58047f08100f50:

   wifi: mt76: mt7996: fix uninitialized buf read in mt7996_variant_fem_init() (2026-10-06 11:50:52 +0200)

----------------------------------------------------------------
mt76 fixes for 7.3

- mt7925 ACPI SAR fixes
- MLO fixes
- sta handling fixes
- mt7915 napi disable fix

----------------------------------------------------------------
Aaron Ma (1):
       wifi: mt76: mt7925: restore the legacy BSS after MLO teardown

Cristian Papa (1):
       wifi: mt76: mt7603: initialize global station WCID

Devin Wittmayer (2):
       wifi: mt76: mt7925: don't put the band auto marker in TGID
       wifi: mt76: mt792x: pick the SAR table layout from the table itself

Felix Fietkau (4):
       wifi: mt76: mt7996: program a link again if the driver holds it
       wifi: mt76: mt7996: take over connection monitoring
       wifi: mt76: account non-AQL frames per peer rather than per link
       wifi: mt76: use ALTX queue for packets to disassociated stations

Junjie Cao (1):
       wifi: mt76: mt792x: treat 0xff ACPI SAR entries as no limit

Lu Huang (1):
       wifi: mt76: mt7996: fix uninitialized buf read in mt7996_variant_fem_init()

Nicolas Cavallari (1):
       wifi: mt76: mt7915: disable rx napi when removing device

Tao Gong (1):
       wifi: mt76: mt7996: fix struct mt7996_mcu_wed_rro_ba_delete_event layout

  drivers/net/wireless/mediatek/mt76/mt76.h            |   7 ++++++
  drivers/net/wireless/mediatek/mt76/mt7603/init.c     |   1 +
  drivers/net/wireless/mediatek/mt76/mt7915/init.c     |   6 ++++++
  drivers/net/wireless/mediatek/mt76/mt7915/main.c     |   2 ++
  drivers/net/wireless/mediatek/mt76/mt7925/mac.c      |   3 ++-
  drivers/net/wireless/mediatek/mt76/mt7925/main.c     |  12 +++++++++++
  drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c | 134 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------
  drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.h |   2 ++
  drivers/net/wireless/mediatek/mt76/mt7996/init.c     |   3 ++-
  drivers/net/wireless/mediatek/mt76/mt7996/main.c     |  10 ++++++++-
  drivers/net/wireless/mediatek/mt76/mt7996/mcu.h      |   3 +++
  drivers/net/wireless/mediatek/mt76/tx.c              |  14 ++++++++----
  12 files changed, 144 insertions(+), 53 deletions(-)
