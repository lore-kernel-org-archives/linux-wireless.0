Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793058838;
	b=RVjbZlTgcoSQF2BE1KgW+9VzVyz3w8e1rA955WKW3Pe99oAlW32RRJppwUsZ5c4atHRJ
	 /96j4hQTq+PMi0qlhaADthOdDIlx6GxOiKdNHwcIIml4X525ECSLZO6bGHCT3/Vr0i0mc
	 u5LOWb/tSVlC/z3Ov5g/n8OvRDgbDk3/GLb3VRG3qsI1yeQ7g8OyBwRq7woRR9h++21N/
	 D6krxZjPIjjmWAxijl9yRg3YGuShrC6VoQcerzVv00vuRvJjCZOGFyfe2FAhd7nKHbVTK
	 URpksy+ycpg+SMxeIRCybVzcag1go3YuwOLf6WetnTyO2IM/A+S8GINNewAiIbgfLOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793058838;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=gtTUpsnhnH3rsvg21dd6LxtJTMa/KKeDtt2ZHd2yoM0=;
	b=Zxdf/md9xOo0D1mEr3gBqKRS+KQzsUwxFcPFmsdL3xdK2EnVy22Ug886JpCFC/ZJZa3n
	 lLgcHnlbrtw1DxOu7vU4u8kXWKAdEfqhgqOoRZFmqqZeDzuW9jLCIBlIlcLArob4GEIeo
	 rS1Tsr/GCLOhuZVGI6tj8BqFAzSio469hIohH9pTri2nXlcADCAEV+sp0Y4XD+KiNtxTu
	 Ddj1tjRg0KHgTaueSuW/AOYAOGkvgKHgi6GBiOB3eKPk+EcDU7pObFUxKINvfV8yh8zUN
	 x6WEBJKUKoX48nf8lOum7De8KBnpFUrmyt4TC4Lx+1ClZTX67Vi5TfHGCcABVnms2NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=EqheJTnu;
	arc=none smtp.remote-ip=62.149.156.101
Received: from smtpcmd10101.aruba.it (smtpcmd10101.aruba.it [62.149.156.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0E0606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 23:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB0E0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=EqheJTnu
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id LUVexsCYFW41bLUVhxjBfF; Tue, 27 Oct 2026 00:53:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793058829; bh=vEU9yg+36xJidGSgxTg4AaBRuc/ZDnUhn3/KLOuX2oo=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=EqheJTnumls8zFlF0YDvVJxJ5E8yiOxpJuTN56W0G+gSS6k2SRbClUAmowcXO7t/z
	 RK9lJsnawZ7OdKRD9N3EVa5OSIy/z5okXPKrVQFx34G+oalegwatFnavlWX8ipc3C9
	 F1L7EzPxVyO140b62XWCiR8jBoU49sBKcgNXbnj7ufb+UGA9K71afcnlcTNQCtPh4Q
	 /zfCu6qKTj+CbnAQVco+WYRgj9BS1ti/XvKfeRkXAm4xpU0uItlfxEbZLEU8QC94Ui
	 OG8rXLFd+2eimUkNSPSQYAaIDi0qnI6jj8cUbf+t970UClvzJCp/n9BQ3aE9cfLsOt
	 CKMQsrtPxnbcg==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Tue, 27 Oct 2026 00:53:48 +0100
Subject: [PATCH wireless-next v2 5/8] bcma: extract SPROM revision 11
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-bcma-ac-rev1-v2-5-b69b61c31920@mythread.it>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
In-Reply-To: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfJTF5XyttIODpSGvzr+IyNa5pZ6s2Iy93f1vGuHU8PAc+2JXCCQEW+VJahQHRKzZfMSpaIsScInpp4Undro0Spc37izaQYfBvFAPBlQNo89WRv+nuTjG
 kITyRDM9iZU5OIkvS5gbAKWxP+yzx9AmUyCM4B4J/Ww6OaDA1q2rHLMsw9+Uq2JZaeIWm+oOthTEqx8wKINYYwO7d3Z05lIMo06PonQNuFRLWJQ+ANlXqvHd
 K9Ukfqd/gfb1eUrLm7VO3SeEnU6Jm3gSRwK1dwjJ6Wy8FmshmJGvFlTEPLFEA4BT9ROpzH5aI4EOnGaa7P5hE3jv8FFgfdcUNPBn4F3dkUgDbhJuGTFJQ+VV
 d0ZPgj44gQuvpaj6XmirDY1BNwcq8/5Cw5Ts4+wrhM4qYZuaHN4=

Add bcma_sprom_extract_r11() and have bcma_sprom_get() route SPROM
revision 11 to it instead of bcma_sprom_extract_r8(). Add the struct
ssb_sprom fields it fills: per-chain power info and rx gains, FEM
configuration, TSSI floor, rpcal, power detector offsets, per-rate
power offsets, temperature words and antenna gain in quarter dB.

Header fields use the rev 8 masks at their rev 11 offsets. The layout
follows bcmsrom_tbl.h and bcmsrom_fmt.h from bcmdhd; offsets checked
against SPROM dumps of BCM4352 and BCM4360 boards.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/sprom.c         | 201 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/ssb/ssb.h      |  58 +++++++++++++
 include/linux/ssb/ssb_regs.h |  94 ++++++++++++++++++++
 3 files changed, 352 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index e668ad796..c98b6fb66 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -474,6 +474,202 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 	     SSB_SPROM8_TEMPDELTA_HYSTERESIS_SHIFT);
 }
 
