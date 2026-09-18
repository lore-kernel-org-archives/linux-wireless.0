Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C473A2543
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 14:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789741179; cv=none; b=UGiAtxa+CSDBDVvoLD+vPqbpjZN/rwYMr7DxxAG92wcO7r9dMmM3M/TTu2Xxxm1Fc+v8jl0vYf6kDj+2MynUc06gdwNnTmbSFembENNaRSEIjyynsCosNN7Gv4vNeDrOsBgRrh3LjDX0EYeKaGUzNejztVx2axorfgGRfGwKxjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789741179; c=relaxed/simple;
	bh=VkfDA6NZUnqrFBnsgSMQMg/iEuXUg3+Q5876aEUeY64=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=nnid4DtWpKuYjdwOGVZClUsYVBC81opBFYRUm4YcHpwc/EOfQdl2Q+zt9fzIycgS0AYBy3pRg7YFwTmu7YgoY8Cl/jvwAr0AgeouYVQOVLML6LotG2X6hiZWl41uGQFmcmhcb1xRvsc7C+g5hDD/vS2lBKG1t2t8St9beDNOOdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DobeeqdU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bkEzUeIz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DobeeqdU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bkEzUeIz"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68IDOmYq746044
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 14:19:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=UVIKTbOX8P65rHjj6Gpe9j
	HcXhIM+KLdiyQqTjwwzPQ=; b=DobeeqdU60kdMGy3DWDXi/byxGfySY6l20JjUM
	iMDRkWre2xMXVhmLSxpBdCvBMDKYgGsggnLMEd/BrUiY8ed6rD+rYpjL4e9GE7Ko
	Byt32oiN+dqu3SW/hskLiG6vob2vuFnhY6LBVchwAfVg87e4v9Pe2javI6yB7/sk
	DMGiwZMSvka98KyaWIbT/TcFOMKTfNz/Wd6lHw7gyZH1hqkjponf/9Hzr3Du3SZ6
	uHpkTgm/+X+vQlIzNPZdhFpWeASTkfklOqvYvFzaoGN0+MO/Ne5Kh4Z2/1uwoghd
	wOf2d2O6PQLWwzMTqly24/pRUzaSzsP0s8t5aVR/k3kk5ETw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gs239198g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 14:19:37 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c85798977dcso1066794a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 07:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789741176; x=1790345976; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UVIKTbOX8P65rHjj6Gpe9jHcXhIM+KLdiyQqTjwwzPQ=;
        b=bkEzUeIzwT1/fKIMJH72/ullvZLpe2xoJEOx7z99a5khAsWLRqIDvZ4KSfvaXcD0jt
         NMOkPqJvvjpbS0YKIktHQUSF10mTv4LiAXKwJkWiTP7IIYOxLqr6W5E7Luk+pJT/NqqJ
         iqyuRR3bxhXN9Hno5bTHuza/xQtEfo0Ose18mMVhPqcqll8LmNzDjercQBG0+eW6IwEk
         RTaidKPR9u+vNMK3J5yu/wz0nuQfwzPShe1fieiL7SqXhlJbM3JAgLOYXvdDTe4le6sZ
         acxo9gX/Bv+1qnVH/b2PKOIQMrS3ZPABdpwPvjckw1gSQBmm1AwF5kIvb+R41cpjE89v
         bZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789741176; x=1790345976;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UVIKTbOX8P65rHjj6Gpe9jHcXhIM+KLdiyQqTjwwzPQ=;
        b=MO6U07k3sT4KIFybs4rRRsuuVLq4TKun5UfENgqhOYPyl9XZFgOz+kZx92XqNndQIM
         P8AxeTOzdI/P0js2HpLPpjd+MaR4ix3c2kgqgPuYolrkQoqcrtI6+xVYLmvEijBA/0WT
         hz6qk7PI5a9Eh63HcVdmPab9YTfwfIQ+mVJXTOfT/6p8AvN03k8gLJaf81T5gI3u2Ffo
         uJ6mmKmiu3Ty1EOVUA/WTgRrGCD0cmgx48n52IKWyLTKVR2eNGf1BAO+gf+eCajk7viP
         CDv4V13zWy4piGqUbjkM8hPElDPc6PGlDXY7z/A0HjhWOnQLk3CPSZ6IjUwfeOP/p9wy
         ZfGg==
X-Gm-Message-State: AFuF++nYSjWeAJeNc+39AIKxsE2n5SMbCYCr/SiEV66NU8yP90EvsNNz
	IwWDUFl+5hfSutONkjPMI9Ew8bcJO6o1Du1rwF04IBFZkm4qq4TYwWt8V9z05/1TebJqLoIX0yz
	lJib4cVkZI/hearxUJxlpkOO8KgUK6xudr3t9eHL2fk3rq/1rhvVt5cSkrjA5qx587hS13A==
X-Gm-Gg: AYBFou1RpUfEdhLGjvOFmCgtsgfDunHLztA89lifmCn+qn2SRVgXiYP+WjoG4IIdZt4
	P0JdsQXLQbWFfxcxO2vv6Cyj/8sV4nLSd4O9quBnt6n/m0XtizMk+jlhiNigYqmkJvEOdgQILef
	0uA3HiSJBjW2zt7tkEcQKZB/EjtPCZE/M0ctSRpmeg1hj4yUKPFA23cltRXCLxF8yvWn/ZjMZYn
	r5udgoFJ+dOMgiqC4VgyPDoYysaFKKdY7XtVNuxDF8mzlziP23CTI+cMtuaLQ/Wo9iqZyx/bUiE
	M+mBanCSXoQTZ8Q4402QpsCd4aY/oxprirntoY9clpeztv62PnhsKj7h2UBQo3oUPqhiOF7oCSG
	LQPwt5s+nYLOwmI9dcgXMMnzoTqcoe+RHa/A2
