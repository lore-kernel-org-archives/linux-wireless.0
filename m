Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AA9435536
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 07:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784620599; cv=none; b=ILIMiwqpYHMicnuRucJ+rzi5KSLX2IeVRAtudow4JJy5jWOEpHX1y1cTOx5PtlYj5aGrVs/NeF3X6Q/XHdW8FcAk5OwMgh3gx2ulXMcTT674rJacolCUXauKUsJz+/Wzoo6Zhsmf5MKC1OPQJZzW3+GS9dDyQbY/2hcr1TN1YdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784620599; c=relaxed/simple;
	bh=XFvWmf7qSR/0Q1aXbkilJmiLtGmljOPOlZK3RiAh5mg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=rdC8BBW7noWJFEN8EbwcT55MOJT2FhP9ZA8M5iHAoKYj93jwpumaLi1TgdtQLa9LJoVxuG3UIbLUljDVpQmU/2slybkz6GUAyX9ZA2Lsz8Qm60yJNd1Noyv0Y69ziAoP0qFda3hvF6IHbwrvGv7VDHYQ31HK13asJAMytUnwwMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hZFI88qA; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hZFI88qA"
Date: Tue, 21 Jul 2026 09:56:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784620595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QKAWT/cxSc1ZWpBEIsu9+GuZeK2Ze/WKX7uyQzqjbTU=;
	b=hZFI88qASMDuw7/5sGqVVSZb9/saosON+vgwwUNPN6eL2Q1FWFbxTeUrsf3qbiPAeOPiG6
	2i/tXuG9ZVC1ubA87whNPIf2dwMtJgrims0JGyT4RYfzX1E/U6pZdjJ8l3vFPs0MQL/Piw
	fQE7RZL2dlSY9MOTo0Ytlj1fXQyyo+I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "straube.linux@gmail.com" <straube.linux@gmail.com>, pbrobinson@gmail.com,
 luka.gejak@linux.dev
Subject: RE: [RFC PATCH v1 0/9] wifi: rtw88: add RTL8723B/RTL8723BS support
In-Reply-To: <1800080a275f4421b16bd3a028131e8a@realtek.com>
References: <cover.1784047561.git.luka.gejak@linux.dev> <1800080a275f4421b16bd3a028131e8a@realtek.com>
Message-ID: <3EA0A653-D15F-4DD4-8DA6-C9CFFFF38205@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

Hi Ping-Ke,

Thanks for the review, and for taking the time on a series this size=2E

Before I send v2 I want to report what changed, because the result of
your comments is that the series gets noticeably smaller=2E I would
rather tell you now than have you spend review time on patches I am
about to delete=2E

Answers to your questions from the cover letter first=2E

1=2E The link=2E Michael Straube's original work is now referenced in the
   chip patch:

     https://github=2Ecom/mistraube/rtw88/tree/rtl8723bs

   The current state of my series is here, if it is easier to read than
   mail:

     https://github=2Ecom/MocLG/rtw/tree/8723bs-upstream

2=2E sparse and smatch=2E Both re-run on the new series, clean, no finding=
s
   in the 8723b/8723bs files=2E

3=2E Bluetooth coexistence=2E Tested as you asked: WiFi download while an
   A2DP sink plays music, shared antenna, 2=2E4 GHz HT40=2E

   The audio side is good=2E Music played for the whole run with no
   underruns reported by the audio stack=2E The WiFi side is not good:
   download throughput went from 42=2E0 Mbit/s with Bluetooth idle to
   0=2E21 Mbit/s with A2DP active, a 99=2E5% drop=2E So BT wins the air
   almost completely rather than sharing it=2E

   While looking into that I found two chip config values of mine were
   wrong, both now fixed:

     - scbd_support was true=2E The vendor driver has no scoreboard
       implementation for 8723b at all (it exists only for 8703b,
       8723d and 8821c), so this is now false=2E With it false the TDMA
       case moves off case-0, which it never did before=2E

     - bt_desired_ver was 0x6f, which is glcoex_ver_8723b_1ant, the
       driver's own coex version rather than the desired BT version=2E
       It is now 0x6d (glcoex_ver_btdesired_8723b_1ant, shared
       antenna)=2E

   With those two fixed the coex mechanism itself is clearly running=2E
   During the A2DP run it sits on TDMA case-3 (61 30 03 11 11), coex
   table 10, and the run reason is BTINFO, so it is reacting to BT
   status rather than sitting idle=2E

   What it is reacting to looks wrong, and this is the part I cannot
   answer from outside=2E With music actively streaming, coex_info shows:

     Coex Ver/ BT Dez/ BT Rpt   =3D 0133ece9/ 0x6d/ 0x00000069 (Mismatch)
     BT status/ rssi/ retry/pop =3D conn-idle/ -54dBm/ 0/ 9
     Profiles                   =3D  (multi-link 0)
     BT_RSP                     =3D 01 01 40 12 00 00 00
     Hi-Pri TX/RX, Lo-Pri TX/RX =3D 0/3, 440/440

   So the BT side reports conn-idle with an empty profile list while it
   is demonstrably moving traffic (440 low priority packets each way),
   and the profile byte stays 0x01 (CONNECTION) with A2DP (BIT 6) and
   ACL_BUSY (BIT 3) never set=2E Coex is therefore arbitrating for an
   idle link that is not idle, which would explain why WiFi gets
   almost nothing=2E

   The reported BT coex version is 0x69, below the 0x6d the 1ant
   parameters expect=2E Is the rtl8723bs BT firmware currently shipped in
   linux-firmware older than the coex protocol these parameters were
   written for, and should I be using a different blob? If this is a
   known gap I am happy to document the limitation rather than chase it
   in the WiFi driver=2E

Now the larger change=2E

