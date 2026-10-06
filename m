Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01D546E010
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 14:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791296135; cv=none; b=YML3M4qc0P4aYlNvIRFCCt65AcfVbKzwqhWk3L7Bos3E+OQ1BTIVMnQrkpngtZePZPTMPtFs5BausaZrrW/NdIUNLaOjENznyXSgHpyJB4c21ocvCxPVhgs5X9Y902e1QcxBHZcIroN1ebRUisOyUz8DqjIUjHk69aUIgtrtiTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791296135; c=relaxed/simple;
	bh=tssA7wlsULnxstavmGuQat3Ef8F9CK6+0LwXkDkeibE=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=JfKdaV7bLTDfDAp1ZnV+B+HAvUZT9d0H9oRad2ZbgP51f78Ow6yk64StENO0DX2ZjnID9JPSXxRLcAWrxncwUb868p5BcI8RS0j1n4jbzTTWl0cKFf9dr1dpysyUbhwNhiUI5aB7hEo+dFMXgMQ0Gu4WNEgD66tXuJDXmPyCvFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jXgiq5sy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V2G7O8dq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jXgiq5sy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V2G7O8dq"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696EB31R893891
	for <linux-wireless@vger.kernel.org>; Tue, 6 Oct 2026 14:15:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=9VpjXu4u++QS3E8EyJb2g7
	cB91QeLt7IH+hYNOWUP9A=; b=jXgiq5syPqWR17xoDARptpVKQuXWkUINiWZ72i
	Lze+1gDJRFXKWKPJMktJRwN1R/lIWfOomxkU1w8FcAo4gJOh/jpdJdk64sg0Uvzm
	3J0CeX7Cf6RENPiRCunFFYIfX3ipxUo1pS9fgM/Dff86kW0rpAvIAe1bOrBYkYFw
	NUh4JMBpDlNV6pAM3EF14O0VkOAs5QM1kgOWj5fG44dG9EgdWSUghlsvMAqBbDAF
	3BhenvodscstAiaew/DEfm03CB7XTfY2AyUx20dxrZrVCIcWznzmr7wkbkHFWTYA
	aYAC19u3vvpwXiNXyHS9Ez+51YOoJNlgEZ2z8RsaLXNqsY7w==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4gr0bxg3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 14:15:32 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-88a46301d92so2404115b3a.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 07:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791296131; x=1791900931; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9VpjXu4u++QS3E8EyJb2g7cB91QeLt7IH+hYNOWUP9A=;
        b=V2G7O8dq+pHLIUwA7HRt48C7l1f6exsKSejKw06jAgcRgMu7stbDmMpYnoJSXhoaRi
         nSx0YkcjaG/07/oghJ5tvNZ5DPWJ6gjOA40JNco9IBm5GKvs45APgOfX9po9d9aL3f0v
         M7KpR2n5SiwsQLEIynuWfljagQnwqj37H6PROq3p5dlTb7LcL0fnnU1SRQ/Dmb67iNZI
         8p35ncFEtbU/JKf2RgPuVhrd/fonpvbM0lvHuz/pgzKtGa6Cfzj9Cnrq9+kfcuVp1eh5
         e4pK3Kz7qjtbLuj1GT/4C7Qcl5U78lU9gn5KnH/jvSGAeede5fdqO3hi6zHXm8KOnkRU
         e4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791296131; x=1791900931;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9VpjXu4u++QS3E8EyJb2g7cB91QeLt7IH+hYNOWUP9A=;
        b=2SnHt2RlqlOOmCZkaBJV/M6Nrj4vf+m/egQ9EeoZxKRa1tX50qScKRT8/ni2aURFHa
         9sziFpx+3C5+W25AWYq3fX1O9iTOpSVGuODMwy/bjtL95lb8cI7lO7WPT/qrPco8Pg8K
         k3W/Ww4BJD81khSLHjWwTz09tQTgAcPuOTr95iywNWJ0Gr+n7nZJTiCfpow3WrTmVQkP
         FCE/kX1+eOwG7APPewDgqIjSAFTWp5FgW83ICy7tI3i7c/S5csWUqIIsgY3/5D9g0n/0
         reTjdSjRnm6e8BlSszqm2lZBny5en0vsND8fVts+1OKV6pwc8n6Ug82uCLWRql5PbCqF
         N1GA==
X-Gm-Message-State: AFuF++ktYBq61099dBmcj9W53B7twzUP+TvUKr/n+CLZCnvNvpKt8bxb
	UDit/v0dlimPzBXPiZNC0afCAQZ10ONQZazGt5M2Np8cMPD8hrxlcsAdVMaovN60avFJjfjewV+
	uwuD30eCpYzsjBq0U7uo+ViZU+FOaJ7LwBdQ6JloLfSDR+UYBU6bGzth766koXuCHwqsw8PU20U
	9WwA==
