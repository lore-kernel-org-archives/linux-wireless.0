Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793373709;
	b=wqBAGiwZ/UiuKruR2/TTsW57VIpxpxljpNXPBJwNasUoUQgIYt0crloDE1AlezTgVODH
	 G3w+kJdYNq3Q7laD2BLVkTA1xxsvoxpg/CIMOo/G0uqbvj9uFwPuqFjM6x/avNGsSuk4o
	 m9XBSD7MTQaf78RQKOxVoSOxSuMIPLGVE4IdkYEPlmp7Rhi9YGml4U2tA6v6E2njHlnLt
	 OxVO/xP3mDsRwn/P/EgUCwywZ5M2At+HT1UTK4thdm8ZvOIWqRBPZb5BtGCQpDn/0axw+
	 j+alHtLrTbV1TI+0Dmpa1+VrPSak7SbFjOETa4Vi5Hvw1EBdfTsVlXQFmCJQfvi69JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793373709;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:To:Cc:Subject:Content-Language:From:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=sAULQRVnF5facmSRXEx8W6ksib0roSTKYLXWqipFzIg=;
	b=tgrycw3Bm2bD8xPy+oMEIU0giw542ZTYv04WDJ16oQ908/3ImSqXxPHoScHsQSl+b8Ca
	 uCt+KyT2VBKP5Y4W04jC5DxdG9g8SygZJFIpHRrPuSKxFwDTCY05Ih+NLb0OOb06/uP3d
	 9mx/hJhQzL5ikx9vcHDq6uNLajqwWIqCYrvHzjviG9LZkLyjidO+CjsXxEb+pV98TA5Ak
	 OsmHFbfA16kuakQny/xhaArGcEWF3+6vjMDlFnh4ali1Z4r8MMfQSiN5sTb8BfA7iJPii
	 PFup8vP3tlwyoP+u8Az54UD1KFcU5cfFHeGChD3PeEL3qxuihnGTs6a+HXLSQ4fSB4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nHuuh9HF;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OGaRlrqo;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6B9606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 15:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B6B9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=nHuuh9HF;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OGaRlrqo
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69UERDFd4141549
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 15:21:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=sAULQRVnF5facmSRXEx8W6
	ksib0roSTKYLXWqipFzIg=; b=nHuuh9HFhLxMhwHt4xA8chCA70DCE/32ugMEm3
	eaUWtWiNkMveqs/Cg+hbRSfni2r+o6TadpI5WM+ZhtOjq+WUaZQuOG/0milJaXmm
	saW4g+gM97op/5RjobqAHxeoFqNs6Ga6Dz+CntC98ihAVrtaIHBeXDcZxa3Pufq7
	NGd9veSKkgrRMqUCYdoUqFhNEQP6CRSofK5vdCx2Pka4NnQqwdHwcUF3rpOSa/8j
	EivXRYoKl54oViKKMVVdot9FKPRfFMmjN4PKFGnPN+BEhAdXi5jvmmEpFurCwyEn
	kB6HKF/ED6ihac+MWrUPv474hveSowFZzdUkryWuomFz6AKg==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hme6qup9y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 15:21:47 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbb92868263so496237a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 08:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793373706; x=1793978506; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sAULQRVnF5facmSRXEx8W6ksib0roSTKYLXWqipFzIg=;
        b=OGaRlrqonp3doetxHSuP+LqQt+bp0apoZX9CFTyLyxl/2UOAoVu3xgUtPLrZ81dNKE
         3GKDOh+BCz62jD7+BmT0kV2Pa+e29uPunVOivP9LygJGJ7FiDKcCbcUJHY8zMWJrN4VP
         PWPhIglV1crLA+Tbb4BKPIosTMHxriL2ahWbvcGQqaihZLpI471UBnxZJzthFv0+P4qG
         Gix6WgTqvzxvbVahbWxfeAH12ruflxaerS/3jtWGJSJS7QVT0Sp+6/Tyxzx1iDFhtQYo
         QwIn5w95Of7GMRgy8O5GcWAw44hyDWdwInq1NVP3/Czs1SzXkfEUpjr+sd2yoRjrGFuh
         qiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793373706; x=1793978506;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sAULQRVnF5facmSRXEx8W6ksib0roSTKYLXWqipFzIg=;
        b=J2iYuLBygQFlvA3aurnynaq8kOuUvdwDrApLUHqZEIiULzuHO/NxN39Oshrqmf6obv
         2mT/1YQthlZdEAJo4ibivW6fw/S1BFypCRWq49zUHN++nPLGj8kiaxiHy467HgcZbmGB
         W2JTH27+VKXwRXmc4mqyBkWvxUezi7ipBCJzHkWls1nTr5RmnSWln4L9CyTAB8pjCgz7
         ASkOKkRT3UQcnvTGPmehYcJXfEwO3WtTaKvQfpFRVZ5Itg9qY1ewMXhfXlILmONq48o7
         f2F0wSUD+WpZhHEQJGyxY2IZCTMC+NCFuvS/drelKcX1DM1MwNEE3pHnQybLoT2i1lVt
         Qshw==