Several of your comments were variants of "does the existing logic not
work, why do you need this"=2E Rather than argue from the vendor driver I
tested it=2E For each of those special cases I reverted it to the generic
rtw88 path, rebuilt, reloaded and measured association, WPA2 handshake
and throughput in both directions=2E

Every one of them turned out to be unnecessary=2E I have dropped these
five patches:

  - apply the firmware-reported TX rate
  - program the management TX descriptor contract
  - add first-segment and retry-limit TX descriptor bits
  - select the management and EAPOL TX rate
  - keep the chip powered between scan and connect (soft IPS)

Specifically, to your questions:

  - "Why does it need report?" and the mac_id question=2E It does not=2E
    With SPE_RPT not set and mac_id taken from si/vif as you suggested,
    association still completes normally through the generic management
    path=2E My claim that the firmware will not schedule a management
    frame without SPE_RPT was wrong=2E

  - First/last segment and the four-way handshake=2E You were right that
    these are unrelated=2E With the first-segment bit removed the WPA2
    four-way completes and data flows unchanged=2E

  - The two rate patches=2E Not needed=2E The generic rtw_get_mgmt_rate
    path carries auth, assoc and EAPOL fine, and without forcing the
    firmware-reported rate the TX rate still climbs to MCS7=2E The CCK
    floor behaviour I described does not reproduce=2E

  - IPS=2E You were right to question this too, though not for the reason
    I expected=2E IPS is entered here=2E With the soft-IPS special case
    removed the chip does a real power off and on, which I confirmed by
    tracing the power state across the transition, and it still
    reconnects every time and passes full throughput=2E So the power
    cycle does not corrupt the management TX path the way I claimed=2E

Result, measured on the reduced series: association fine, WPA2
reconnect 3/3, 20 Mbit/s up and about 32 Mbit/s down, no warnings and
no TX report failures=2E That matches the full series, so nothing was
lost by removing them=2E The series goes from 15 patches to 10=2E

Two caveats I want to state plainly rather than have you find them=2E

First, this was measured on one AP at strong signal (-32 dBm), 2=2E4 GHz
HT40, on a single board=2E If any of those five patches guards a case I
cannot reach here, a weaker link, a different AP, another firmware, you
will know it and I will not=2E Please say so and I will put it back=2E

Second, I kept one you asked about: the auth_sync mechanism in the SDIO
association sequence=2E It also tested removable here, association and
repeated rejoins all succeeded without it, but its whole purpose is to
wait for a beacon or probe response before authenticating, which is
exactly the thing a strong-signal AP will hide=2E I did not want to drop
it on the strength of a test that cannot show the problem it solves=2E If
you think the driver has no business doing that and mac80211 should
handle the timing, I will drop it too=2E

The remaining changes since v1, in short=2E Details will be in the v2
per-patch changelogs:

  - rtw_is_8723bs_sdio() renamed to rtw_is_8723bs()=2E
  - Kconfig and Makefile moved to the end of the series, before
    MAINTAINERS, so the driver only becomes buildable once the
    supporting patches are in=2E
  - Struct fields, flags and function declarations moved out of the
    chip patch into the patch that first uses them=2E
  - The vendor-reference comments removed throughout=2E You were right
    that they were notes to myself=2E
  - Local register defines moved to reg=2Eh, and RF_RCK_OS / RF_TXPA_G1 /
    RF_TXPA_G2 replaced with the existing RF_MODE_TABLE_* definitions=2E
  - Copyright headers corrected to include Realtek, includes reordered,
    comment style switched to the current form, forward declarations
    removed, reverse christmas tree and the alignment and mdelay
    issues fixed=2E
  - The old patch 2 split into smaller patches as you asked=2E What is
    left of it after the removals above is the TX report purge timeout
    change=2E
  - Peter Robinson tested the RFC and reported two warnings=2E The
    "failed to get tx report" one is what the purge timeout patch
    addresses: the 500 ms default is too short for this firmware, the
    same reasoning as the 8723D USB case already in tree=2E The
    "firmware failed to leave lps state" one I could not reproduce
    here, including with forced LPS enter and leave cycles, so I have
    not added a workaround for something I cannot demonstrate=2E Peter is
    on CC and I have asked him about it at the end of this mail=2E
  - checkpatch --strict is clean apart from one TRANS_SEQ_END macro
    warning, which is byte for byte the same as the existing one in
    rtw8703b=2Ec=2E
  - Every commit builds with W=3D1 with no warnings=2E

I will hold v2 until you have had a chance to react to the removals, in
case any of them should stay, and to pick up whatever else you find in
the patches that remain=2E


Peter, the rest of this is for you, hence the CC=2E

Since your Tested-by the series has lost the five patches listed above,
so what you tested is not quite what v2 will be=2E I would rather not
carry the tag forward without asking=2E Say so if you would prefer I drop
it until you have had a look at v2=2E

There is a better reason to ask you than tag hygiene though=2E Both
warnings you hit are timing races I cannot reproduce here, and the
difference looks like host speed: your Pine64 SDIO hosts are slower than
the board I test on=2E That also makes them the right place to check the
five removals, because I validated those on a single fast host against a
strong signal AP, which is the least likely setup to expose a timing
regression=2E If any of those patches was quietly covering for a slow
host, your boards will show it and mine will not=2E

The tx report warning should be gone with the longer purge timeout=2E

For the LPS one, the driver gives the firmware 100 ms to send its null
packet, get the ACK back from the AP and restore REG_TCR=2E If that
warning still fires on v2, could you say roughly how often it happens,
and if it is easy to tell, how far past 100 ms it goes? I would rather
extend that poll by a measured amount than guess a number, and I do not
want to just silence the message=2E

Best regards,
Luka Gejak

