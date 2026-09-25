Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E5C4CE673
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790350030; cv=none; b=cl4O68YjkZ1sMYh5OS9bGj2jkcC0jlVCH568NCyNGOiDgkE4OHOI1fvIdpu5FTkTNXLUvRlaicykA/O9Svs2E1dl7ldlvsLs9RU/8LGTVA5QRaocnXPt0wkS5+mv0IRRVNuh4VYjrPTTKxPkpUilvZNcIIFBf+3476xx6GH+gPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790350030; c=relaxed/simple;
	bh=88fw7iJos8gl+/ykF7/u7V012fJr3cbcDhXjw84RwD0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=PB+zN6VSs0hVAbhyLVdZ4YaKj3aP0rGj3fa1rv3y/b8mnimLQegRR7F7l0v9jrKPCYaSSRNxPjM5ylV2avr9qihYJMQY/30/7Fv/v21E+VDOhyVjP/m2rmaECZ3z9JYurLfl/Y4e2fKWyNRIlbAU0PBS6Mq3AqpLMWN0h9cMUpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f6453Ff1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CTTA3u+V; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f6453Ff1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CTTA3u+V"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68PE10K1756987
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VVpWonJbCGUCtyHw5W7lMG3ggcOqOkfVrR7xlm3pac8=; b=f6453Ff1aZC40vNs
	VFScrSZuhcDl/ZZE7NguzvQw2I+AIiuQQ2yPW9L466oWXxZGBtfxzAanT8H/R5Gj
	RiexwdEADuwhn0EvCTOi3D2nRCgiB9ZqsNphCvE1hNIA+0uW++CWJWHi80GmpdeC
	fJqUzP0or26yFDpddqUiA9l3QekUFDvDVbd/YdaVFrZuf7z1jlqpshbKFNE8Fh/P
	Tjf4fUuBEZgsJc7OioRU3QIUVVsdYxrkoJPv/ACHn+hF+lC9BW9Ka9e5vHi0jw/w
	EJlrnnlz9LZMr+Gwhu40xLPGcwcmbtxNaYjwQi9QqTKVz2YDh5eV+R3Vpz+i1+XB
	4GF+Ag==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gwjq09xrd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 15:27:07 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39e3f521346so1128649a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 08:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790350026; x=1790954826; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VVpWonJbCGUCtyHw5W7lMG3ggcOqOkfVrR7xlm3pac8=;
        b=CTTA3u+V3QOBcn2iPRlVNTTeYylf3sctfEI3B6guOQFsA74tVudQ2brLVUDYIEGB5O
         Upv4zF7qMDC6mEt5YuAbKeLoWjAEi2Q1D0JLB+umc0c/N82ry7FmlUizo0JVWccdq+Su
         WoQ9jge4AKWRqGO9jeuRSlHLhqnM7faSR9KqSbxIwyyv399SwMu5FOhOjCTaMSlKFqPh
         HqAO3tPdp8wmvFG+Te2AZIhk6Ck0V+DKgDoJ+CA7z0WKg6ALCps4YtPQnlO1XIicXpIC
         Ne6+7y9asAc1Xo2FbMtLFVCDmeb+uoQZ5YoaV+XIkX/gH/PJRfKW68cnhweMECfrUIb6
         rGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790350026; x=1790954826;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VVpWonJbCGUCtyHw5W7lMG3ggcOqOkfVrR7xlm3pac8=;
        b=U0HYGgzxxqkkHU0kA14cwyGKmxOSyQvTfs1wQ6mcfstCeI+TqCFZ9i9SWjCSegmWJl
         2jbIH7LGI5y/iIYtljuCwBoZg1Wp0vbitOszGb/l8jLm03/S/oDVK1/KgSGu0GrSACLX
         VUVODkORm4vNhRrczTUpLlHRFkXTr4kEMW/5cTJ6/LwF0eDhs2xPbV6FT53vXmXKX5WU
         hQcCOJ7v8eONUETbp+FA8YwghwrFs+QyMto6TP1cfzGHrZ6YnuHv6nGMhw98jIyxRBJe
         iAhAnVylaEh+G3V3PgmjSIQSHK3BP+NzBs+HjmFiNeDXKy5hLa46HDALa+lsTyzWyj9d
         OShQ==
X-Gm-Message-State: AFuF++n9mScOc4A1Jqq3oZeUAKkxxrA/hTnsxFJjv71FebQiaoD4AZOM
	Azob+T6A8EgVaIfa6Dn3Mdy3lEb6+9sAlsQ/XqRVy5LuLCspsUehnj0l000iCGMAjb55UIYY70v
	6YxENHebwFv2/FWK7sdQ3+/SpN7wJlePUTBfN1DhQowcruDkP3Ty3Go1px1NceBEcbtR6Xg==
X-Gm-Gg: AYBFou1paPUodcgvpO1rvSS48j1S4mYmif9WHpwg//RDbz2RrkH/ZO6uB+HAdiF5Hv9
	Xwxb00vOxug8r7R/vJCoBxH7Aqb1fSJYTUfqzbIN3szp64EWzSnzj03UaWewNNEEQjMR9ofcKix
	xeBM9c3cQBPOOqSsvHueN3a+u2hAk2Eswh5kNzvt04FBqm9uXmWgZyP5tMYPSPxefE37+qYahBr
	/tQLuWEkl1hex3vx0OlSEm3KPSoq+e7KdxrlE45UxH5StDvGIlr4vCd2pTD4IaoPUMfoFqRhLEd
	6ueH6KUv2uCoJPk1upznpnaMgOjmbbhR2bW2UNOwSqHK9jcHYdZoqlrf2FX3X0CQDxNKPY5jvZB
	bSBaxku46sowqKcDuujwV15yNs3r+9Ez9RIZV5tXMoxI0+NeNYvCuW7c=
