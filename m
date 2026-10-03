Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198F023AE9B
	for <linux-wireless@vger.kernel.org>; Sat,  3 Oct 2026 21:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791063992; cv=none; b=DJzLz43LfOyhrGCOCCC9pbIveTClKkMR3/HSUkkcl/XgXod2IU1DaJVn1BZ5fHn0i7Aqu4t3Jb4ZNc57LDVtGp64MU3lRj/rpZDuzqUTRWuXZWjbXsTSwnTvOs2GuhcJkQMf4xpbB154q932+rpWXGdKY28TvGKNksKF8jff65E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791063992; c=relaxed/simple;
	bh=R2PnYisYJ0NyVPAFlfdhpen4Vsn/htjtFxxV0Y95zsU=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=p5KQDVXAzGf6vf9iGqsXM3QcKUO9A3pJeGK5B62bL3TazCgc2ZPcDToVdZiwaDmi0WBOdp+3IVtXffNQSy5J49q7a4kdkL6ruTrqHncZplQJuGOYS7WAz6yalS9OnhBtsp5AMMdrcJDZXN2l1aITUp04iZXUgnuH4Y9Ea+ZCv+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KRfsxR3J; arc=none smtp.client-ip=91.218.175.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KRfsxR3J"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=R2PnYisYJ0NyVPAFlfdhpen4Vsn/htjtFxxV0Y95zsU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791063987; v=1; x=1791668787;
 b=KRfsxR3JWrZt7S/APslMVx3xJYmNK0AG74Btpw3aJG8c7kswMXV3/ryugfYZdSgkmRzDbbWm
 ySxayyt2w8ewofbAGLrXTnKx+/mmgWNCpMXIxwXWDmdMasRpBKxhZupH8mU/ytzpglQfbL4UDlW
 5jR0E1v+hZ4CLM0fDV9r/VI0=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 667c1a93a59ef06a;
	Sat, 03 Oct 2026 21:46:17 +0000
X-Mizu-Trace-ID: 667c1a93a59ef06a
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 03 Oct 2026 21:46:17 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <dfd0ce2876857c40b4d3a6da38b2e704cb6a698d@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v7 0/6] wifi: rtw88: add RTL8723B/RTL8723BS
 support
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, luka.gejak@linux.dev
In-Reply-To: <7bfa286e-50f5-4da7-a8df-0f7e743780b3@gmail.com>
References: <20261002073845.31486-1-luka.gejak@linux.dev>
 <7bfa286e-50f5-4da7-a8df-0f7e743780b3@gmail.com>

October 3, 2026 at 23:26, "Bitterblue Smith" <rtl8821cerfe2@gmail.com mai=
lto:rtl8821cerfe2@gmail.com?to=3D%22Bitterblue%20Smith%22%20%3Crtl8821cer=
fe2%40gmail.com%3E > wrote:


>=20
>=20On 02/10/2026 10:38, Luka Gejak wrote:
>=20
>=20>=20
>=20> This is the second of two series adding support for the Realtek RTL=
8723B
> >  802.11n chipset and its RTL8723BS SDIO variant to rtw88. The prepara=
tion
> >  series has landed in rtw-next, so this series carries the chip regis=
ter
> >  definitions, the BB/RF/AGC tables, the chip driver, the SDIO bind an=
d the
> >  build glue.
> >=20=20
>=20>  The first patch is the only shared-core change. It moves the CCK p=
ower
> >  detect setter out of rtw88xxa.c into phy.c as rtw_phy_cck_pd_set(), =
so this
> >  chip can use it without pulling in rtw88_88xxa. The six chip patches=
 apply
> >  on top of it and can be read on their own.
> >=20=20
>=20>  The driver supports:
> >=20=20
>=20>  - RTL8723B / RTL8723BS, SDIO only
> >  - 2.4 GHz 802.11n, HT20 and HT40
> >  - one spatial stream
> >  - station mode
> >=20=20
>=20>  Only station mode has been validated. The common rtw88 core advert=
ises AP
> >  and IBSS for all chips, so those modes are advertised for RTL8723BS =
as
> >  well, but neither has been tested. An out-of-tree tester has reporte=
d AP
> >  mode associating without DHCP completing. The five additional SDIO I=
Ds are
> >  included for parity with the existing staging driver, and only the 0=
xb723
> >  device has been exercised.
> >=20=20
>=20>  The chip driver requests:
> >=20=20
>=20>  rtw88/rtw8723b_fw.bin
> >=20=20
>=20>  This is the version 41 firmware extracted from the Realtek rtl8723=
bs
> >  vendor driver. It was submitted separately to linux-firmware with it=
s
> >  extraction provenance and carries Ping-Ke Shih's Reviewed-by. There =
is no
> >  known native rtw88 RTL8723B firmware.
> >=20=20
>=20>  The implementation is based on the initial RTL8723B work by Michae=
l
> >  Straube:
> >=20=20
>=20>  https://github.com/mistraube/rtw88/tree/rtl8723bs
> >=20=20
>=20>  Michael's Co-developed-by and Signed-off-by tags are present on th=
e three
> >  chip-code patches containing code derived from that work.
> >=20=20
>=20>  The known limitations are unchanged. Bluetooth coexistence depends=
 on the
