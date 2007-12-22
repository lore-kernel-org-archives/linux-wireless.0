Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:35965 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988AbXLVVzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 16:55:47 -0500
Message-ID: <476D87DA.5030908@lwfinger.net> (sfid-20071222_215550_213441_D2C620DF)
Date: Sat, 22 Dec 2007 13:55:38 -0800
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Only select allowed TX and RX antennas
References: <200712222154.20424.mb@bu3sch.de>
In-Reply-To: <200712222154.20424.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This fixes antenna selection in b43. It adds a sanity check
> for the antenna numbers we get from mac80211.
>=20
> This patch depends on
> [PATCH] ssb: Fix extraction of values from SPROM
>=20
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

After applying the 4 patches you sent earlier, the compilation fails wi=
th

  CC [M]  drivers/ssb/main.o
drivers/net/wireless/b43/main.c: In function =E2=80=98b43_ieee80211_ant=
enna_sanitize=E2=80=99:
drivers/net/wireless/b43/main.c:2720: error: =E2=80=98struct ssb_sprom=E2=
=80=99 has no member named =E2=80=98ant_available_bg=E2=80=99
drivers/net/wireless/b43/main.c:2722: error: =E2=80=98struct ssb_sprom=E2=
=80=99 has no member named =E2=80=98ant_available_a=E2=80=99

These members of ssb_sprom are defined in the patch you sent to Felix F=
ietkau on Dec. 10, but not in
this patch set.

Larry

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