X-Gm-Message-State: AFq9FYJUFZ8FMFw3OswXcBuULNNwaaBf+KCV6rM4zJkn/lVw6XFMas/p
	x0JMBb0iq7+VDObpnkCso3OWtcj6IEkgL1ooDQuolIJDgaR+87Yvhnrw9+cDO2gwZMCTQWTm3u6
	b6pjzcwqhI9qfCGO9FCCwGZ5kdhl2OW5RBKHSqNf0tlsewTAyqe+mFl09nnhInlu+/pLFiw==
X-Gm-Gg: AYBFou1vKEB3yVBRzYkFHS+xMV/JEXLLIwuJs7TmPyu819HgAuO+9I975Q9IzYA4/GZ
	1qhGopyfmzKybv6xBGEIhTW+ox4ehluJG6rsjCp89fTUmonpSFcXbBq2KTtpHaf2G4PGyvAS04t
	6BYifFdDXvf+UpxKgNHXP3qCxvxhocZ1x5d/A5d+MY1IuPTQv5WnwR4Qrk8a6HPe0HgnWmRqnhY
	+0jPGRgiBKja4YZTYwS5+9lV4zMHgJQS1OgXr93OnP7RZr7dOAu0Gw4kU3GLcWRNb5KFUxEF4fa
	JR7ljXJEwql9uwqg99ONzTuAO7744PMUtfR4whYJy87opW/ljg/0TuIylEOQHLDTB+a0fM9R9P4
	J56WB3i0DRQ8m59kxx6pRk+DurlZ1wlfC7TDu0hQ2RXAkZinz8OfVBNGkAymSOdn31+K+PSwvc/
	0gj0nnovTi
X-Received: by 2002:a17:902:e94f:b0:2e9:5eee:e07c with SMTP id d9443c01a7336-2eb36396abamr26900245ad.6.1793373706202;
        Fri, 30 Oct 2026 08:21:46 -0700 (PDT)
X-Received: by 2002:a17:902:e94f:b0:2e9:5eee:e07c with SMTP id d9443c01a7336-2eb36396abamr26900015ad.6.1793373705552;
        Fri, 30 Oct 2026 08:21:45 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3929b27bsm8905895ad.62.2026.10.30.08.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 08:21:44 -0700 (PDT)