+static void bcma_sprom_unpack_rxgains(struct ssb_sprom_rxgains *out,
+				      int chain, u8 packed)
+{
+	out->trelnabyp[chain] = (packed >> 7) & 0x01;
+	out->triso[chain]     = (packed >> 3) & 0x0f;
+	out->elnagain[chain]  =  packed       & 0x07;
+}
+
+static void bcma_sprom_extract_r11(struct bcma_bus *bus, const u16 *sprom)
+{
+	static const u16 pwr_info_offset[] = {
+		SSB_SPROM11_PWR_INFO_CORE0,
+		SSB_SPROM11_PWR_INFO_CORE1,
+		SSB_SPROM11_PWR_INFO_CORE2,
+	};
+	u16 v;
+	int i, j;
+
+	BUILD_BUG_ON(ARRAY_SIZE(pwr_info_offset) >
+		     ARRAY_SIZE(bus->sprom.core_pwr_info));
+
+	/* Header: rev-11 offsets, rev-8 masks/shifts. */
+	for (i = 0; i < 3; i++) {
+		v = sprom[SPOFF(SSB_SPROM11_IL0MAC) + i];
+		*(((__be16 *)bus->sprom.il0mac) + i) = cpu_to_be16(v);
+	}
+
+	SPEX(board_rev, SSB_SPROM8_BOARDREV, ~0, 0);
+	SPEX(board_type, SSB_SPROM1_SPID, ~0, 0);
+	SPEX(boardflags_lo, SSB_SPROM8_BFLLO, ~0, 0);
+	SPEX(boardflags_hi, SSB_SPROM8_BFLHI, ~0, 0);
+	SPEX(boardflags2_lo, SSB_SPROM8_BFL2LO, ~0, 0);
+	SPEX(boardflags2_hi, SSB_SPROM8_BFL2HI, ~0, 0);
+	SPEX32(boardflags3, SSB_SPROM11_BFL3, ~0, 0);
+
+	SPEX(country_code, SSB_SPROM11_CCODE, ~0, 0);
+	SPEX(gpio0, SSB_SPROM11_GPIOA, SSB_SPROM8_GPIOA_P0, 0);
+	SPEX(gpio1, SSB_SPROM11_GPIOA, SSB_SPROM8_GPIOA_P1,
+	     SSB_SPROM8_GPIOA_P1_SHIFT);
+	SPEX(gpio2, SSB_SPROM11_GPIOB, SSB_SPROM8_GPIOB_P2, 0);
+	SPEX(gpio3, SSB_SPROM11_GPIOB, SSB_SPROM8_GPIOB_P3,
+	     SSB_SPROM8_GPIOB_P3_SHIFT);
+	SPEX(ant_available_a, SSB_SPROM11_ANTAVAIL, SSB_SPROM8_ANTAVAIL_A,
+	     SSB_SPROM8_ANTAVAIL_A_SHIFT);
+	SPEX(ant_available_bg, SSB_SPROM11_ANTAVAIL, SSB_SPROM8_ANTAVAIL_BG,
+	     SSB_SPROM8_ANTAVAIL_BG_SHIFT);
+	SPEX(txchain, SSB_SPROM11_TXRXC, SSB_SPROM8_TXRXC_TXCHAIN,
+	     SSB_SPROM8_TXRXC_TXCHAIN_SHIFT);
+	SPEX(rxchain, SSB_SPROM11_TXRXC, SSB_SPROM8_TXRXC_RXCHAIN,
+	     SSB_SPROM8_TXRXC_RXCHAIN_SHIFT);
+	SPEX(antswitch, SSB_SPROM11_TXRXC, SSB_SPROM8_TXRXC_SWITCH,
+	     SSB_SPROM8_TXRXC_SWITCH_SHIFT);
+	SPEX(subband5gver, SSB_SPROM11_SUBBAND5GVER, 0x00ff, 0);
+
+	SPEX(tssiposslope2g, SSB_SPROM11_FEM_CFG1,
+	     SSB_SPROM11_FEM_TSSIPOSSLOPE, 0);
+	SPEX(epagain2g, SSB_SPROM11_FEM_CFG1, SSB_SPROM11_FEM_EPAGAIN,
+	     SSB_SPROM11_FEM_EPAGAIN_SHIFT);
+	SPEX(pdgain2g, SSB_SPROM11_FEM_CFG1, SSB_SPROM11_FEM_PDGAIN,
+	     SSB_SPROM11_FEM_PDGAIN_SHIFT);
+	SPEX(tworangetssi2g, SSB_SPROM11_FEM_CFG1,
+	     SSB_SPROM11_FEM_TWORANGETSSI, SSB_SPROM11_FEM_TWORANGETSSI_SHIFT);
+	SPEX(papdcap2g, SSB_SPROM11_FEM_CFG1, SSB_SPROM11_FEM_PAPDCAP,
+	     SSB_SPROM11_FEM_PAPDCAP_SHIFT);
+	SPEX(femctrl, SSB_SPROM11_FEM_CFG1, SSB_SPROM11_FEM_CTRL,
+	     SSB_SPROM11_FEM_CTRL_SHIFT);
+	SPEX(tssiposslope5g, SSB_SPROM11_FEM_CFG2,
+	     SSB_SPROM11_FEM_TSSIPOSSLOPE, 0);
+	SPEX(epagain5g, SSB_SPROM11_FEM_CFG2, SSB_SPROM11_FEM_EPAGAIN,
+	     SSB_SPROM11_FEM_EPAGAIN_SHIFT);
+	SPEX(pdgain5g, SSB_SPROM11_FEM_CFG2, SSB_SPROM11_FEM_PDGAIN,
+	     SSB_SPROM11_FEM_PDGAIN_SHIFT);
+	SPEX(tworangetssi5g, SSB_SPROM11_FEM_CFG2,
+	     SSB_SPROM11_FEM_TWORANGETSSI, SSB_SPROM11_FEM_TWORANGETSSI_SHIFT);
+	SPEX(papdcap5g, SSB_SPROM11_FEM_CFG2, SSB_SPROM11_FEM_PAPDCAP,
+	     SSB_SPROM11_FEM_PAPDCAP_SHIFT);
+	SPEX(gainctrlsph, SSB_SPROM11_FEM_CFG2,
+	     SSB_SPROM11_FEM_GAINCTRLSPH, SSB_SPROM11_FEM_GAINCTRLSPH_SHIFT);
+
+	SPEX(tssifloor2g, SSB_SPROM11_TSSIFLOOR_2G,
+	     SSB_SPROM11_TSSIFLOOR_MASK, 0);
+	for (i = 0; i < 4; i++)
+		SPEX(tssifloor5g[i], SSB_SPROM11_TSSIFLOOR_5GL + i * 2,
+		     SSB_SPROM11_TSSIFLOOR_MASK, 0);
+
+	for (i = 0; i < ARRAY_SIZE(pwr_info_offset); i++) {
+		struct ssb_sprom_core_pwr_info *p = &bus->sprom.core_pwr_info[i];
+		u16 base = pwr_info_offset[i];
+
+		p->maxp2ga = sprom[SPOFF(base + SSB_SPROM11_PWR_MAXP2GA)] & 0xff;
+
+		for (j = 0; j < 3; j++)
+			p->pa2ga[j] = sprom[SPOFF(base + SSB_SPROM11_PWR_PA2GA) + j];
+
+		v = sprom[SPOFF(base + SSB_SPROM11_PWR_MAXP5GA)];
+		p->maxp5ga[0] = v & 0xff;
+		p->maxp5ga[1] = (v >> 8) & 0xff;
+		v = sprom[SPOFF(base + SSB_SPROM11_PWR_MAXP5GA) + 1];
+		p->maxp5ga[2] = v & 0xff;
+		p->maxp5ga[3] = (v >> 8) & 0xff;
+
+		for (j = 0; j < 12; j++)
+			p->pa5ga[j] = sprom[SPOFF(base + SSB_SPROM11_PWR_PA5GA) + j];
+
+		v = sprom[SPOFF(base + SSB_SPROM11_PWR_RXGAINS0)];
+		bcma_sprom_unpack_rxgains(&bus->sprom.rxgains_5gm, i,  v       & 0xff);
+		bcma_sprom_unpack_rxgains(&bus->sprom.rxgains_5gh, i, (v >> 8) & 0xff);
+		v = sprom[SPOFF(base + SSB_SPROM11_PWR_RXGAINS1)];
+		bcma_sprom_unpack_rxgains(&bus->sprom.rxgains_2g,  i,  v       & 0xff);
+		bcma_sprom_unpack_rxgains(&bus->sprom.rxgains_5gl, i, (v >> 8) & 0xff);
+	}
+
+	SPEX(rpcal2g,    SSB_SPROM11_RPCAL_2G,  ~0, 0);
+	SPEX(rpcal5gb[0], SSB_SPROM11_RPCAL_5GL, ~0, 0);
+	SPEX(rpcal5gb[1], SSB_SPROM11_RPCAL_5GM, ~0, 0);
+	SPEX(rpcal5gb[2], SSB_SPROM11_RPCAL_5GH, ~0, 0);
+	SPEX(rpcal5gb[3], SSB_SPROM11_RPCAL_5GU, ~0, 0);
+
+	for (i = 0; i < 3; i++) {
+		bus->sprom.pdoffset40ma[i] =
+			sprom[SPOFF(SSB_SPROM11_PDOFFSET40MA) + i];
+		bus->sprom.pdoffset80ma[i] =
+			sprom[SPOFF(SSB_SPROM11_PDOFFSET80MA) + i];
+	}
+
+	SPEX(cckbw202gpo,           SSB_SPROM11_CCKBW202GPO,           ~0, 0);
+	SPEX(cckbw20ul2gpo,         SSB_SPROM11_CCKBW20UL2GPO,         ~0, 0);
+	SPEX32(mcsbw202gpo,         SSB_SPROM11_MCSBW202GPO,           ~0, 0);
+	SPEX32(mcsbw402gpo,         SSB_SPROM11_MCSBW402GPO,           ~0, 0);
+	SPEX(dot11agofdmhrbw202gpo, SSB_SPROM11_DOT11AGOFDMHRBW202GPO, ~0, 0);
+	SPEX(ofdmlrbw202gpo,        SSB_SPROM11_OFDMLRBW202GPO,        ~0, 0);
+	SPEX32(mcsbw205glpo,        SSB_SPROM11_MCSBW205GLPO,          ~0, 0);
+	SPEX32(mcsbw405glpo,        SSB_SPROM11_MCSBW405GLPO,          ~0, 0);
+	SPEX32(mcsbw805glpo,        SSB_SPROM11_MCSBW805GLPO,          ~0, 0);
+	SPEX32(mcsbw205gmpo,        SSB_SPROM11_MCSBW205GMPO,          ~0, 0);
+	SPEX32(mcsbw405gmpo,        SSB_SPROM11_MCSBW405GMPO,          ~0, 0);
+	SPEX32(mcsbw805gmpo,        SSB_SPROM11_MCSBW805GMPO,          ~0, 0);
+	SPEX32(mcsbw205ghpo,        SSB_SPROM11_MCSBW205GHPO,          ~0, 0);
+	SPEX32(mcsbw405ghpo,        SSB_SPROM11_MCSBW405GHPO,          ~0, 0);
+	SPEX32(mcsbw805ghpo,        SSB_SPROM11_MCSBW805GHPO,          ~0, 0);
+
+	SPEX(mcslr5gpo[0],          SSB_SPROM11_MCSLR5GLPO,            ~0, 0);
+	SPEX(mcslr5gpo[1],          SSB_SPROM11_MCSLR5GMPO,            ~0, 0);
+	SPEX(mcslr5gpo[2],          SSB_SPROM11_MCSLR5GHPO,            ~0, 0);
+	SPEX(sb20in40hrpo,          SSB_SPROM11_SB20IN40HRPO,          ~0, 0);
+	SPEX(sb20in40lrpo,          SSB_SPROM11_SB20IN40LRPO,          ~0, 0);
+	SPEX(sb20in80and160hr5gpo[0], SSB_SPROM11_SB20IN80AND160HR5GLPO, ~0, 0);
+	SPEX(sb20in80and160hr5gpo[1], SSB_SPROM11_SB20IN80AND160HR5GMPO, ~0, 0);
+	SPEX(sb20in80and160hr5gpo[2], SSB_SPROM11_SB20IN80AND160HR5GHPO, ~0, 0);
+	SPEX(sb20in80and160lr5gpo[0], SSB_SPROM11_SB20IN80AND160LR5GLPO, ~0, 0);
+	SPEX(sb20in80and160lr5gpo[1], SSB_SPROM11_SB20IN80AND160LR5GMPO, ~0, 0);
+	SPEX(sb20in80and160lr5gpo[2], SSB_SPROM11_SB20IN80AND160LR5GHPO, ~0, 0);
+	SPEX(sb40and80hr5gpo[0],    SSB_SPROM11_SB40AND80HR5GLPO,      ~0, 0);
+	SPEX(sb40and80hr5gpo[1],    SSB_SPROM11_SB40AND80HR5GMPO,      ~0, 0);
+	SPEX(sb40and80hr5gpo[2],    SSB_SPROM11_SB40AND80HR5GHPO,      ~0, 0);
+	SPEX(sb40and80lr5gpo[0],    SSB_SPROM11_SB40AND80LR5GLPO,      ~0, 0);
+	SPEX(sb40and80lr5gpo[1],    SSB_SPROM11_SB40AND80LR5GMPO,      ~0, 0);
+	SPEX(sb40and80lr5gpo[2],    SSB_SPROM11_SB40AND80LR5GHPO,      ~0, 0);
+	SPEX(dot11agduphrpo,        SSB_SPROM11_DOT11AGDUPHRPO,        ~0, 0);
+	SPEX(dot11agduplrpo,        SSB_SPROM11_DOT11AGDUPLRPO,        ~0, 0);
+
+	SPEX(tempthresh, SSB_SPROM11_THERMAL, SSB_SPROM8_THERMAL_TRESH,
+	     SSB_SPROM8_THERMAL_TRESH_SHIFT);
+	SPEX(tempoffset, SSB_SPROM11_THERMAL, SSB_SPROM8_THERMAL_OFFSET,
+	     SSB_SPROM8_THERMAL_OFFSET_SHIFT);
+	SPEX(rawtempsense, SSB_SPROM11_RAWTS, SSB_SPROM8_RAWTS_RAWTEMP,
+	     SSB_SPROM8_RAWTS_RAWTEMP_SHIFT);
+	SPEX(measpower, SSB_SPROM11_RAWTS, SSB_SPROM8_RAWTS_MEASPOWER,
+	     SSB_SPROM8_RAWTS_MEASPOWER_SHIFT);
+	SPEX(tempsense_slope, SSB_SPROM11_OPT_CORRX,
+	     SSB_SPROM8_OPT_CORRX_TEMP_SLOPE,
+	     SSB_SPROM8_OPT_CORRX_TEMP_SLOPE_SHIFT);
+	SPEX(tempcorrx, SSB_SPROM11_OPT_CORRX, SSB_SPROM8_OPT_CORRX_TEMPCORRX,
+	     SSB_SPROM8_OPT_CORRX_TEMPCORRX_SHIFT);
+	SPEX(tempsense_option, SSB_SPROM11_OPT_CORRX,
+	     SSB_SPROM8_OPT_CORRX_TEMP_OPTION,
+	     SSB_SPROM8_OPT_CORRX_TEMP_OPTION_SHIFT);
+	SPEX(phycal_tempdelta, SSB_SPROM11_TEMPDELTA,
+	     SSB_SPROM8_TEMPDELTA_PHYCAL,
+	     SSB_SPROM8_TEMPDELTA_PHYCAL_SHIFT);
+	SPEX(temps_period, SSB_SPROM11_TEMPDELTA, SSB_SPROM8_TEMPDELTA_PERIOD,
+	     SSB_SPROM8_TEMPDELTA_PERIOD_SHIFT);
+	SPEX(temps_hysteresis, SSB_SPROM11_TEMPDELTA,
+	     SSB_SPROM8_TEMPDELTA_HYSTERESIS,
+	     SSB_SPROM8_TEMPDELTA_HYSTERESIS_SHIFT);
+
+	/* Whole dB in bits [5:0], sign-extended, quarter dB in bits [7:6]. */
+	for (i = 0; i < 2; i++) {
+		u8 raw = i ? (sprom[SSB_SPROM11_AGBG2A0 / 2] >> 8) & 0xff
+			 : sprom[SSB_SPROM11_AGBG10 / 2] & 0xff;
+		s8 gain = (s8)((raw & 0x3f) << 2) >> 2;
+
+		bus->sprom.antenna_gain_qdb[i] = (s8)(4 * gain + (raw >> 6));
+	}
+}
+
 /*
  * Indicates the presence of external SPROM.
  */