X-Received: by 2002:a05:6a20:eec3:20b0:3dd:a006:ed9a with SMTP id adf61e73a8af0-3dda006ee10mr109624637.48.1789741175739;
        Fri, 18 Sep 2026 07:19:35 -0700 (PDT)
X-Received: by 2002:a05:6a20:eec3:20b0:3dd:a006:ed9a with SMTP id adf61e73a8af0-3dda006ee10mr109582637.48.1789741175140;
        Fri, 18 Sep 2026 07:19:35 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc5c50c821bsm1100001a12.22.2026.09.18.07.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 07:19:32 -0700 (PDT)
Message-ID: <bb9ea6c5-67ee-402c-a007-46c9c7727632@oss.qualcomm.com>
Date: Fri, 18 Sep 2026 07:19:31 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        jjohnson@kernel.org, Troels Vognbjerg <hekatombe@gmail.com>
Subject: [PULL linux-firmware] ath10k, ath11k and ath12k firmware ath-20260918
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDIwNCBTYWx0ZWRfX78VMnznZid4W
 GCSBdUUGL6uiyWfzrqLJAtFd2VMzPqs42gmraW7P7YFqIXRbyyiXFNCYhTAFswNSXOaXDYV71bp
 djgxI9xwNs3jgsnzPuz9fMzaV/jup7U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDIwNCBTYWx0ZWRfXxbV4cUwzzcfH
 WD9wfr2kgtH2UEfxTsj1q1OWKbKNOS+aHsDuqZtCwyhb4+fI6C6acsw+gEoCiD8aR/IvB8AkFp0
 RfDhg5KmjsoljHfCp6fo/w1wC5JpOvJbmRP7DJvOak0tThDPIkZTAt1pcNX2vAWd2uSLe/uVc5v
 VWwKpdkmyogOsZKefDvyzL/P6dhNkrUb7lZCnWmE/yTwigMZk12NF+9XL6507JKPFdqDlrTydJY
 d0exugBGpltmAwi4bGmtb0+Yy2vH1TFXHZXRnU46Nu0kHl2sAsO6aOLWUrRz2tpQMl+B9MViGt0
 32CTWvn2LE1CQRDRcaM5EJO46mOAdDxwYL/qLG6BIRAualbI3QFW5Uq/3RVywH9xwwQsYGbAiEe
 lbQFVtohyPTChyqL401Gb1/bMQUhQYaXl83NnKh1rzdrDpI09F0cyg79XjxBIuW+GcLSPhWgNLS
 HUcaV9MXYSjmQbQuoYw==
X-Proofpoint-ORIG-GUID: khxJdOBPw_q8LySdTfz36Rj4olfxa1y8
X-Authority-Analysis: v=2.4 cv=I7zw19gg c=1 sm=1 tr=0 ts=6aad4879 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=Q1qRzZT12ma5ygSj1D0A:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: khxJdOBPw_q8LySdTfz36Rj4olfxa1y8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 adultscore=0 phishscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609180204

Hi,
Here's a new pull request for ath10k, ath11k and ath12k firmware.

There are no changes for ath10k or ath12k.

For ath11k there is a single change that adds four records to the WCN6855
hw2.0 board-2.bin that cover the following devices:

bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=910a,qmi-chip-id=18,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=910a,qmi-chip-id=2,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=940a,qmi-chip-id=18,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=940a,qmi-chip-id=2,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=950a,qmi-chip-id=18,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=950a,qmi-chip-id=18,qmi-board-id=255,variant=UX3407Q
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=950a,qmi-chip-id=2,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=950a,qmi-chip-id=2,qmi-board-id=255,variant=UX3407Q
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=960a,qmi-chip-id=18,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=960a,qmi-chip-id=2,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=970a,qmi-chip-id=18,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=970a,qmi-chip-id=2,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=980a,qmi-chip-id=18,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=980a,qmi-chip-id=2,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=9f0a,qmi-chip-id=18,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=14cd,subsystem-device=9f0a,qmi-chip-id=2,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=17aa,subsystem-device=930a,qmi-chip-id=18,qmi-board-id=255
bus=pci,vendor=17cb,device=1103,subsystem-vendor=17aa,subsystem-device=930a,qmi-chip-id=2,qmi-board-id=255

For the ASUS Zenbook A14 UX3407Q records the following tags apply.

Reported-by: Troels Vognbjerg <hekatombe@gmail.com>
Closes: https://lore.kernel.org/all/CAPMyOuCk7SEhPvcNNQ3ZMUf=uH=e3Pp0NHf6zLoakrSvL4qEoA@mail.gmail.com/
Reported-by: Mohamed N. <private bugzilla e-mail redacted>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221853

Please let me know if there are any problems.

Thanks,
/jeff

----------------------------------------------------------------

The following changes since commit c9f6fc67b4833a0e4d0aee2554d637c49f997329:

  Merge branch 'eec-eef' into 'main' (2026-09-17 14:57:59 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/linux-firmware.git ath-20260918

for you to fetch changes up to f8d2ffa59894c9f8858585eecc968d63aee6f46e:

  ath11k: WCN6855 hw2.0: update board-2.bin (2026-09-18 06:42:58 -0700)

----------------------------------------------------------------
Jeff Johnson (1):
      ath11k: WCN6855 hw2.0: update board-2.bin

 ath11k/WCN6855/hw2.0/board-2.bin | Bin 7237392 -> 7479440 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
