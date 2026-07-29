Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C593AAF7C
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338791; cv=none; b=BP7KPp8sRNb5iKSCD4xpg+dKxMm5gYXOEualq5Qpt3J7HGeaJtsJQhzGaEdd7I3scZ/F2KrTgUFR07k9VSJiRus72fHK6G90cMlu+KAPRZ5LyoiDNn3S06zuR+2DEZUOu1Xqlbx3ak/6pGc2xAQJKcZoNOa65NUZSQOsDiOazwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338791; c=relaxed/simple;
	bh=GwDBM9yinHi98jy8aq34Y+BliW9ODoMllpMzxhxbsR8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=eoXHuAd4UO5AiHqWxyp7U44tH9x8YbKDxxTwUPWISAIJxggl5NrEJN8iexocCVag/PccryrHvpKQqGUTuE7ui1wFGBzTxhP5orRmOvJpsx+IZLllnknQ0etm87ESQykPKedqYxvx6NcacDOuhfCe3VnAy5bXKp7/L3xpuqtDspk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WWHVAYtI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eYtsXCLn; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WWHVAYtI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eYtsXCLn"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TF3HVC1700613
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:26:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=MZOKf9mSd0crSLc2wh8F4z
	MblAYXsOwHLgHJ66RKogc=; b=WWHVAYtI7Uwd+Fy9wUpZL1r1ds+B76Az7q4TAg
	+9SdFtxrg3CXrmgqHCJSKbx61Me8KnnvZEqNrB0QGChJrnvP0FsHiIn1du0qiS4c
	wi3X0AJk5Jwx7sCFRU/t1EYIPEJBoT4hejObiIh5wKvgfTkZ8XRacUlXkk30nb3t
	0/DM01hyOnOZNzqeoc8yaRNpzxAAQnqtEvprrbP/wekbk1wJ2P6VKjrnPISHqTNO
	CAWzwnXdnYVFX4DDyJA03NKK5jBT0Pi63owkwkQLcysOklLvmCTs3Q6V9VjTOsjy
	/UHmO0bewUemU7A3tQtlnzROL/XD7Kk2hdEe5RTMakpDwkIw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqgrj1405-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:26:28 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbb92868263so1294505a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785338788; x=1785943588; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MZOKf9mSd0crSLc2wh8F4zMblAYXsOwHLgHJ66RKogc=;
        b=eYtsXCLnT/RFW1sCa9Nv1ScSv8Kud/bVgg4812/qDd4zhuD0rjiU2HINg4EOa58zsT
         8XjbdrIx7y5gmTjZEwW/jf2WCcsR7S176Dy7eYaIW1n2LnE3+QQ8HtTBJ/QSXk6EMfxo
         I+0OLE2jce6OAJO8tQ7pjvUw6qJgKwQge+u4F5hWPhyREjnG0v/pGQPWJDKYTbRKflhm
         lKxg4EtQZmmMHsKcwSR/svr1CizmYUMWCu7JUsZW/MFheuoDFocH7S7HK4KFdPuppZnR
         c8b6AXX04OVoya1NqdH+Udfg2qb7naAwA/K23mXuBTDJhMqG7z3OyNdbRAbK9+FI+3of
         wiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785338788; x=1785943588;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MZOKf9mSd0crSLc2wh8F4zMblAYXsOwHLgHJ66RKogc=;
        b=UJbklbT4cRE0v37MNjvJpnyE0a2a5HgDo85E2XZyo3LV7/mwLcqVkGsG0YOlTJalJq
         FLfwYexfJloo8+mXankNKj+2SAe+NLupwuoGsS0j+spy2VqSfBKTMSpPE3xNdVrNoHk4
         R4RyyfaFkGPrmCIPq2aX0i4SAP+jICXdz/rGL/c52koCm8BBDNCp2SFrZquNJcnhfiUD
         uw77Q3923XiKytSgcRU8vF+CHDfUR12TrEPXxoqYWCo/A9KEwdlNpcqYqh+IGBTkNy/f
         XHEOfXhjAQ9yDMHm8NTd2IYQ/o6cdexV4w6QhUgVBZLXqLx/eftO2DzlyhsKsJGDJrid
         FwzQ==
X-Forwarded-Encrypted: i=1; AHgh+RoRJEn9+NEeX1hIIicd+WlCccSpusjf54eFi+qCebuMreEihlIt7j4VfXWY94DKtLJUskUcpSAVswVZi6umIg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEL7SfmX7oVJL8KQijRLMJRvE/l/4KvfbehMzqdODI+LoRq87j
	wdT+QYGxhLtWZX7wlKc1iVghMNF4jMSFZwxYomSMEZD8ExXitctfHR6ionWPCZfCTjt5pNhshQ6
	O+khU5PdYaSb1nvC/rv4YpCJ8YjKvcjy4GMXuoDfJdWVExkGTZLwEErVhFFWOcHfFSCgk/w==