> >  BT firmware's status reports. During A2DP streaming those reports id=
entify
> >  a connected link but do not expose the active profile, so the WiFi
> >  coexistence logic cannot make a correct traffic-aware decision. WiFi
> >  throughput can fall sharply while audio remains smooth. This is docu=
mented
> >  rather than guessed around in the WiFi driver. The intermittent RTL8=
723BS
> >  firmware failure to leave LPS also remains, and instrumentation show=
s a
> >  firmware stall rather than a polling timeout that a longer budget wo=
uld
> >  fix.
> >=20=20
>=20>  Testing
> >  =3D=3D=3D=3D=3D=3D=3D
> >=20=20
>=20>  The exact six-commit branch builds with W=3D1, with no new warning=
s, and
> >  links all rtw88 modules with real modpost. Sparse and smatch were ru=
n over
> >  the rtw88 directory. Sparse is clean. Smatch reports nothing in the =
8723B
> >  files, and its only output is an existing container_of static assert=
ion
> >  from include/net/neighbour.h while checking usb.c. checkpatch --stri=
ct is
> >  clean apart from the complex-macro report on TRANS_SEQ_END, which is=
 an
> >  initializer macro that rtw8703b.c already defines in the same way, a=
nd the
> >  "does MAINTAINERS need updating" reminder on the file-adding patches=
, which
> >  the existing REALTEK WIRELESS DRIVER (rtw88) entry already answers w=
ith its
> >  F: line. git diff --check is clean and all six commits are GPG-signe=
d.
> >=20=20
>=20>  Hardware validation covered module identity, boot, scan,
> >  authentication, association, WPA2 key negotiation and DHCP, TCP and =
UDP
> >  traffic in both directions, ten scans while connected, and twenty mo=
dule
> >  reload and reassociate cycles. dmesg is clean, with no warnings, no =
errors
> >  and no TX-report, H2C or leave-LPS messages. The extended soak added=
 six 30
> >  second TCP runs, UDP saturation in both access categories with no lo=
ss, a
> >  2000 packet ping run with no loss, and three idle power save periods=
 with a
> >  clean wake. The test machine provides only s2idle, so suspend and re=
sume
> >  are not covered.
> >=20=20
>=20>  Changes in v7:
> >  - dropped rtw8723b_sdio_restore_pad_ctrl() and its two remaining cal=
l
> >  sites. The register it adjusted is only written by
> >  rtw_mac_pre_system_cfg(), which returns before that write for 8051
> >  chips, so nothing in the driver sets the bits the function cleared a=
nd
> >  the hardware default already has them clear.
> >  - rtw8723b_fill_txdesc_checksum() now uses fill_txdesc_checksum_comm=
on()
> >  from tx.h. The now unused linux/unaligned.h include is dropped.
> >=20=20
>=20>  Luka Gejak (6):
> >  wifi: rtw88: move the 88xxa CCK power detect setter to phy.c
> >  wifi: rtw88: 8723b: add the RTL8723B register definitions
> >  wifi: rtw88: 8723b: add the RTL8723B BB, RF and AGC tables
> >  wifi: rtw88: 8723b: add the RTL8723B chip driver
> >  wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
> >  wifi: rtw88: 8723bs: enable building the RTL8723BS driver
> >=20=20
>=20>  drivers/net/wireless/realtek/rtw88/Kconfig | 18 +
> >  drivers/net/wireless/realtek/rtw88/Makefile | 6 +
> >  drivers/net/wireless/realtek/rtw88/phy.c | 39 +
> >  drivers/net/wireless/realtek/rtw88/phy.h | 1 +
> >  drivers/net/wireless/realtek/rtw88/reg.h | 34 +
> >  drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2550 +++++++++++++++=
++
> >  drivers/net/wireless/realtek/rtw88/rtw8723b.h | 14 +
> >  .../wireless/realtek/rtw88/rtw8723b_table.c | 861 ++++++
> >  .../wireless/realtek/rtw88/rtw8723b_table.h | 17 +
> >  .../net/wireless/realtek/rtw88/rtw8723bs.c | 59 +
> >  drivers/net/wireless/realtek/rtw88/rtw8812a.c | 2 +-
> >  drivers/net/wireless/realtek/rtw88/rtw8821a.c | 2 +-
> >  drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 38 -
> >  drivers/net/wireless/realtek/rtw88/rtw88xxa.h | 1 -
> >  14 files changed, 3601 insertions(+), 41 deletions(-)
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table=
.c
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table=
.h
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c
> >=20
>=20Looks good to me.
>=20
>=20Reviewed-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
>

Hi Bitterblue,

Thanks for all of the support and help along the way.
(And for the Reviewed-by tag.)

Best regards,
Luka Gejak