Message-ID: <1ea7911c-9dc0-4bb5-85b1-9fd7f72c30af@oss.qualcomm.com>
Date: Fri, 30 Oct 2026 08:21:43 -0700
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        jjohnson@kernel.org
Subject: [PULL linux-firmware] ath10k, ath11k and ath12k firmware ath-20261029
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: r0Q_b4FmVkqmU1-rjykLanGNBhDSbxmW
X-Proofpoint-ORIG-GUID: r0Q_b4FmVkqmU1-rjykLanGNBhDSbxmW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMwMDA2MSBTYWx0ZWRfX7KAdpFE/k3yy
 gugsZHn5aMaQUJUn4QBExu63h/WsMSbRgD3nRDht+p3AizuAYTApDq3nyRvaFJoiv0/fuVOzgL3
 /JzJgEpnz+GkMxBlOatdMRi0S08v6ccctAV6dDOHoYvcqa13tQZqmHdkkHqlzlIXhw7LRDITvsA
 D4+SrQuaOjm+nge6r4DIlIdNgOW9SP+NpnZbnqw6y+X6tUJKdn5xkF64OvNpw9PHRnGtQAHXzIj
 N0KyDS9ckTkHyLnjyzPDlJVpAN+P0uoci6EzksMODM6PpHQZJtjYMSQdcq38ydRkHzv5iqIgXcK
 1GnYrx4uroJEM0z+wqawI2sqhx7h2Wu3E5LuCEmu0n+iTlNDqnGwsh5VyfF/gdaAgm/sedqqDq7
 5Avaox+6//4ZI7jWgGsiAsjDjbuVP+SMKKs6OHfzHgtLoIzCEWEA5V4ecFNkLOOYvxEJkNRCFYT
 6nQgpigq7ifpWES6gwA==
X-Authority-Analysis: v=2.4 cv=dPgzC+Zb c=1 sm=1 tr=0 ts=6ae4b60b cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=qW8f3ulzRhYlp-s60KwA:9 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMwMDA2MSBTYWx0ZWRfX7lBOxwQf6vxR
 OYnl4oUX/oXLfe2PYhcrqvFt+wiIEYhSoVrbHSwSPLl6lBtpf30JbdaKPEKNv46nIaOMMg99Klx
 lCEfUUBktyGMg6EbOBl0Fi3cmoozjN4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-30_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610300061

Hi,
Here's a new pull request for ath10k, ath11k and ath12k firmware.

There are no changes for ath10k and ath12k.

For ath11k, add IOT-focused NFA725(with QCA2066) firmware and board file.

Please let me know if there are any problems.

Thanks,
/jeff

----------------------------------------------------------------

The following changes since commit bcf20866cf559c19e6f33b10266fde45013e60b6:

  Merge branch 'rubikpi3-adsp-00256.2' into 'main' (2026-10-29 13:06:16 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/linux-firmware.git ath-20261029

for you to fetch changes up to 173aced9dec7af5541d50ad771b5578927426776:

  ath11k: QCA2066 hw2.1@nfa725: add to WLAN.HSP.1.1.c6-00302-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1 (2026-10-30 08:08:40 -0700)

----------------------------------------------------------------
Jeff Johnson (2):
      ath11k: QCA2066 hw2.1: update board-2.bin
      ath11k: QCA2066 hw2.1@nfa725: add to WLAN.HSP.1.1.c6-00302-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1

 WHENCE                                 |    4 +
 ath11k/QCA2066/hw2.1/board-2.bin       |  Bin 745440 -> 865704 bytes
 ath11k/QCA2066/hw2.1/nfa725/Notice.txt | 3658 ++++++++++++++++++++++++++++++++
 ath11k/QCA2066/hw2.1/nfa725/amss.bin   |  Bin 0 -> 5140480 bytes
 ath11k/QCA2066/hw2.1/nfa725/m3.bin     |  Bin 0 -> 266684 bytes
 5 files changed, 3662 insertions(+)
 create mode 100644 ath11k/QCA2066/hw2.1/nfa725/Notice.txt
 create mode 100644 ath11k/QCA2066/hw2.1/nfa725/amss.bin
 create mode 100644 ath11k/QCA2066/hw2.1/nfa725/m3.bin