X-Gm-Gg: AR+sD12boEizLLhUAhV37LtlVLVYC91UsL2AGl6+LAvDEYQLl4Ew+wQKbnzvL5nITw5
	7XnG2Qn7fgEXfEmyqjXYwXAAy0Gh6KhLavKuwhWcdJ/KId6xneajh4fZPCPzkAQ9HJeid8At6hw
	zsbZ6V4vF9zEFrEZWsnDO4wI/qrOHZGM/4+fk37WKbg2yRapVph+XPF+xKBHz/l7nL6gmW/oMJ8
	am8/eMGF2leV0XkAvLGt5j9stQVbmgrs78jDuuszw88vRKOQcDTxfmExY10oZU0zs4jR0hsS8zA
	oleMwSVcT/rMTX+Ir+2rNnLRevMswfKhLSUSYNxUGQQ79n3iWyJy/NdttFc7hfvYvm4BsZfTo5+
	ycPL9ACGSFydQBqO6tbDIID0hchxCi7ZyAhtepytaW0oaHV+QSdLwjyw=
X-Received: by 2002:a05:6a20:cf86:b0:3c3:875d:704d with SMTP id adf61e73a8af0-3c8ba458430mr8314530637.25.1785338788346;
        Wed, 29 Jul 2026 08:26:28 -0700 (PDT)
X-Received: by 2002:a05:6a20:cf86:b0:3c3:875d:704d with SMTP id adf61e73a8af0-3c8ba458430mr8314481637.25.1785338787817;
        Wed, 29 Jul 2026 08:26:27 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504d480c5sm18005300eec.25.2026.07.29.08.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:26:26 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH ath-next 0/2] wifi: ath: fix stride mismatch in
 mac_phy_caps_parse
Date: Wed, 29 Jul 2026 08:26:24 -0700
Message-Id: <20260729-mac_phy_caps_parse-stride-mismatch-v1-0-077a1a0c50d8@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKAbamoC/5WNyw6CMBREf4V0bUmp4eXK/zCEXNuLbWIBeyuBE
 P7dSty50c0kk8mcszJCb5HYKVmZx8mSHfpYskPClIH+htzq2JkUshClFNyBakeztApGakfwhJy
 Ctxq5s+QgKMOxlLXMK9HFA4ug0WNn511yYRAM73EOrImLsRQGv+z2Kdv3f0RTxgUvtQA4dljku
 j4PROnjCXc1OJfGeOs/xOpnoiyhVllkXrX4Jjbbtr0AXI/Q4TcBAAA=
X-Change-ID: 20260720-mac_phy_caps_parse-stride-mismatch-e7292580f072
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=RJOD2Yi+ c=1 sm=1 tr=0 ts=6a6a1ba4 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=rUlN9L5Rg0sLS0zbAgQA:9 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: 1VvLqQkSERIvXQAEFNyFA8cL5ENly80R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyNCBTYWx0ZWRfX/S7t3G7ckUZp
 mX2ZXPtw5N1QOfg8Ex6tqibZpvayaJiWu38IvNed5UiQBqtcO1P4UOk+VHFCu+sym3M8gfNrB7d
 dl6eH7T2M2tvRYVotTlZWgAkO8eroYopoCwLEs0G+E4NNh3O5FxPcdT4re9wNs/sRDYniYO2hMn
 RRwLPtesw4y1EgNx0faL3ntCLcIqCs5U6mmxwoehoMH1iC75erB93/Q2BUyA/M6cTCHDiQ/QWIE
 BHJrV/+NuDhyxce5pKE04Vr39RokrZsTWMGlMFltWlmjGFi9wwtDuSUoaeLwgE8PDtHgwUYTtvZ
 PKW7QUle3Z5NLrnOOLzOnMArE7EgPxH/5Bi+vBh9T+7EPwpnfXF3OGcP1iew3AQsDc3+FdO8Aco
 bdd37Ju/0tRWOKo9kLo8FBniXD6SDEpbbxLcadkTUfvMwMMRxGWwohBbW0SI9uf5BjhZ0jTHASZ
 twQdA7fY495UivBPSHw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyNCBTYWx0ZWRfX/EcpR7Ye3ELX
 lbM/dFmGmUmv16/6VTGCR1vNUQzehn/mVQlMH/a6oYhljViil1Wdt6JbbSjPHxfBQhFB+8OiZyL
 Px2Yggw3yDuytXHowxI2XVm56PsXCes=
X-Proofpoint-GUID: 1VvLqQkSERIvXQAEFNyFA8cL5ENly80R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 clxscore=1015 spamscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290124

Both ath11k and ath12k have the same issue.

---
Jeff Johnson (2):
      wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()
      wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()

 drivers/net/wireless/ath/ath11k/wmi.c | 8 +++++---
 drivers/net/wireless/ath/ath12k/wmi.c | 8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)
---
base-commit: 189721a4afa1804315e7dcfca9ca0539c7b1d7af
change-id: 20260720-mac_phy_caps_parse-stride-mismatch-e7292580f072

