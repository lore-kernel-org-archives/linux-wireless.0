Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793769117;
	b=rF2XLvzIEHeEResi5tMgmgTfxKitL6/m1945TuI7luW4PSQRK0XLmWmnBegt2oVzDFlv
	 BEIEPBfEdEPlfOxUbCNfHM6gbtXk9EQ/DOyxf0Yhl56WEyS27LV7ntOWPZLHU+3reqNe7
	 cJmhqFuXIGwX6HMvj3Y4+DGzwwxuMUfdHHFB5QFsvGFHQ2bkkDjAwIMPcxhmOA+E5Ylxj
	 oyWLW0I/5gxOoa9dYIufQUY6H8765e0nAL4Z5lcZkFU0OeiyJSfCEZff1ta8bpNzu1u0x
	 yhhXFBWujX/AOL4auLbEcSagJ7Tpa/azCJ/xWdnYsGJk8s3fOuWnzb+WjFMqN/G6/cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793769117;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=ZrS5YGwtC4IaKsmHGx6ORDQm8LmgvzNP9GY6nikTxrA=;
	b=BrO1YMKtIsfbfdac52Ohf0YfkLU1VD60T/7hlAyfplCbf/OUnDbqId9JwmNIwr9HEKni
	 8TcmP+ci479dSO1wMiXpX9sDtbv1uKh/CRp0gUEBOAaZWjHj4ScnV/+5L/fsLGGp3Ww/m
	 SxkrOsBMAgBHQWepIZrohWNIYc90xfwTGJUl2DGE6/edbCCew7bVE89D9hqPvGY1OREXO
	 LKoY11Z7yUkaaPdBrX9gPUVez2JE4mz/gegjnpZ4ZipH1unMNfJ8YLiBhRJXsw2jIauqB
	 rNSTttgCG4NJg1Vs/0KFRG8Vj6cWNdOhfxPQ350C65D/o6a5ccbLYqGpK1wdOPLKcqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FdK3eWsd;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=abt4Chex;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AE0606A31B
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 05:11:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5AE0606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FdK3eWsd;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=abt4Chex
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RM2D3335472
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 05:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=ZrS5YGwtC4IaKsmHGx6ORDQm8LmgvzNP9GY
	6nikTxrA=; b=FdK3eWsd4CCrcN7iexPYR6/phtr7PXM1S4sDiVRW7zO2gBE14OH
	GLsToSuDj2Y8vbiAZoEogxkacBHBFk8znWLXIlQjx69MLPHLYsYJzqoEGkTQpvf7
	A0YvdOKivrJ3Sg9tac55EevL+ekX1h6heGWdAqYlsl3ny32gq6XdsjYSiK+rQHpc
	vX1M/Q4UGFvp8+jPvc1Z+st3v+Q1bNQJIUqT/qmAr86CjNxSCGnpBE/hbal2Z/nl
	7vwdATwhx1yzB46fl+nGphn93SiQ5otRvb47lvM4/5EjjzGGK0EZD+0yyU5yI5UY
	95th7ct7fdSYN5K9bKipsdpdvX02pwJXLhg==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqmjbt8bm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 05:11:55 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1acbaf81bebso539290c88.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 21:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793769114; x=1794373914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZrS5YGwtC4IaKsmHGx6ORDQm8LmgvzNP9GY6nikTxrA=;
        b=abt4ChexfeJjWfsgGVPFg090YneBsPfUSdEg5lf2Hh3T87gPr/QyEPiqk/6lPDSb37
         kAvQVCI9ySMuEe499P8P+nwkvj0I7IJD7RrW40EH4BCoWJRV87JaScqTtbtkf5BbqfQ3
         ww0S9vk2hLUTsiSEyd5CfMyd1Kax7ctxIqpRKsKoTKe0szE5YIaSz/qO80Gvocj6tu/0
         cLgiNobMiGvwaZ/rAmLIgobxqozvOkYEU4hJF+CILBdSyVy6dFYfwwQYkGmOoiNfizmL
         NTIRW97hQHOcit46gyfJXoH+3A9BL0tROg6DDfdMKW382xtpHkHqPm8Pow0qe/ThsaVk
         fRsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793769114; x=1794373914;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZrS5YGwtC4IaKsmHGx6ORDQm8LmgvzNP9GY6nikTxrA=;
        b=dqerh8GwWITvJy6cM6Tbq3sa2V4pixgXVDR3zH5MY5tyTyOCr1fKC4ixhSb0mDQidr
         gk8KlBqwOL6HFk1HdYoD3/FrnoiCbQD3DISvmWaRtwm/CZF6tIYFmcVLt3oH8P+l+jrs
         cU4hjUdl28rP63xxqbnsnXoxJF0aVEMJ/GBChcWsclqnYvekOYhUpQ7Mv2NDFJ0KGAOn
         8qaJhziv7wtoCIb+TawW8jyHMyfC5oRJz4WkejbThyAYwK+A29k/xPwAbWew4EOD4ow5
         gzXcFXJB0tvcFYfD8B8f7udljzgY0S/GvihE1RJYmF6DrGCSL96LEvjhFhU4z9BmubLi
         z+BA==
