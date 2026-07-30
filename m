Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5EF399350
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 15:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424266; cv=none; b=dgGSB5QUBP+Gwzxwvx5c88eL0lj5078nhyLLB6i6Bu6sZbRTI8KEMM0VJmiM8BftvNWozNa4hU4hCsH1M/fcbpZumdZGy8qEB+u1CgIGn9t0dfzMugzni0QXlniD/D4IlBVt9nii7P0sXzilwCWGU+8T9tKAgHuIRZPXG/fQREY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424266; c=relaxed/simple;
	bh=crOoeuZG1dUjdS1mdRs0ehVq4ANuEHyO/sSDOB2W1aU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KHiVXBOdhzXYzYFSCsxUUqlZ1sLyqjyZ3flLqN05oK5sTJhkMhncFfiBWFXvd+ypOrILwvgKgM2SBuBbnhRaN9wm068e4u3be/hZaCz6pfW0EC1VgmyCrfyjqQmrIQ2GtWqdxYIrST0+o8xom09NugfQjeEdiofesIV8oDghcik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VrAvbfaQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cp0JYWg/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VrAvbfaQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cp0JYWg/"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UEaEnp1558353
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 15:11:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	0e1MCIXL8gKMWUwtGXYTa0AMbBBgxwuX7rr00z48Sjk=; b=VrAvbfaQF6j3Ic9F
	iUdFLk2e2RV8iT7Gta2FsU618Z6VjoEIhgcl6IzYrSjQzIg6m9Z7hfptvCLD0KTz
	hbEXM2jp8oWpMAUTmXnoOehqmZXFPfUkwn+IUXKd+827YnuyIwRfrS8t3uj9g2ip
	iD5dube1fkXvoTwTA8bhbLlj2W3PJbYMWs2aufCv0UEYJNux9HiBNyeZ1blydXif
	z+RGQJeXUZcIM9Jocy6v/KNg/fje+k8j0LSluk61ywsfrWbBahQ8Y/qxXc826YHn
	J+uPg7uzYvxZ+XS7c+QyltKXAW8llV/N6IMkSGhvCOVa7ceGRJLw1D7y5uEfDPWV
	MjsxQQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr8gy06g4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 15:11:00 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb7d6ba548eso2700947a12.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 08:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785424260; x=1786029060; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0e1MCIXL8gKMWUwtGXYTa0AMbBBgxwuX7rr00z48Sjk=;
        b=cp0JYWg/RUAOn96SlNzFDrRLPLazSAToUZwDRVQydaOvyHfEznvHmrPYgEaQ+hAH4b
         /RdD/5LxSjeGeSs/8ZGUO3pXGuOTlYOLj8bbqag1M6+1JUkF8IeGc+SKEWlNS5etAkip
         IvdBWiCy+znVCNUhmi+bsDnht0513vyEb/aQnvrK4ErYirRP8YbqKy/foyviLexBxA2q
         ntK+rhx+78tBN4poOpASQyN0wuKwlt0/CFB2S2t6FoEa+fqKLMAE0UQlA/EpSeEnT0UR
         tr6MNJqENni2fZ1Xq90xorZ96aB/vTfnQP5807JCTWiisT2wEd/iPtu2GiPj9UqX+2AY
         uDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785424260; x=1786029060;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0e1MCIXL8gKMWUwtGXYTa0AMbBBgxwuX7rr00z48Sjk=;
        b=tM2rXvkMP1ZlVDd2ubesQlISTqNWfwrJ0n8bXIAq6kQgT41khDDnbxUHzFb00ZJpe1
         44miyYOKULIcHiBSPkzKwJzlV/vOAv+7fnEppPBb3NiNibfmmFrlbpoXinRoAKSWYL5r
         c338Em+HonA74kzQDAaZCwIUnsEo7+cP2y+0Iq3Ue0ccxwQdbXdCUHiJn3DIb9OSzeZQ
         9c4RazvhavLN4A0JhEd+9Yi1wBXYKcibyxcIs1hmI9ay0xNnPGA1Ez+yqjhe4TsPw16R
         TovVAdcs+7CW0ccwXphnZmM+t+dLsNBVOtyFMyfd7nXVjGm2OxIEjrWF8+/zdIiAiyMO
         W8MQ==
X-Forwarded-Encrypted: i=1; AHgh+RoTA+ZKJAkvuS1Rmqe88nr4gqJrf9r0gM6q7/xqgBn1OGW99XaBr8LD8mtzIgoZA4PdWEIyyv1TrSmH3g36cg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbqFXwmpYoRdOpNLQaK2ux30oECu053aUsaxPxFeWd7LkLu9wW
	k+nwZcMXo3QVAhtiPT0UrfkYzGmbO9dZohHZQWnjo61vSyGHS3KpQo2OQBgokDwdIHn0QdkQK7l
	fBl0CHr1Enk+8zAUavOWZ1czbEDj5QuMQbVzFU9fEeest2OO2A2c2ci8nUua4ei8keiFnWA==