@@ -640,7 +836,10 @@ int bcma_sprom_get(struct bcma_bus *bus)
 		bcma_warn(bus, "Invalid SPROM read from the PCIe card, trying to use fallback SPROM\n");
 		err = bcma_fill_sprom_with_fallback(bus, &bus->sprom);
 	} else {
-		bcma_sprom_extract_r8(bus, sprom);
+		if (bus->sprom.revision == 11)
+			bcma_sprom_extract_r11(bus, sprom);
+		else
+			bcma_sprom_extract_r8(bus, sprom);
 		kfree(sprom);
 	}
 
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 67cb66f6f..0548af664 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -23,6 +23,19 @@ struct ssb_sprom_core_pwr_info {
 	u8 itssi_2g, itssi_5g;
 	u8 maxpwr_2g, maxpwr_5gl, maxpwr_5g, maxpwr_5gh;
 	u16 pa_2g[4], pa_5gl[4], pa_5g[4], pa_5gh[4];
+
+	/* SROM rev 11 */
+	u8 maxp2ga;
+	u8 maxp5ga[4];
+	u16 pa2ga[3];
+	u16 pa5ga[12];
+};
+
+/* Rx gain settings of a band, indexed by chain. SROM rev 11. */
+struct ssb_sprom_rxgains {
+	u8 elnagain[3];
+	u8 triso[3];
+	u8 trelnabyp[3];
 };
 
 struct ssb_sprom {
@@ -192,6 +205,51 @@ struct ssb_sprom {
 	u16 legofdm40duppo;
 	u8 sar2g;
 	u8 sar5g;
+
+	/* SROM rev 11 only. */
+	struct ssb_sprom_rxgains rxgains_2g;
+	struct ssb_sprom_rxgains rxgains_5gl;
+	struct ssb_sprom_rxgains rxgains_5gm;
+	struct ssb_sprom_rxgains rxgains_5gh;
+	u8 subband5gver;
+	/* Antenna gain, quarter dB: [0] agbg0 (2.4 GHz), [1] aga0 (5 GHz). */
+	s8 antenna_gain_qdb[2];
+	u16 dot11agofdmhrbw202gpo;
+	u16 ofdmlrbw202gpo;
+	u32 mcsbw805glpo;
+	u32 mcsbw805gmpo;
+	u32 mcsbw805ghpo;
+	/* TX beamforming RX path calibration, 5 GHz in l, m, h, u order. */
+	u16 rpcal2g;
+	u16 rpcal5gb[4];
+	u16 pdoffset40ma[3];
+	u16 pdoffset80ma[3];
+	/* Per-rate-group power offsets, nibbles; [i] is 5 GHz l/m/h. */
+	u16 mcslr5gpo[3];
+	u16 sb20in40hrpo;
+	u16 sb20in40lrpo;
+	u16 sb20in80and160hr5gpo[3];
+	u16 sb20in80and160lr5gpo[3];
+	u16 sb40and80hr5gpo[3];
+	u16 sb40and80lr5gpo[3];
+	u16 dot11agduphrpo;
+	u16 dot11agduplrpo;
+	/* FEM configuration; femctrl selects the FEM control scheme. */
+	u8 tssiposslope2g;
+	u8 epagain2g;
+	u8 pdgain2g;
+	u8 tworangetssi2g;
+	u8 papdcap2g;
+	u8 femctrl;
+	u8 tssiposslope5g;
+	u8 epagain5g;
+	u8 pdgain5g;
+	u8 tworangetssi5g;
+	u8 papdcap5g;
+	u8 gainctrlsph;
+	/* TSSI floor, 0x3ff when not programmed. */
+	u16 tssifloor2g;
+	u16 tssifloor5g[4];
 };
 
 /* Information about the PCB the circuitry is soldered on. */
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index 210f46494..12fa55e91 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -606,6 +606,100 @@
 #define SSB_SPROM8_BW40PO		0x0196
 #define SSB_SPROM8_BWDUPPO		0x0198
 
+/* SROM revision 11. Header fields use the SSB_SPROM8 masks and shifts. */
+#define SSB_SPROM11_BFL3		0x008C	/* boardflags3, 32 bits */
+#define SSB_SPROM11_IL0MAC		0x0090	/* 6 byte MAC address */
+#define SSB_SPROM11_CCODE		0x0096	/* 2 byte country code */
+#define SSB_SPROM11_GPIOA		0x009A	/* ledbh0 low byte, ledbh1 high */
+#define SSB_SPROM11_GPIOB		0x009C	/* ledbh2 low byte, ledbh3 high */
+#define SSB_SPROM11_ANTAVAIL		0x00A0
+#define SSB_SPROM11_AGBG10		0x00A2	/* agbg0 low byte, agbg1 high */
+#define SSB_SPROM11_AGBG2A0		0x00A4	/* agbg2 low byte, aga0 high */
+#define SSB_SPROM11_AGA21		0x00A6	/* aga1 low byte, aga2 high */
+#define SSB_SPROM11_TXRXC		0x00A8
+/* FEM configuration, CFG1 for 2.4 GHz and CFG2 for 5 GHz. */
+#define SSB_SPROM11_FEM_CFG1		0x00AA
+#define SSB_SPROM11_FEM_CFG2		0x00AC
+#define SSB_SPROM11_FEM_TSSIPOSSLOPE	0x0001
+#define SSB_SPROM11_FEM_EPAGAIN		0x000E
+#define SSB_SPROM11_FEM_EPAGAIN_SHIFT	1
+#define SSB_SPROM11_FEM_PDGAIN		0x01F0
+#define SSB_SPROM11_FEM_PDGAIN_SHIFT	4
+#define SSB_SPROM11_FEM_TWORANGETSSI	0x0200
+#define SSB_SPROM11_FEM_TWORANGETSSI_SHIFT	9
+#define SSB_SPROM11_FEM_PAPDCAP		0x0400
+#define SSB_SPROM11_FEM_PAPDCAP_SHIFT	10
+#define SSB_SPROM11_FEM_CTRL		0xF800	/* CFG1: femctrl */
+#define SSB_SPROM11_FEM_CTRL_SHIFT	11
+#define SSB_SPROM11_FEM_GAINCTRLSPH	0xF800	/* CFG2: gainctrlsph */
+#define SSB_SPROM11_FEM_GAINCTRLSPH_SHIFT	11
+/* Temperature words, with the SSB_SPROM8 layout. */
+#define SSB_SPROM11_THERMAL		0x00AE
+#define SSB_SPROM11_RAWTS		0x00B0
+#define SSB_SPROM11_OPT_CORRX		0x00B2
+#define SSB_SPROM11_TEMPDELTA		0x00B8
+/* TSSI floor: 2.4 GHz, then 5 GHz l, m, h, u. */
+#define SSB_SPROM11_TSSIFLOOR_2G	0x00BE
+#define SSB_SPROM11_TSSIFLOOR_5GL	0x00C0
+#define SSB_SPROM11_TSSIFLOOR_MASK	0x03FF
+#define SSB_SPROM11_PDOFFSET40MA	0x00CA	/* 3 x u16, one per chain */
+#define SSB_SPROM11_PDOFFSET80MA	0x00D0	/* 3 x u16, one per chain */
+#define SSB_SPROM11_SUBBAND5GVER	0x00D6
+
+/* Per-chain power info blocks, 0x28 bytes apart; SSB_SPROM11_PWR_* are
+ * offsets within a block.
+ */
+#define SSB_SPROM11_PWR_INFO_CORE0	0x00D8
+#define SSB_SPROM11_PWR_INFO_CORE1	0x0100
+#define SSB_SPROM11_PWR_INFO_CORE2	0x0128
+
+#define SSB_SPROM11_PWR_MAXP2GA		0x0000	/* u8 in low byte */
+#define SSB_SPROM11_PWR_PA2GA		0x0002	/* 3 x u16 */
+#define SSB_SPROM11_PWR_RXGAINS0	0x0008	/* 5gm (lo) / 5gh (hi) */
+#define SSB_SPROM11_PWR_RXGAINS1	0x000A	/* 2g  (lo) / 5gl (hi) */
+#define SSB_SPROM11_PWR_MAXP5GA		0x000C	/* 2 x u16 -> 4 x u8 */
+#define SSB_SPROM11_PWR_PA5GA		0x0010	/* 12 x u16 */
+
+#define SSB_SPROM11_CCKBW202GPO		0x0150
+#define SSB_SPROM11_CCKBW20UL2GPO	0x0152
+#define SSB_SPROM11_MCSBW202GPO		0x0154
+#define SSB_SPROM11_MCSBW402GPO		0x0158
+#define SSB_SPROM11_DOT11AGOFDMHRBW202GPO 0x015C
+#define SSB_SPROM11_OFDMLRBW202GPO	0x015E
+#define SSB_SPROM11_MCSBW205GLPO	0x0160
+#define SSB_SPROM11_MCSBW405GLPO	0x0164
+#define SSB_SPROM11_MCSBW805GLPO	0x0168
+#define SSB_SPROM11_RPCAL_2G		0x016C
+#define SSB_SPROM11_RPCAL_5GL		0x016E
+#define SSB_SPROM11_MCSBW205GMPO	0x0170
+#define SSB_SPROM11_MCSBW405GMPO	0x0174
+#define SSB_SPROM11_MCSBW805GMPO	0x0178
+#define SSB_SPROM11_RPCAL_5GM		0x017C
+#define SSB_SPROM11_RPCAL_5GH		0x017E
+#define SSB_SPROM11_MCSBW205GHPO	0x0180
+#define SSB_SPROM11_MCSBW405GHPO	0x0184
+#define SSB_SPROM11_MCSBW805GHPO	0x0188
+#define SSB_SPROM11_RPCAL_5GU		0x018C
+#define SSB_SPROM11_MCSLR5GLPO		0x0190
+#define SSB_SPROM11_MCSLR5GMPO		0x0192
+#define SSB_SPROM11_MCSLR5GHPO		0x0194
+#define SSB_SPROM11_SB20IN40HRPO	0x0196
+#define SSB_SPROM11_SB20IN80AND160HR5GLPO 0x0198
+#define SSB_SPROM11_SB40AND80HR5GLPO	0x019A
+#define SSB_SPROM11_SB20IN80AND160HR5GMPO 0x019C
+#define SSB_SPROM11_SB40AND80HR5GMPO	0x019E
+#define SSB_SPROM11_SB20IN80AND160HR5GHPO 0x01A0
+#define SSB_SPROM11_SB40AND80HR5GHPO	0x01A2
+#define SSB_SPROM11_SB20IN40LRPO	0x01A4
+#define SSB_SPROM11_SB20IN80AND160LR5GLPO 0x01A6
+#define SSB_SPROM11_SB40AND80LR5GLPO	0x01A8
+#define SSB_SPROM11_SB20IN80AND160LR5GMPO 0x01AA
+#define SSB_SPROM11_SB40AND80LR5GMPO	0x01AC
+#define SSB_SPROM11_SB20IN80AND160LR5GHPO 0x01AE
+#define SSB_SPROM11_SB40AND80LR5GHPO	0x01B0
+#define SSB_SPROM11_DOT11AGDUPHRPO	0x01B2
+#define SSB_SPROM11_DOT11AGDUPLRPO	0x01B4
+
 /* Values for boardflags_lo read from SPROM */
 #define SSB_BFL_BTCOEXIST		0x0001	/* implements Bluetooth coexistance */
 #define SSB_BFL_PACTRL			0x0002	/* GPIO 9 controlling the PA */

-- 
2.34.1

