Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793601401;
	b=UseJUoRGCGIncU3kgYdFuvFG9SnsX2nVY9WrZB4x9mH+yt4CgJr/7+1bwORDH9EushaK
	 /YhLuQdZFILjA9S20NvQpgKK0XZpxr6Pr8ElB52U1AQ0k9IdQ+/17w11A0w0irtB4mqb4
	 INO+Ex/d2rj83t1J/MBVvVeECdMs9FoIc9LVfBK/dBYt3EPKCfimzpi6n+qfrR3iwf05s
	 eGfOSpc78/TRMzseX1ZNvCxUPzUCuNY7SpUkGyJnjZjEa2JwsWhBzt+OyUCbs7k2ibn/l
	 kxYq2PwhdKtVyksHX0Ob8vy1D4h7ZVT0McOlCSWCZlhvVFBtThJ1aSxsusVsXmPQ0WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793601401;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=atoX9pDrnmOEfuSwTe8PEE8rsrnLvoU/0hK+HZ4aAmk=;
	b=IVf1+mCb5sEVSkW3eaY1TGgXB+bhjnHee3acJ496jsgH71VWNiSEKmetJG9Y/0zeInSr
	 0kXpT/v7C3CwyPbe98o12xDeTAqFIE+7qVwkSfRUTZZrK+oMhEU++H9C7Diky7wvkMJxa
	 VKP+s7iHqeE0xOm6C0V3fFdJVbxbtRGIDLEinhrcYXnHrLKb+7aiXqjCI7hh7hx2CK+hO
	 J3IQRagcqQbyqayRlz0yggCArmlMbhN8W4Altb5BF1nwDRpdxuB3/3xJzlPHUvfdKe9bM
	 Y5wabE94TRcaKr8dneVP4G32g7BuKvHbH2fHZPLlM1PP3P9KEfuNi/OhWQD0OXcbRIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=KwVRzRoU;
	arc=none smtp.remote-ip=109.224.244.25
Received: from mail-24425.protonmail.ch (mail-24425.protonmail.ch [109.224.244.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B55606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:36:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5B55606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=KwVRzRoU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1793601398; x=1793860598;
	bh=atoX9pDrnmOEfuSwTe8PEE8rsrnLvoU/0hK+HZ4aAmk=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=KwVRzRoUe5hC/hlrSL/rWGkfJgPJtQv+3APJPY0nvrHf3QISM9wsFBNIFsoS9kQ2s
	 oArPa4u/xFN9cC+xXee4QGDZbfxv8i1Dt61J2oLadMiW+Rq9rCK5+prM+klcyiQzg8
	 n1o3yC/aMjUoAkbYJFBf1Hgs0llxJleZdF7BLyBh/wg/V4h6YZ+Hhb1UQv9/RtlDYp
	 ySBu3E9vBcspB84a/fBplaIdMms5SEM8iybCCgSY6K6vua+4T+Hd+tCdlvKO6dbTwt
	 uxdfLl6ZYH8Wc8CA0wEfXExbTAZFbMvnxWopyTEjPastXOXWrCEwfVATee/tjl/R23
	 tLo3VTkSxXaxA==
Date: Mon, 02 Nov 2026 06:36:35 +0000
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: frankth3tank79 <frankth3tank79@protonmail.com>
Cc: "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Subject: Upload ~15 Mb/s to Technicolor XB7 (CGM4331COM) unless PMF is disabled on the client (iwlwifi AX210 and rtw89 RTL8922AE)
Message-ID: <3GdfZzytiGgjtiV7JOT7DqKDOB7dAjgMEx9515JX73L9c7oqqSQ3Ol7qThrLYXiSjl9IuraXd8mRVU9rxZRwfez9iKY63dFqaLyssw02Kkk=@protonmail.com>
Feedback-ID: 71374229:user:proton
X-Pm-Message-ID: d66db165ef844e902eb01ebf2ccc57301d36ae1f
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I found this bug while setting up my laptop. Would it be possible to take a=
 look at it?

Upload (STA -> AP) throughput is about 15 Mb/s when this laptop associates
with a Comcast/Technicolor XB7 gateway, model CGM4331COM (Broadcom radio,
ISP-managed). Setting PMF to "disable" in NetworkManager on the client rais=
es
it to about 90-100 Mb/s. The same laptop gets about 700 Mb/s upload to a
different AP. Other (non-Linux) clients on the XB7 are not affected.

Hardware / software
  Laptop: HP OmniBook 5 16-cd0xxx, BIOS F.07
  Card 1: Intel AX210, iwlmvm, fw 89.b20dcd1f.0 (ty-a0-gf-a0-89.ucode)
  Card 2: Realtek RTL8922AE (rtw89), the laptop's original card: same sympt=
om
  Kernels: 7.2.11-200.fc44 (Fedora 44), 7.3.0-9-generic (Ubuntu 26.04 live)
  wpa_supplicant 2.11, NetworkManager 1.56.1, linux-firmware 20261019

Link
  5 GHz ch 157, 80 MHz, HE 2x2, signal about -60 dBm
  tx bitrate HE-MCS 5-7 NSS 2 (576-720 Mbit/s), so the PHY rate is fine

Results (iperf3 -P4, STA sending, TCP, to a host behind the AP)
  PMF default (optional), run 1     15.8 Mbit/s
  PMF disabled,           run 1    101   Mbit/s
  PMF default,            run 2     14.0 Mbit/s
  PMF disabled,           run 2     87.1 Mbit/s
  Different AP (phone hotspot, HE80 2x2, PMF default)   706-747 Mbit/s

With PMF at default, the upload looks like this:
  - only ~130 frames/s are handed to the radio (station dump tx packets),
    with ~35% tx retries and 0 tx failed
  - ping to the AP rises from 6 ms idle to 85 ms avg / 331 ms max under loa=
d
  - UDP upload tops out at ~2,300 frames/s, one datagram per frame
  - forcing VHT (no HE) gives the same result, so TWT and UL OFDMA are not
    involved
  Download from the AP is also limited (~40-50 Mbit/s).

Relevant AP IEs (from iw scan dump)
  RSN capabilities: 0x000c  (MFPC=3D0, MFPR=3D0: the AP does not advertise =
PMF)
  HT capabilities: Max AMSDU 3839, RX AMPDU 65535, spacing 4 usec
  VHT operation: basic MCS set 0x0000  (demands MCS 0-7 on all 8 streams)
  HE operation: basic HE-MCS NSS set 0xfffc, BSS color disabled
  WMM BE: CW 15-1023, AIFSN 3, TXOP 0
Kernel 6.19.10 logged "required MCSes not supported, disabling HT" with thi=
s
AP and fell back to 54 Mbit/s legacy. 7.2/7.3 associate with HE.

So the client advertises MFPC (PMF optional), the AP doesn't, PMF should no=
t
be negotiated, yet upload is ~6x slower than with PMF disabled. My guess is
that the AP mishandles a STA whose RSNE has MFPC set, maybe by treating som=
e
frames (e.g. action frames for BA setup) as protected. A capture can be
provided if useful.

Is this a known XB7 interop issue? Would a quirk make sense, e.g. not
advertising MFPC when the AP's RSNE has MFPC=3D0?

Thank you,
Frank