X-Gm-Message-State: APuU4Z/U0/CyVmJ45yPZG/3+fOlq6myi3nauccZMlljkm7cD2it5tN8b
	ah+kvVtusqHSzgaAG3YcQ77IiAsncpNE5CryLycceJw+Akb3q0EwJgvHdq8OX7Xg6pqdmVCFTHF
	spuJ4DDKOI/1REzpa0rSq0seGk3I2AdK3iE72GZMCutOnhoCO/3cnDplelTrbtHlUtb87fA==
X-Gm-Gg: AYBFou2IKBo5WLAwDudlPa5BWsUGjPdwQfH24MQ3K5qp2kUm4mvGRls4b9MWTydUckb
	JRBfiFy49x6V6PMvD+fq8C9mZTeXhl7URpquoin+LDvOaQ161vRZlQxrmOoDR1z6BZOfvJP7+hl
	Sp9B2/lVz5i35PQaN1nPRaOsOgPBa38JbfMcrzP7pBxjx0ePLMp7gc9gUrl00BeAa9T759C+RKt
	0WRGAMBQFArzNoJzKvy4BUJwkNtmdGQnMbv62tQBmCnflm3f1adt4E9i4AJ7JO5uJ/1ZECGUMIt
	eHIncRguz6og1RDlw8IR6qZo/3dMeEF7V3xRpjaJ1zTd/pQccTb58iZsz7AmpwRKz7s3pbGjnpa
	dPJ9etTKyAv3lF/a9M9bp66oxlyWFJ3H+Zy5z8L4qw9WQC4O9aAipoiv0Tr5yuYfOYy8/Mhn+WV
	gfmTtUMymuVJA2GmeEHrdgb0lPZnvxnilEqC6LNJgPmfO2ujv+mla8k+C1MTfxIDT8CnE=
X-Received: by 2002:a05:7022:f20b:b0:136:c443:80e5 with SMTP id a92af1059eb24-1ac56d94b0amr23659736c88.6.1793769114178;
        Tue, 03 Nov 2026 21:11:54 -0800 (PST)
X-Received: by 2002:a05:7022:f20b:b0:136:c443:80e5 with SMTP id a92af1059eb24-1ac56d94b0amr23659700c88.6.1793769113528;
        Tue, 03 Nov 2026 21:11:53 -0800 (PST)
Received: from hu-hprem-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c4f83fsm6354245c88.17.2026.11.03.21.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 21:11:52 -0800 (PST)
From: Harshitha Prem <harshitha.prem@oss.qualcomm.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Karthikeyan Kathirvel <karthikeyan.kathirvel@oss.qualcomm.com>,
        Suraj P Kizhakkethil <suraj.kizhakkethil@oss.qualcomm.com>,
        Harshitha Prem <harshitha.prem@oss.qualcomm.com>
Subject: [PATCH] iw: add support to parse UHR capabilities
Date: Wed,  4 Nov 2026 10:41:36 +0530
Message-Id: <20261104051136.2488188-1-harshitha.prem@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: QA_Sdo_XOlYrR7XXhRN96EqWaSEe0Q2i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMCBTYWx0ZWRfX2jz5seM4vmpT
 QmW0o3QNLdbWWfjRo4yYtMCUmx/Q4Up+AzjW/+CWbNC4ANVOnSa9V2hfvD3lTw1JfP9S1KVKapZ
 L/jRrHJRdaBSq/PrULIqqJnc0Z1Y2geoRMwv+3V/uELA12vimt/SEgnbN0r+G8iWNmqyXvECkiQ
 tWgngjSE9df53cVLxILEdz4O94drDZsUb8+k7p1SRYbD+W/5GE+2PxtK/KC0xKgltky5tTRmJfI
 Cem744VjdIRff1lRFzv83uvVYN5leB+JNI7oUppYwlF/7jU9HbY5m03DUnBBj70oK0JHW7XNiC7
 vdHOU729IzEMiw5SbhU3wn2qutsCO/1BZzpIitYwWr9oZ8InZdvI2EL6PhjF2qDXM/x1PFFjSlb
 SC62KfAD20KZy8+MM7gvRvYl+3MJFq1IFmdsuzqLi67jiIhLo6GFGSEXti45JrtMoMHJEFXyH6a
 a/ICxQUVy2S+T42j6RQ==
