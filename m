Received: from sonic303-21.consmr.mail.ir2.yahoo.com (sonic303-21.consmr.mail.ir2.yahoo.com [77.238.178.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCD63A3E67
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 23:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.238.178.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789774092; cv=none; b=X09Yv8RZAztlrkA+yUFiZTRx953genWjLBCL7sVW97A7RglIwO1OOxbnGXmbe4bSR2Opq1ckuyMbpE7GPtw52zmfhjkHundO/gHqqlaFvpOSvWPYGOnF5oW+ZevBpgEIKspbeAVE+LpF0XohnEyDP897nb1j8zIaaTgXpBd6soE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789774092; c=relaxed/simple;
	bh=Dp8Ewp8lCEBTTJQoG3iqLcfTJ28wDYhXGatKITIATm0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:References; b=DHPH3y0x8PEWRcdhx8z2WYt1xpjJGXzlc/fAt8LDoiXFnNhg87t6ujO4IpdJitGCmKuhBC8vgfG6xLYNujOZQVveXXLgSIyo4Rwep8hClmj0JRjmpLZxAmxBg1lOCH0a0zFZQIa5U8o9q2qx4z+QacqJHlIStf/FX+B+DlFQ/lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aol.com; spf=pass smtp.mailfrom=aol.com; dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b=YiUy78Az; arc=none smtp.client-ip=77.238.178.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aol.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="YiUy78Az"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1789774086; bh=TPphqip1H8Lk76C9dqxhUr8TuttIEGWw45CEwv5bwqQ=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=YiUy78AztX3hVifTGmrA+GQyfpW95ejpaXqpo41m2nXGnQYgyty/2OJ1d2FNEJf3jk5DJQnAbonIl8dBfvrhGetEt0QInNCy7htiKVpYYoM6vtIGFyFFjNXg4EvE383pbl0eWMfndgtw7Vv6HD272XKZ2Zsl9ROqths2ASlmJUCQLIxgiws9HosSM+jdvRfBowK/ZIYRjCHZci0ID1YKLEUK5p5G/LgEjQxLvx+RboYfevui6ZjAtfIv1yl5wRRrqbcFOotQhLa17o2canTdQ/+JOY+OqcCJ8XrhiNXY3XRxg+ylm9uPtpeg+qPq2WqTJ1g8RbuT3Rv/xvT34x1CCg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1789774086; bh=RBGZMtbfeVr++yp/mcPIsKWI3x6F5TTX56kPS9jo/nj=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=FWuhsV3oXGVNVfXWzTqZKtmUL3M5mRVhQ3N1Zfe+/MCsHChaTfU0zowQZeV3ZeTM6WsOOwpqHnuNPvFq4tz/K1Y3A6rqVHpyU37C31KjEeAOigG9G4iIIJYHCoE+Hof2GBNqrks/Z+JBgnJJD1/RMLxadyDTJRI5zGApHBRKFEq2ElNlM7cP49PRmAk6TKyTUHHTEbGDdVSRMHsM48/sANGOm5btnyhxf0TIM35P+jjiyOoAsFcVsrROuc0P/TZO5DkGWc3to5Qlh7RiSV2mc/4ShYRxZ4++M5B0F8SHZMhCiEv2wUBjSSJ6qAn109XN1vP4Ruaw1ue/8MFxu4Rt9w==
X-YMail-OSG: U_8PCm0VM1lbksz5tiD7vbLGO7c6R78IRSqPvfqohCEkU4l2WBnp8AMdsAAZqjR
 gzXhRjk7rm.5CpWS.XZUCYnjppEkOwuKiz81U_k7fNAtxHI2oY4Qry7vsnOKVwIMkwB8ytTejkIr
 v52m49ZNfrCuhw8aaAvcXN0P5OtIAB8LYF_5ruupvp.NVvif88NHMZW7gZjq4kepDgZanfiugWmx
 DZzu3GaM0xk.mSij0Te90cmk7lV.uFSH0YeIiFB0GtD6K86u61CcvIGg.ZMwbGQjzZ6TWXEGxztL
 B_n9iqhJwZqVAFl9snoRYMwQwKNWBQvx55Wx2xjXlQ_cXUeIlfgo3IhHy78oCwVxp_m2vl0HNvJX
 xmckYwI7fjtGT8L_mLMYtLZ4NdB.cXJ82jauf_kHl88VOz58LdvkHFygqvjDZLsehdKz6uVmvNfW
 brvoiaAy1yiQd8bvV47nnfAOsP_vgXYOSj3aseuH2cNldw7XJbQROEr7BHI9r3ULclj25ZsMveZK
 j96YHp0Y655y_gDFqmC_VuJX17CrCW8LLKzMYIvXqxVVvxrhyoeF1KYhHfatvAJd2HsGP85_ncxD
 9e.nEb_pSgEOIZvJO44agKc67ekgUfDBLb5UtfIBbA40pKAfHWDd4PcQhNBcFQGWKM4zBSe5XsXV
 xk5Q4vIXzxNwfyXT6sC6kSS7GV_bWrtpW56nyq3bZhHzCcOp.0zGTcegqYyuIZsLf3BuM6IE7sdk
 Md6Me5jakNP6qJSVhASTkj6jEw.v5RKuUGCX7zNz5UlkN82G36EQ2T30mKWNvE_Gptwc5xyRD1u0
 8YrfAn7TGBpByrP8wHU4aj.GtkaviyNlVE7weE0QzybKZvRyIU3fUZQ.660SkRnhaIykei3CnKNc
 pZa5tEMvqnxHZDfFVuYx.dqHg49qha8cSyhNF27W.tunayQRE1eSDeioMd0vNWXpdPrHV.YoKAkx
 2hhoorCO1mICaUsYlINwAp2Qkx0IBoY8niTqQMsSHMb5yFAu_xJZPmGZEw_fHIPS9XsmGFN0GWKT
 Tv_xACfTq34Odcnbhczn94BDp4lCAhnskTKK6zMz47V0PoGNyLtJeswQ8aNAVvHwRu9YpE9S9778
 hPwsCSDAycT8_hdaR0OSgFLY1i1c7Q8.z3HlZye94MoUSfzKK0KA71YlgQDmzeTue5emUB5fQ7ke
 cuUV3dG8hLchrcSFYRWut50KA6X5cafvomxevzoCHb.czf_t3PMPltQNnyzDpIspgkP8ZpN9e1jh
 cwP.E0e5HG0StXMwG4cXorlXpf99p2Fh9ijT1qZVJ8Z1aBKSHkwPRxj8rybzGspXkcUPJe.wjrrl
 3EOrEM8WHTJoZkaknL7M_rEg_Df4Kv_YE_dqY_rsVXZp_zoQ..ixN_PofdH8DCotuOIv8wmVYtdN
 QoU6uJupeGxsESJGM.CCa0puzOEdYB9qVqvEZUfQke0XJ2SbzOgGGrNKBwBotYywga5Ev1UjkKMZ
 qMt4ex.I9t_chc_BNVBLGbSyAIRWuKLlNWcVHh9b4iLw5ha.RYRECH8Ln5U2HVtxu5m16LtsilP9
 sxzFsZYX9bWAj4ukgacbS_X1h.DD8P.DMAg_9GwIi8OhtnyMTJGGI6jVBPRGn8sH_r3swrsKKty2
 lD_EMRz_ujXwIaaFG_FZ.tU8SdKdVWoIQDOUpYBgn00YCbG..FyH52j_DyTLJBmgjkBETnkqnoZZ
 M3AwK8m3f.i7BnBbbmU1ZTLMUZ63oLwGww3W.rnrak1wBfRpN_Ss.bmRei6m8KUw1NMOie7q5L7N
 q._KWATtpo1BnUCJCI.JgZwvrzm48m.zjYSF.O6dizB3Jo.gIumu2yB4VurxjuiI6C.hanqBWtNJ
 jW0lDnoH3LKvV6T1nwOCyjomsSbtQbf.uvlsaBJdh1uccjN8N9ecSywhR5L.n765pAqznSd1zK0S
 hxUK71vif8hJ.fK9WpM4QOhuu16p6wPVGf7xxaPUq5gz5EY7kZb2Yk5jUK1cuyFc03q0yiKXG_kr
 _XiLQFX__uLRBKET2kQUtc2T5g7Vi2d8afpFubJ30ndyhQfFI0lGLtgiYz9FMkBbwVx8H1RrftMn
 5P7EFv3z0jErEAFu4M3Hpn.W.PUtYR8bC8eOY_VkVLuf0C72i.cXoGAAkAWuIsdHOYU0bFEkL.66
 mR6U6J.jexlpHNcqU.rGDYS7hgnP.5I6HyiAX1c4zDRBHOEnuQgJVvZStIRMySUFziTQkFyBXNXv
 7KIw-
X-Sonic-MF: <eexto@aol.com>
X-Sonic-ID: e93be70d-9399-4e16-b9a8-23a92581b73c
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ir2.yahoo.com with HTTP; Fri, 18 Sep 2026 23:28:06 +0000
Received: by hermes--production-ir2-cddf86dcf-chq98 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID a80a42786880be7d5459129f48914e7e;
          Fri, 18 Sep 2026 23:28:02 +0000 (UTC)
From: Paolo Lazzaroni <eexto@aol.com>
To: Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Oleksandr Havrylov <goainwo@gmail.com>,
	Gabriel Maia <gabrielvinicius.damaia@gmail.com>,
	Rahul Kumar Rai <learn.rahul.rai@gmail.com>,
	Mihail Dimoski <mihaildimoski@gmail.com>,
	=?UTF-8?q?Ata=20=C4=B0lhan=20K=C3=B6kt=C3=BCrk?= <atailhan2006@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Paolo Lazzaroni <eexto@aol.com>
Subject: [PATCH rtw-next] wifi: rtw88: 8821c: disable deep LPS on PCIe devices
Date: Sat, 19 Sep 2026 01:28:01 +0200
Message-ID: <20260918232801.119348-1-eexto@aol.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20260918232801.119348-1-eexto.ref@aol.com>

On RTL8821CE PCIe adapters, entering 32kHz low-power clock deep sleep
(LPS_DEEP_MODE_LCLK) causes recurrent PCIe completion timeouts,
"firmware failed to leave lps state", "failed to send h2c command",
and hard system freezes when transitioning out of low power states with
PCIe ASPM enabled.

To work around this, a DMI quirk list (rtw_pci_quirks[]) was introduced
and has grown across HP, ASUS, Dell, and Lenovo machines. However, DMI
matching is unsustainable: minor sub-model variances (such as ASUS
FA506II vs FA506IH) or unlisted models (such as ASUS VivoBook X515JA,
Bmax Y14, or modern Alder Lake-N mini PCs) leave users experiencing bus
lockups or firmware drops unless they manually turn off power saving via
iw.

Examination of official OEM Windows driver INF files for RTL8821CE
(HP and ASUS netrtwlane.inf) reveals that vendor drivers explicitly
disable deep power saving (WoWLANPSMode = 0, bLPS_PG_En = 0) and enable
firmware PCIe recovery, while keeping standard PCIe ASPM enabled.
Furthermore, other chips in rtw88 (RTL8723DE, RTL8812AE, RTL8821AE)
already set lps_deep_mode_supported = 0 by default.

Conservatively disable LPS_DEEP_MODE_LCLK specifically for RTL8821C on
PCIe interfaces in rtw_update_lps_deep_mode(). Standard 802.11 LPS
power saving and PCIe ASPM remain functional, preventing system lockups
and firmware failures without affecting SDIO or USB variants.

Signed-off-by: Paolo Lazzaroni <eexto@aol.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 0f23498b5..5bd854223 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1360,6 +1360,14 @@ static enum rtw_lps_deep_mode rtw_update_lps_deep_mode(struct rtw_dev *rtwdev,
 	    !fw->feature)
 		return LPS_DEEP_MODE_NONE;
 
+	/* RTL8821CE PCIe devices fail to wake up from 32kHz LCLK deep sleep
+	 * in time for PCIe completion deadlines, leading to PCIe bus freeze
+	 * and communication timeouts.
+	 */
+	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE &&
+	    chip->id == RTW_CHIP_TYPE_8821C)
+		return LPS_DEEP_MODE_NONE;
+
 	if ((chip->lps_deep_mode_supported & BIT(LPS_DEEP_MODE_PG)) &&
 	    rtw_fw_feature_check(fw, FW_FEATURE_PG))
 		return LPS_DEEP_MODE_PG;
-- 
2.43.0