X-Received: by 2002:a17:90b:39c7:b0:3a0:d5dd:6093 with SMTP id 98e67ed59e1d1-3a0d5dd7046mr246871a91.53.1790350025961;
        Fri, 25 Sep 2026 08:27:05 -0700 (PDT)
X-Received: by 2002:a17:90b:39c7:b0:3a0:d5dd:6093 with SMTP id 98e67ed59e1d1-3a0d5dd7046mr246651a91.53.1790350020692;
        Fri, 25 Sep 2026 08:27:00 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b898cabesm5320405a91.0.2026.09.25.08.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 08:26:59 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath12k@lists.infradead.org, Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
References: <20260819053247.1420393-1-pardeep.kaur@oss.qualcomm.com>
Subject: Re: [PATCH ath-next v4 0/8] wifi: ath12k: extend device DP stats
 for TX and RX observability
Message-Id: <179035001887.3875741.5463308542532617988.b4-ty@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 08:26:58 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfX+mUWfzDaENKX
 pQDn7iu2xWqAvjKZvYaFPjxS8TnjwBN0Z7/kncLR4BU4yolRvb1Brqnqw4TzKiJur1rpjoWqznt
 4kHwYbSh9CiQXESXFbkCionOXU3XeJ4=
X-Proofpoint-GUID: ZVnr9NoPY_J95kXeoavuK1cFy98e76Nw
X-Proofpoint-ORIG-GUID: ZVnr9NoPY_J95kXeoavuK1cFy98e76Nw
X-Authority-Analysis: v=2.4 cv=LNPz05W9 c=1 sm=1 tr=0 ts=6ab692cb cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=a-3tiwmhLL6f-xxmbPIA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA2MSBTYWx0ZWRfXxI/a7QL6mYCh
 uBuuDyzkPz8pjQ7nYxWNf6bO7iWzojtiZZe3h5Bq+RQxeIFOmkUV3VokEROmdJ0JrM/8f7bsz+d
 URJvE5KS32vfth1v4+dgXHF/bJDm3svIsq7BQ8r30X9z42NlL8gqflm8bGd3YJQTEJLIscSNZaT
 2KlHXKYvaTC5mh1oy+fHf0nwZ+I9q4wQ+OG5y40Rpo5vgNibtwPbhMp4l7qEM4PSiH2Qh2FUJAR
 Aps3U7/hPfnZkLt3Ka8x7nh0nrH5CqFaArpugTFa2hY/7fR8/GwN2/i37B7l2+bRw4njlCkDBXg
 hFgOsorxCtXB+u+QLyeDxMUep/fBqSNqTMxbIfuOJ/pGdP6SilsX7tEEAxfJ88J8Eu3vD0b6GE7
 91XFyx8jY67KWMc+e+DmTtNoYqNS+v7c2+Ine5HJA0e1ngM4wZwpxvUDY2epWgpmi1NxyMpKf1p
 tvPcffEU9Zq/J0qOsaA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250061


On Wed, 19 Aug 2026 11:02:39 +0530, Pardeep Kaur wrote:
> From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
> 
> Extend ath12k device DP stats for TX and RX path observability.
> 
> Patch 1 fixes out-of-bounds array access on TX stats arrays
> fw_tx_status[], tx_wbm_rel_source[] and tqm_rel_reason[] by adding
> likely() bounds checks before each increment. The default: case of the
> switch statement that follows already handles unknown values with
> ath12k_warn(), so no WARN_ON_ONCE is added for fw_tx_status to avoid
> double-warning on an out-of-range htt_status value.
> 
> [...]

Applied, thanks!

[1/8] wifi: ath12k: fix out-of-bounds access on TX stats arrays
      commit: c8f83d3389d1d1b318ac3bd2ae3d60c2862c90b4
[2/8] wifi: ath12k: rename wbm_status to htt_status in HTT TX completion
      commit: 90396f4a01fe2e14c2a31540a73fde4c7c1cc8d5
[3/8] wifi: ath12k: add TCL ring TX buffer allocation failure counter
      commit: 6fec999446d926e1f5d2c0efc306134f64f29686
[4/8] wifi: ath12k: add device DP stats reset support via debugfs
      commit: 26e095b0801ab6d24cf20b37eb377bae3ff39715
[5/8] wifi: ath12k: add WBM RX error drop statistics
      commit: 0f4f1fe45e4b49311e9cd0fffdd3290f57b5afe1
[6/8] wifi: ath12k: track per-ring RX sent-to-stack count
      commit: 7acba3c0a67cbe65d9bca8437e01065e778ebf8c
[7/8] wifi: ath12k: fix 1-based ring index in REO Rx Received debugfs output
      commit: 640240adbde5ecbbbc5afab5d72d89d7dd68347f
[8/8] wifi: ath12k: add WBM SW desc fallback counter
      commit: 8637c54300cf71fb7e0f8f402b4393e0b73d0a11

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