X-Proofpoint-ORIG-GUID: QA_Sdo_XOlYrR7XXhRN96EqWaSEe0Q2i
X-Authority-Analysis: v=2.4 cv=NMhAaE6g c=1 sm=1 tr=0 ts=6aeabe9b cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=PerXYD_Ts8haZnGGPK8A:9 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMCBTYWx0ZWRfXwXjXgvtsHaLt
 K9vLmw5gpN2359yKGegW9hxGeS1J5oEAMb21hfTbyPgeSCLuK/O6511kowk06EeXHkMZgAhJvhv
 FCveNxIyQDM4j8X4urtPxNT86hZClZ8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040020

From: Karthikeyan Kathirvel <karthikeyan.kathirvel@oss.qualcomm.com>

Parse and print the UHR capabilities advertised by the driver according
to IEEE P802.11bn/D2.1.

Example output from hwsim:
iw phy0 info
Wiphy phy0
        wiphy index: 0
        max # scan SSIDs: 255
        max scan IEs length: 2095 bytes
        ...
        Band 1:
                UHR Iftypes: managed, P2P-client
                        UHR MAC Capabilities (0x100400000000):
                                NPCA Supported
                                DBE Supported
                        UHR PHY Capabilities (0x4000000000):
                                ELR Tx Supported
                ...

                UHR Iftypes: AP, P2P-GO
                        UHR MAC Capabilities (0x100400000000):
                                NPCA Supported
                                DBE Supported
                        UHR PHY Capabilities (0xc000000000):
                                ELR Tx Supported
                                ELR Rx Supported
                ...

                UHR Iftypes: mesh point
                        UHR MAC Capabilities (0x100000000000):
                                NPCA Supported
                        UHR PHY Capabilities (0xc000000000):
                                ELR Tx Supported
                                ELR Rx Supported

Co-developed-by: Suraj P Kizhakkethil <suraj.kizhakkethil@oss.qualcomm.com>
Signed-off-by: Suraj P Kizhakkethil <suraj.kizhakkethil@oss.qualcomm.com>
Signed-off-by: Karthikeyan Kathirvel <karthikeyan.kathirvel@oss.qualcomm.com>
Signed-off-by: Harshitha Prem <harshitha.prem@oss.qualcomm.com>
---
 info.c |   1 +
 iw.h   |   1 +
 util.c | 137 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 139 insertions(+)

diff --git a/info.c b/info.c
index 1d123a2..6a9a436 100644
--- a/info.c
+++ b/info.c
@@ -475,6 +475,7 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 						    rem_band) {
 					print_he_info(nl_iftype);
 					print_eht_info(nl_iftype, last_band);
+					print_uhr_info(nl_iftype);
 				}
 			}
 			if (tb_band[NL80211_BAND_ATTR_FREQS]) {
diff --git a/iw.h b/iw.h
index 01ef365..93d4ea9 100644
--- a/iw.h
+++ b/iw.h
@@ -250,6 +250,7 @@ void print_eht_capability(const uint8_t *ie, int len, const uint8_t *he_cap,
 void print_multi_link(const uint8_t *ie, int len);
 void print_eht_operation(const uint8_t *ie, int len);
 void print_eht_info(struct nlattr *nl_iftype, int band);
+void print_uhr_info(struct nlattr *nl_iftype);
 void print_s1g_capability(const uint8_t *caps);
 
 char *channel_width_name(enum nl80211_chan_width width);
diff --git a/util.c b/util.c
index 11f8117..40403d0 100644
--- a/util.c
+++ b/util.c
@@ -1815,6 +1815,143 @@ void print_eht_info(struct nlattr *nl_iftype, int band)
 			 he_phy_cap, false, true);
 }
 
