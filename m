Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA553EC6B2
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 19:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790968279; cv=none; b=r5Z8YY8hLYteU6K6IqfVrJjbX8Rm7DUcTf7E/38E68riyB/vXAHgmzb+dNFGJnQTlwCjoO+EVGCR0WmevT4mUnF7gI4Py6BE/lgOuJzl6MsSvL4jubDVbKTtAT/SxhNWEnZoj3iiG1r7NfNYxl69W2NL+81Bc/hRq8ZeMkhKiCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790968279; c=relaxed/simple;
	bh=WF6+y8M1H87RN89tbxSCX46b7bs0+K3hXAxym6HzJ4o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UDxASkj5gtFJGRtiuJdit5nELP7Sc4VOM5HswLyek1ynZYTpsx4ukE3bTjDqYzvC22lUhynyJCOCnO+H9HZ5GTW0Z9CvWvDJXcRr+NxXZmNtaaIgKdNbdHf370iwyss4EsjdwQBwk7ZEcAoIRi3LuQWqgj8lNn2Wq0tiOasPjew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=brqvbZWX; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FUZMgQTg; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="brqvbZWX";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FUZMgQTg"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 692H63ea2985437
	for <linux-wireless@vger.kernel.org>; Fri, 2 Oct 2026 19:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ucaMuJoTpFK+IiMHoGwV2a/H7vZce9en2rw5/IvbLME=; b=brqvbZWXTDC4JTZy
	gMAkvqMCcyxckvBTqGVWw8NXMzKjQwc4PI3UjA+S3n5zzJH82j2P5mKt6Z2LpWRx
	o/vG0+zFECT5W+Z6J04+4xJctOws+bd/n8dXI/OCk6pcf+eVTnXab8Yka0gYKTmV
	P0HD2s9LsiJln5sz6iKIO1Lzvsb+oUGUKKizM4pvGhWMLkFW5ocsfrASLOGRsfm9
	3JEP2uoFIyxV2XvDrOZ0dE/dueWJlzt9S43u8diMytGruh0kz03NT9x0bLLxvRgh
	yKRAddF2t8/xA/jKopJmWgzSKAyukbePdV2cRcbNe+4f4kx5e2Kl8+yJg/9m3GEq
	uUu2Nw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h256mu3xr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 19:11:11 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33baaba6371so11046605eec.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 12:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790968271; x=1791573071; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ucaMuJoTpFK+IiMHoGwV2a/H7vZce9en2rw5/IvbLME=;
        b=FUZMgQTglL+ny9+t3Z5i3wywn/7VOizY1OE3BF6wPu0IKYIya2kX8u6j5tjAoVm+gM
         bV5ByauoH4DmtEoGXADgdoMNY7mYk7M9SBrvEHJwizHkVvAinaZh3bVR4GOsxjHILWx5
         lgwhyBsUpSZ0xW7cgblj60ZJM9rRuPGMKXHQ+JlIozw/kidng7VzoIg7+JM9g9ZB/QIY
         kyw/W47S2nNfK9vdWmvdgmv44zWc+rvfqSrzSPjixFX/s0cH7QjKTOG14B2bty0rgeW4
         qLT3GZNUZrXsgvka3NT7sGeraLdShTwgZJBghumDFjlzkmMMSbopNdSvAaVygwHkhzG5
         p/tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790968271; x=1791573071;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ucaMuJoTpFK+IiMHoGwV2a/H7vZce9en2rw5/IvbLME=;
        b=1KKioEJI/3U0J9NT/7rxZ+B4djiwjz6nrAUw+Jp2ARIo9KobKFqCm4mqPRH0G/++g3
         sRrh9OAslCp9QJjNOYE/vtxX7DtOR6tRyNrgUmPMKMpUU3e/HWAimumYJlQFHnVCXCxG
         EnH2HCe1APzcoPth8bJUpcafhzAqny6NZqfClBp0hcsubymfnaECKKfJdNxW3Z6wm18l
         u0v250u2UxY7nZbPCWR1q7oOqblTgRCV4qSmm3r+O46cK39BnpdnabEdTjp63plonTDe
         g48z5/CyLUMo2uLPEgH5wwaMgOKsdnyieAQgS34oYLlHVvu8H0zsByLbC6IGS912ea91
         mrhA==
X-Gm-Message-State: AFq9FYJvAxAcSwWasz8ts81vcoJJq2JGd9+D6Cb2Zd772tfa4SsgCRfZ
	q/dtbYiy8AHzup8ewuBjYZQkILqd900qW/YxvtO9QDgnoasP6SxchCVz3SlyTTn5mmsavH2dd5c
	iGkXufGfCGQ8nd9uWL4Xn2JS7kLlUKMGawy66qnId8fh2GrKXl/FwHHomO0dBp0mhDVCveQJlJj
	XYZw==
X-Gm-Gg: AYBFou368SiaYHqSb91fPfyASfTECjekzRIJUZ1NbeTjlNzsdrziCv2HpMPTmFfT74L
	Rm8tFtRe54FW0sFFLQDj98h5ubqMyf6ZYdzyGn61wQX1zEmzbTaokfXD4ScQfo96HXGp2p9FN/T
	wqbCEoa2TfZUxQLCrgyZdDwV4rB0gdbvkcayL6r9i9rTGdQocHAvrqGoTDkOIonq0lRSA0XiMJg
	ZQrZ0JxNO6zb3GPSVY3osTnRVagSGUXQk9zgLhHvN7OLCbjwSuNE2MJdHvJJsA3OhHjxiYlZJUR
	vYp3Ag0EQbiksMP2wAp62XT300GuHwIUv8ehNBISptwZFkQmuvRGC+JRCq0O3Puov7f2L6tq8qf
	oulJMDfcx/nfduqdwv57hUP+D69+hs8FZhfrjNL1Rbut1tyjoTZKeUe0=