X-Gm-Gg: AYBFou1n35QvT/SC4sL9q2IXO138ZG4CbhFOzaWvXQ59iYfG6WYUkaw+lAPhgbTHn5W
	q8uKQdkvreHt5Txl/C2SKMLUA9iF0/6XOy3JJEi0HXpqrRIzQtL+ha/M+ceCwqQCYGQZm9XKfcz
	EcfbGzASYWTSyxZI9orUutMFKZOwEhZ25esKJgKf9UcpMqbuTvH8KAB8mINqUaKgj5RHxFI1ZWN
	41M8rh9O09j8Xqvf6RjtsCWrGeSPQvNqBsA828XPHU5Qc9+UVzb7beuagf1dDfGKDJcDMm4s6W7
	9v3eHfFIiM8sd9jhJNlPPYB8FcVHldskpdZOe+XeFDAqcdjUDo++QPEdEo0PyvEY18gZggln4Rg
	bLsvHrykLKnxZEsiWu1odFnhUwx8mSqIDudxa
X-Received: by 2002:a05:6a00:c50f:b0:891:3e34:e07e with SMTP id d2e1a72fcca58-8913e34e55bmr360940b3a.34.1791296131169;
        Tue, 06 Oct 2026 07:15:31 -0700 (PDT)
X-Received: by 2002:a05:6a00:c50f:b0:891:3e34:e07e with SMTP id d2e1a72fcca58-8913e34e55bmr360919b3a.34.1791296130606;
        Tue, 06 Oct 2026 07:15:30 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88b0c1b1dfbsm5131184b3a.26.2026.10.06.07.15.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2026 07:15:30 -0700 (PDT)
Message-ID: <dfb5d597-f2cd-4ce1-8eac-2c2b74dc25f7@oss.qualcomm.com>
Date: Tue, 6 Oct 2026 07:15:28 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, jjohnson@kernel.org
Subject: pull-request: ath-current-20261006
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDA1NiBTYWx0ZWRfX8NGCoujUEAIF
 3PkFMja5nBE3zZJDX0KU1ZkyO96QxY+BMVuMO/PDU8zfyCJSRAfmLXlNiAE+F5fnv5uaEX2txpQ
 7zlPxLTpgjWqTnmBivMfsjzHUvfZY/+XuCB/qKRhkPxme9P39Cbz8gcA2kPYiH+EE9a6vALuSfI
 NhmhWtDSs2rgpGIXLTVkCWwEC1phumlL3ocwzHRL6iQsxlVmoqRvZoCv4Sp6ZtU6Nj5eLt8UgJe
 Vq9Tsqg8FJZbxEQN6wKeBHD9jaxvZV86PGUGoQ33MBBJgIQ2MYtaB2mylUx22W2frIt9/n0CCyj
 VIHHlhGb68FH/5ljCJIruqsrSx3JHNbTlG+jEo6BqnY2fjklxVz0AHnpjOUMIQcIenTKtlYkiMm
 wOpOsVWm3fvObkVFCQ/cuOhikQDpgFJSqnONYvt61472bJBwb2kFT4oztoKy3win6wsdQYhajzM
 9PZxdMJkDePNkmo5phg==
X-Proofpoint-GUID: 7fUfiHszSgefqIL8yL5nVdMDDPbcaYkX
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDA1NiBTYWx0ZWRfX0PNXl7SGEPUQ
 1pNgrj0JB5fX2YsMsu4PqlYgu9oFonfPte3xx/NfFgGDoamhIRno1jb/7ZBXjEP4R5J5UlM/5i3
 BKGHpSm5GHVw2SiGF6dfO7GjudzReiE=
X-Proofpoint-ORIG-GUID: 7fUfiHszSgefqIL8yL5nVdMDDPbcaYkX
X-Authority-Analysis: v=2.4 cv=BrQIUoX5 c=1 sm=1 tr=0 ts=6ac50284 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=6eATFoqnGXLanKaFIDIA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_04,2026-10-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610060056

The following changes since commit d24e8ac715de2e16a53c144005b1863660a5fbea:

  Merge tag 'net-7.3-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-10-01 06:41:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git tags/ath-current-20261006

for you to fetch changes up to 05165f7b3b9ab6817fe216c24f90755b7c5e15f3:

  Revert "wifi: ath12k: add panic handler" (2026-10-06 06:42:17 -0700)

----------------------------------------------------------------
ath.git update for v7.3-rc7

In ath12k, revert the panic handler that landed in v6.11 since it can
perform a voluntary context switch within an RCU read-side critical
section.

----------------------------------------------------------------
Yingying Tang (1):
      Revert "wifi: ath12k: add panic handler"

 drivers/net/wireless/ath/ath12k/core.c | 33 +--------------------------------
 drivers/net/wireless/ath/ath12k/core.h |  3 ---
 drivers/net/wireless/ath/ath12k/hif.h  |  9 ---------
 drivers/net/wireless/ath/ath12k/pci.c  |  8 --------
 4 files changed, 1 insertion(+), 52 deletions(-)