+static void __print_uhr_capa(const __u64 mac_cap,
+			     const __u64 phy_cap)
+{
+	const char *indent = "\t";
+	int i;
+
+	#define PRINT_UHR_CAP(_var, _bit, _str) \
+	do { \
+		if (le64toh(_var) & BIT(_bit)) \
+			printf("%s\t\t\t" _str "\n", indent); \
+	} while (0)
+
+	#define PRINT_UHR_CAP_MASK(_var, _shift, _mask, _str) \
+	do { \
+		if ((le64toh(_var) >> _shift) & _mask) \
+			printf("%s\t\t\t" _str ": %llu\n", indent, \
+			       (unsigned long long)((le64toh(_var) >> _shift) & _mask)); \
+	} while (0)
+
+	#define PRINT_UHR_MAC_CAP(...) PRINT_UHR_CAP(mac_cap, __VA_ARGS__)
+	#define PRINT_UHR_PHY_CAP(...) PRINT_UHR_CAP(phy_cap, __VA_ARGS__)
+	#define PRINT_UHR_MAC_CAP_MASK(...) PRINT_UHR_CAP_MASK(mac_cap, __VA_ARGS__)
+	#define PRINT_UHR_PHY_CAP_MASK(...) PRINT_UHR_CAP_MASK(phy_cap, __VA_ARGS__)
+
+	printf("%s\t\tUHR MAC Capabilities (0x", indent);
+	for (i = 0; i < 6; i++)
+		printf("%02x", ((__u8 *)&mac_cap)[i]);
+	printf("):\n");
+
+	PRINT_UHR_MAC_CAP(0, "DPS Supported");
+	PRINT_UHR_MAC_CAP(1, "DPS Assisting Supported");
+	PRINT_UHR_MAC_CAP(2, "DPS Static HCM Supported");
+	PRINT_UHR_MAC_CAP(4, "NPCA Supported");
+	PRINT_UHR_MAC_CAP(5, "Enhanced BSR Supported");
+	PRINT_UHR_MAC_CAP(6, "Additional Mapped TID Supported");
+	PRINT_UHR_MAC_CAP(7, "EOTSP Supported");
+	PRINT_UHR_MAC_CAP(8, "DSO Supported");
+	PRINT_UHR_MAC_CAP(9, "P-EDCA Supported");
+	PRINT_UHR_MAC_CAP(10, "DBE Supported");
+	PRINT_UHR_MAC_CAP(11, "UL LLI Supported");
+	PRINT_UHR_MAC_CAP(12, "P2P LLI Supported");
+	PRINT_UHR_MAC_CAP(13, "PUO Supported");
+	PRINT_UHR_MAC_CAP(14, "AP PUO Supported");
+	PRINT_UHR_MAC_CAP(15, "DUO Supported");
+	PRINT_UHR_MAC_CAP(16, "OM Ctrl UL MU Data Disable RX Supported");
+	PRINT_UHR_MAC_CAP(17, "AOM Supported");
+	PRINT_UHR_MAC_CAP(18, "IFCS Location Supported");
+	PRINT_UHR_MAC_CAP(19, "UHR TRS Supported");
+	PRINT_UHR_MAC_CAP(20, "TXSPG Supported");
+	PRINT_UHR_MAC_CAP(21, "TXOP Return Supported in TXSPG");
+	PRINT_UHR_MAC_CAP_MASK(22, 0xf, "UHR Oper Mode and Param Update Timeout");
+	PRINT_UHR_MAC_CAP_MASK(26, 0x1f, "Param Update Adv Notification interval");
+	PRINT_UHR_MAC_CAP_MASK(31, 0x1f, "Update Indication in TIM interval");
+	PRINT_UHR_MAC_CAP(36, "Bounded ESS");
+	PRINT_UHR_MAC_CAP(37, "BTM Assurance");
+	PRINT_UHR_MAC_CAP(38, "Co-BF Supported");
+	PRINT_UHR_MAC_CAP(39, "Co-SR Supported");
+	PRINT_UHR_MAC_CAP(40, "MAPC Enhanced Measurement Supported");
+	PRINT_UHR_MAC_CAP(41, "HG RTWT Supported");
+	PRINT_UHR_MAC_CAP(42, "Extended Channel Usage Supported");
+	PRINT_UHR_MAC_CAP_MASK(43, 0x7, "Post Update Notification interval");
+
+	printf("%s\t\tUHR PHY Capabilities: (0x", indent);
+	for (i = 0; i < 5; i++)
+		printf("%02x", ((__u8 *)&phy_cap)[i]);
+	printf("):\n");
+
+	PRINT_UHR_PHY_CAP(0, "Max Nss Rx for NDP sounding (<= 80 MHz)");
+	PRINT_UHR_PHY_CAP(1, "Max Nss,total Rx for DL MUMIMO (<= 80 MHz)");
+	PRINT_UHR_PHY_CAP(2, "Max Nss Rx for NDP sounding (= 160 MHz)");
+	PRINT_UHR_PHY_CAP(3, "Max Nss,total Rx for DL MUMIMO (= 160 MHz)");
+	PRINT_UHR_PHY_CAP(4, "Max Nss Rx for NDP sounding (= 320 MHz)");
+	PRINT_UHR_PHY_CAP(5, "Max Nss,total Rx for DL MU-MIMO (= 320 MHz)");
+	PRINT_UHR_PHY_CAP(6, "ELR Tx Supported");
+	PRINT_UHR_PHY_CAP(7, "ELR Rx Supported");
+	PRINT_UHR_PHY_CAP(8, "Partial BW DL-MUMIMO Supported");
+	PRINT_UHR_PHY_CAP(9, "Partial BW UL-MUMIMO Supported");
+	PRINT_UHR_PHY_CAP(10, "MCS 15 Supported");
+	PRINT_UHR_PHY_CAP(11, "2xLDPC Tx Supported");
+	PRINT_UHR_PHY_CAP(12, "2xLDPC Rx Supported");
+	PRINT_UHR_PHY_CAP_MASK(13, 0x3, "UEQM Tx Supported and max NSS Tx");
+	PRINT_UHR_PHY_CAP_MASK(15, 0x3, "UEQM Rx Supported and max NSS Rx");
+	PRINT_UHR_PHY_CAP(18, "Co-BF Joint Sounding Supported");
+	PRINT_UHR_PHY_CAP(19, "IM Tx Supported");
+	PRINT_UHR_PHY_CAP(20, "IM Rx Supported");
+	PRINT_UHR_PHY_CAP(21, "Co-SR Mode 1 Supported");
+	PRINT_UHR_PHY_CAP(22, "Co-SR Mode 2 Supported");
+	PRINT_UHR_PHY_CAP(23, "DRU DBW=20 in PBW=20 MHz Supported");
+	PRINT_UHR_PHY_CAP(24, "DRU DBW=40 in PBW=40 MHz Supported");
+	PRINT_UHR_PHY_CAP(25, "DRU DBW=80 in PBW=80 MHz Supported");
+	PRINT_UHR_PHY_CAP(26, "DRU DBW=80 in PBW=160 MHz Supported");
+	PRINT_UHR_PHY_CAP(27, "DRU DBW=80 in PBW=320 MHz Supported");
+	PRINT_UHR_PHY_CAP(28, "DRU DBW=20 in PBW>=80 MHz Supported");
+	PRINT_UHR_PHY_CAP(29, "DRU DBW=40 in PBW>=80 MHz Supported");
+	PRINT_UHR_PHY_CAP(30, "DRU DBW=60 in PBW>=80 MHz Supported");
+	PRINT_UHR_PHY_CAP(31, "DRU+RRU Hybrid mode Supported");
+}
+
+void print_uhr_info(struct nlattr *nl_iftype)
+{
+	struct nlattr *tb[NL80211_BAND_IFTYPE_ATTR_MAX + 1];
+	__u64 mac_cap = 0;
+	__u64 phy_cap = 0;
+	size_t len;
+
+	nla_parse(tb, NL80211_BAND_IFTYPE_ATTR_MAX,
+		  nla_data(nl_iftype), nla_len(nl_iftype), NULL);
+
+	if (!tb[NL80211_BAND_IFTYPE_ATTR_IFTYPES] ||
+	    !tb[NL80211_BAND_IFTYPE_ATTR_UHR_CAP_MAC])
+		return;
+
+	printf("\t\tUHR Iftypes: ");
+	print_iftype_line(tb[NL80211_BAND_IFTYPE_ATTR_IFTYPES]);
+	printf("\n");
+
+	len = nla_len(tb[NL80211_BAND_IFTYPE_ATTR_UHR_CAP_MAC]);
+	if (len > sizeof(mac_cap))
+		len = sizeof(mac_cap);
+	memcpy(&mac_cap,
+	       nla_data(tb[NL80211_BAND_IFTYPE_ATTR_UHR_CAP_MAC]),
+	       len);
+
+	if (tb[NL80211_BAND_IFTYPE_ATTR_UHR_CAP_PHY]) {
+		len = nla_len(tb[NL80211_BAND_IFTYPE_ATTR_UHR_CAP_PHY]);
+
+		if (len > sizeof(phy_cap))
+			len = sizeof(phy_cap);
+
+		memcpy(&phy_cap,
+		       nla_data(tb[NL80211_BAND_IFTYPE_ATTR_UHR_CAP_PHY]),
+		       len);
+	}
+
+	__print_uhr_capa(mac_cap, phy_cap);
+}
+
 void print_eht_capability(const uint8_t *ie, int len, const uint8_t *he_cap,
 			  bool from_ap)
 {

base-commit: e86c54660e67af2382cb15ee21fa756cf5206c4e
-- 
2.34.1