X-Received: by 2002:a05:693c:83c3:20b0:33b:f5b7:f494 with SMTP id 5a478bee46e88-34f1509e567mr4432618eec.13.1790968270821;
        Fri, 02 Oct 2026 12:11:10 -0700 (PDT)
X-Received: by 2002:a05:693c:83c3:20b0:33b:f5b7:f494 with SMTP id 5a478bee46e88-34f1509e567mr4432590eec.13.1790968270237;
        Fri, 02 Oct 2026 12:11:10 -0700 (PDT)
Received: from alokad-linux.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35105dd1dfasm5263296eec.8.2026.10.02.12.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 12:11:09 -0700 (PDT)
From: Aloka Dixit <aloka.dixit@oss.qualcomm.com>
Date: Fri, 02 Oct 2026 12:10:56 -0700
Subject: [PATCH wireless-next 1/2] Revert "wifi: mac80211: do not use old
 MBSSID elements"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-csa_cca_fix-v1-1-b83a998aeb44@oss.qualcomm.com>
References: <20261002-csa_cca_fix-v1-0-b83a998aeb44@oss.qualcomm.com>
In-Reply-To: <20261002-csa_cca_fix-v1-0-b83a998aeb44@oss.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aloka Dixit <aloka.dixit@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAyMDA3NiBTYWx0ZWRfX+yIutoPmC4HD
 qNyqNHeNW4bTh0qP27p1qH2WC87jTqJKs2jaEwI8pUhizBAmxYJp0KjIfrotYNnURLmuQ4Yf7K7
 FpJ5x2JkG0WGhpqv4M52rgoMQtzbodw=
X-Proofpoint-ORIG-GUID: P1iIds2ZriNmiOBQYryFDHYy_TLIAgbQ
X-Authority-Analysis: v=2.4 cv=b80ncdGx c=1 sm=1 tr=0 ts=6ac001cf cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=N6xB3pvji6ksF1bIA8MA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: P1iIds2ZriNmiOBQYryFDHYy_TLIAgbQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAyMDA3NiBTYWx0ZWRfXy6eJDR81f1vI
 kKJap2jCQAG29pwOOhgpNsDCfAC525OShIljRkV4C9FgzjBjguzgYaNbYjvnlQ9IRqeK9N57yyM
 UcMLb0A6Z9PbtULm4jxdqLw9OzGwg+6eF+OWCLaSG29jetpaxVQR00lC8VPG5dOg4/coU24W7uk
 LTkIaZDB3mM8SdZsyM4jS1Q2QFcuFUY2/2Z77y7a1O6nym2dPtZ7usjT3n0JLGY6h18N9gSlIxZ
 RABjdAs+AdBiU+6F3/lbcxI24U8ERtzkLv9e/OLoPAT0Z1ysHCkEeKyi1ojk9RUaRoq+jJ6qISe
 tCwolOG8rCvep5LVCZdw9InSwdlhwXrpC56sWRAwT90VY9JjUuWXMRGtjVtH4vmYYHOPir0Idfh
 23YJRIXrABMEKWGeKUPYMv7y1dfqTYrtOQquWoii3Tkc76yo3CUIfe7EBh19WAOkoapGCwgvU5o
 ujSGwIZfq1eTsQDzt7w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-02_05,2026-10-02_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610020076

Commit a519be2f5d95 ("wifi: mac80211: do not use old MBSSID
elements") fixed the incorrect inclusion of stopped/removed
non-transmitted profiles from the Beacon frames, but it caused
a regression for channel switch (CSA) and BSS color change (CCA)
operations initiated from hostapd.

Hostapd passes two Beacon templates to kernel for CSA and CCA -
(1) beacon_csa/beacon_color_change used during the countdown.
(2) beacon_after/beacon_next used after the countdown completes.
Hostapd relies on the kernel to include the old MBSSID elements
while sending beacon_csa/beacon_color_change templates to the
driver.

This path is now broken and results in CSA/CCA failure.

Including existing MBSSID elements explicitly makes the netlink
buffer larger than default 4 KB depending on the number of APs
which would need unnecessary complication to pre-calculate the
buffer length.

Revert the commit to fix the regression.

Regarding the original issue fixed by the reverted commit -
Hostapd now has a new commit which always includes at least one
MBSSID element when the feature is enabled, hence when all
non-transmitted profiles are removed, this empty element ensures
that stopped profiles are not advertised.

Fixes: a519be2f5d95 ("wifi: mac80211: do not use old MBSSID elements")
Signed-off-by: Aloka Dixit <aloka.dixit@oss.qualcomm.com>
---
 net/mac80211/cfg.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bd1a857c812d..b38941e6784f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1518,6 +1518,7 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 
 	size = sizeof(*new) + new_head_len + new_tail_len;
 
+	/* new or old multiple BSSID elements? */
 	if (params->mbssid_ies) {
 		mbssid = params->mbssid_ies;
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
@@ -1527,6 +1528,15 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
 							mbssid->cnt);
+	} else if (old && old->mbssid_ies) {
+		mbssid = old->mbssid_ies;
+		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
+		if (old && old->rnr_ies) {
+			rnr = old->rnr_ies;
+			size += struct_size(new->rnr_ies, elem, rnr->cnt);
+		}
+		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
+							mbssid->cnt);
 	}
 
 	new = kzalloc(size, GFP_KERNEL);

-- 
2.34.1