X-Gm-Gg: AR+sD12iw4r/qSP9t7AJpL6nlmsY7ly/YNDuZUkTdcRHL0mh/Q/reUznQwUZTtzU7J6
	Tu3LewyfwCd7ddmgfcZDMNDeBSEmcsu7gguk9M7E0MMgVm83IZI3jAjHOVYpzm3sxvxc0abDEf4
	zbnBmmS4gRnnbJZBxK/xKfTuTYJ15ZbH8VqQx5J79KgMJgovgxJxQ6aGsArMXNsXJGv5i5Q9r1Z
	p28DEGxDUZDGGYODzmf1wA3BM9XTBZIxSjdSJEZ9GI5rSy1DCG9uGoLYcN7mbqODwpDSveplNmW
	fnm2LOHRxyaV4bFtc877N0Uiux74sVjraHURAF1onb5flUfA4qCnEzXcRNDFamvECW6uCXvL2YA
	O31fE1/BV6XENOObOgm/k2EHpAaM4wkoMsLLYCpvrDDUABai469we5B0=
X-Received: by 2002:a05:6a21:178a:b0:3c3:68a5:50c8 with SMTP id adf61e73a8af0-3c90d6e9458mr754409637.71.1785424260203;
        Thu, 30 Jul 2026 08:11:00 -0700 (PDT)
X-Received: by 2002:a05:6a21:178a:b0:3c3:68a5:50c8 with SMTP id adf61e73a8af0-3c90d6e9458mr754381637.71.1785424259800;
        Thu, 30 Jul 2026 08:10:59 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e72643a12sm34502171c88.5.2026.07.30.08.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 08:10:58 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260728-mac_phy_caps_parse-stride-mismatch-v1-0-27a9c1a3fbd0@oss.qualcomm.com>
References: <20260728-mac_phy_caps_parse-stride-mismatch-v1-0-27a9c1a3fbd0@oss.qualcomm.com>
Subject: Re: [PATCH ath-next 0/2] wifi: ath: fix stride mismatch in
 mac_phy_caps_parse
Message-Id: <178542425857.3503956.13658873020140475290.b4-ty@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 08:10:58 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: b3S8yFByspGbgzMgULOfz0Fjh7ENrk_l
X-Proofpoint-ORIG-GUID: b3S8yFByspGbgzMgULOfz0Fjh7ENrk_l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDExNSBTYWx0ZWRfX3VG8J5fLAAS3
 CPgzDA6r6vziDE4LbRRIiuycFYabY9dmGgtRaRp9OrHxlVLhPk3kLZvrXUxV8b+NqKv53E6tgtM
 JU81QcKBM5vY30kDLDme5RTYrcWfrOTyIq1FPZ4hxhzqTdMfdLzwxPmhkg5A2NY8fKqCKuCEdJG
 XURNYxiaLOtx46jBDlppxk+iwvAs52kobBMx7Mf+6xKZH94+VKW68YDZnolZ3H5/kp7KLOQHxkl
 ePJ9wC/5FIb9jOW35cqPv9Jw4zAkgarPNbqEJW2o6u6uZ0pwNWzOp5bzlT1MsEsRHA12WTx0H0O
 Fq3MPWI4/F2iq9GX9V0/N8ynBkjYDmJULEChoXL6DfeETzVjNuPRepphNEVDW8yyN53QNQOEFGh
 U8sihGWCh3RruCo5mA3RfjutN1GSanwRKiwogl5lQ/T0oh94ioY3NsKwdOFQMz00Gk6JZoEeWWt
 zQw+9ZCNk0jMcQEUYpw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDExNSBTYWx0ZWRfX/FREpUv/WGBb
 Um8t9v4J8iqIaucF0xFfj8TB8ViYqn3AOyMFuuSvO8OKdeVtfdmV92weMUb4uXDpAOBgICss/v+
 dcRRVnaSY7iIXlTQEnC516qlZ3Yj+VI=
X-Authority-Analysis: v=2.4 cv=MuliLWae c=1 sm=1 tr=0 ts=6a6b6984 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=QOL9NQ9GI3QxS5QxDNMA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300115


On Tue, 28 Jul 2026 18:05:27 -0700, Jeff Johnson wrote:
> Both ath11k and ath12k have the same issue.
> 

Applied, thanks!

[1/2] wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()
      commit: 4c6eb712a91fa079be6f9f1419c96e0ad2227081
[2/2] wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()
      commit: 7a246c72132eb943b5844ba79dad597b47429dba

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

