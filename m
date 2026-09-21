Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352D84F391B
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790013612; cv=none; b=lFb+OLGffk5GR9Y2Vs9EppvjnjsPFQ881MSJzfvw5Zqa49WVgK7OSs4WLVuKaNGaH8DG4XzTT7zIevLyDyWVf1/Fj97OEkvhfkahUYSelLjSTPaMHVEa5yYc9inC6jPnmRNNGAITGBBgmFY0XLfthvUfVmSaj+e7QPa8mOZxDWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790013612; c=relaxed/simple;
	bh=jMCSsoAxgdb4sl3SxhWOA9fl5zPvq1xjb8OrxeUrA9U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FIzzI9GhxeSHL6DJ4hkhAmMS/M3uPIHe7hHVSdgQNQsY/Bzf8KCbM91Zcqx8LnUVSv1Lwl3Lcu0Ho8iv1EiO4BDE1iLTFgl8Quou7RGrvh+bYXCk+9yjiUcxFfrMYHdIUAUlXaH77Pt1XPzYe9rOYYcL9lMVfFBC8av92/L4NGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hJgjoD1z; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dab49NqA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hJgjoD1z";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dab49NqA"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LHKZbF1821777
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:00:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Tgy2DCt+P9noevQTi8uj/7PrjpZlOMzQlxRytsgGt60=; b=hJgjoD1zCiuSMrH8
	FbLfbIiUCJrLhQDcOGhmeT8D9iurvNU+XCEIZJjHxxXL2VreCWMVRA3SLq312xEQ
	DD9Z/uEFYFIfdAQLxbdUH2Zx5ZPK+xF5p5lD7J+9j3Ccjz+uKN1M2aT+Ayf5VF/p
	k57dOUn1Jp4R7UdiZJ4InM0J8C/LbKffsnr9ysL8DsuBsja1ZR1P+EHr19kP4LTv
	uQUQgfRr+eeXyWRePXAObZCPzpUq1nBBXjM2WLYmdyJaN1whkG4cFXVgIyHPMjPi
	mlUWnunu+sDpn3MZoz49vYo1KolVmevk1SlfR6Q8IJFYEPORQI0tQdcrt0Iew83u
	t8/WSg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu8w785da-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:00:09 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce7dfd33ffso43063405ad.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 11:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790013609; x=1790618409; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tgy2DCt+P9noevQTi8uj/7PrjpZlOMzQlxRytsgGt60=;
        b=dab49NqAr2vwfX5WyTDufpxhSxPGJ6W0zJBxI0PCFeZmF25IXCDu1KEgZMwFxroz0z
         YyhOaHB6yd7PbmCcejqz8oimGK5UsNjGHDL2BEfsZ7NEtkedEwPtXo7Oou4HHz9Grs8r
         dqECvTtMNwYO4XUKfxFw6dh+nv5TchFUTWo4IdITTf4QSMHuPLj5ZmSH5JbG1bO4DdKU
         edl7172jsi6ylwQkdbx1wyddfbhGoWQL2S20pO7rFXPtjXBJPvDIozChPaLMkDk5pMWN
         wqyxPvWQiXnCV5SMePq/1ZdkPd/dSWR3xtFMnDf7AuQLzFgdo6aNo3lIGQ5foBl+y9wi
         Qh3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790013609; x=1790618409;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tgy2DCt+P9noevQTi8uj/7PrjpZlOMzQlxRytsgGt60=;
        b=mxv6Sx7TbpGon1rP2RrPehyn1439UxlCorAYXfM6Qmn9r/Cw1B+0w9kfRgVjRaBTnq
         R7Bkrp6NQcoEyasKrcjYvEA731kPNV4a5nJmGl6ZubMDfqIjcw8UY5DV/kLePHhKls3H
         PHiAqcvIcRlLihtlWp9VEPdRUiYbY41+b3aej6Sapst4w5gM8BjKn7HkWlfp63kaP6Fv
         UXn9P0rBWaQDXn4rNIQGEXus5280m6FPrGTmfqGTBJCVFDYbaBiVd7wZwbsUDbUDo2+8
         GbxvnNjj3a4qOaL/6/X0/pnIapkUAU+o/cjkKum4f6dL3kOdtqG5vVkaP2enKKfEImi3
         gFiw==
X-Gm-Message-State: AFuF++k6dqR97+GWvolmelz6cu/v3pyBhH6ZgLkVoLIUQ31xJQjuMCPj
	UVZZw2/smtk6WUZnYNZkrq8Gedkeqt7cf/dfpg+en2RmsVOIcDV9jfLJNV1uob+uIP9jrbEdFDa
	WS3NPU9IROUMQDlAJ/8OuI8UewCinGGrHyjBQXRhZH8ktUGZVj5TT2jvJNgcvcnRv7sSQOmn9DV
	ohmg==
X-Gm-Gg: AYBFou34bh5wopaEAD3/+uZpwD+8eVlg+19lKvyk3YRnP5w1HKfPlAoHbMEWyBsH4a6
	UR+ObJsAZ269N2a8FdDZi5Hy5wFGHpz8hVEN/s0LDxdYdB7KnXA5EfeZd8xUclUGgEyb7fS++Ok
	P9n1iCehLJ0JFvWvnoaSczsBdNkgOW9Tm4cykBnx4Ws9pJJ6s6wILLumiKLXSGGBxfqq/Wv6gsn
	MtBOnk1IDklp6QWr19m6wmgro5YDbQ4MQllomZir94/FwY6YxS9dTHz7eX05Rtk8+W62MNeWvbS
	mGdoe2UeMh9f2ezbx652Qpu8CmTqTASEHSoC+bwQVcVv2L0hj9V0B17GuKaT1GZ+pk6R+ly3azU
	jBE3uDeBIaNU0CSdpeddnzFjK5EIcmJQgd2+W/yIjQ9lIamChMmdGKw==
X-Received: by 2002:a17:903:3d06:b0:2dd:ad73:5b72 with SMTP id d9443c01a7336-2ddb1d5ed8cmr163764225ad.34.1790013608806;
        Mon, 21 Sep 2026 11:00:08 -0700 (PDT)
X-Received: by 2002:a17:903:3d06:b0:2dd:ad73:5b72 with SMTP id d9443c01a7336-2ddb1d5ed8cmr163763925ad.34.1790013608200;
        Mon, 21 Sep 2026 11:00:08 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c3311a716sm22873198eec.8.2026.09.21.11.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 11:00:07 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: ath11k@lists.infradead.org, Nicolas Escande <nico.escande@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260812-num-station-v3-1-871d20e043f6@gmail.com>
References: <20260812-num-station-v3-1-871d20e043f6@gmail.com>
Subject: Re: [PATCH ath-current v3] wifi: ath11k: reset ar->num_stations on
 hardware start
Message-Id: <179001360744.250336.11058202665235470061.b4-ty@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 11:00:07 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: NdPFkUTF61R_0xgZq-VqC92zR9nwn450
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDI2MyBTYWx0ZWRfXxwD5KAHhfW1a
 az5OmTq9c2NxRHJugHWnrW4KkEhv5uo75Y4yCn3zs5e0Af5BEzVIyEqWFwZvJfdz6l+ngCKO7PQ
 Kgde/CEVXdpVSkgm2F+fuZ5b85XsiA52sfG4goTZ55H+LM9g9Z7xLmbtHHZp+g8uJMIeHpacoxV
 g2Ve1xHqVIuTLP+F2m0wwV6Q+KtoSWaDkwvKBPwAr7QI7pnlDKK/OutYhk5S9nDxBRRfQpPTmp2
 Z3iKh+3iE2STRA4pC46SMyc0JUhu1D6ZdfljFfF08kkF1s7UbeQ6wHhHdJkRv7rBDCBvUFpM79V
 ormMcVd7NaGMFp5AFx/CiJQw7s4gJVSy8yczhtouul/UQcvsEEFnnH39dQA+z48HfIMwFZjgfbP
 96SK+dIUaUaxHMbyzxjq9zfk6G2MzhYWdZe/92qrmPEzsdIti+FJu6T+DxxitjWxuIf7tcpOBCZ
 n2rTABQnNHeq3J6sYcA==
X-Proofpoint-ORIG-GUID: NdPFkUTF61R_0xgZq-VqC92zR9nwn450
X-Authority-Analysis: v=2.4 cv=Vqi2kO2n c=1 sm=1 tr=0 ts=6ab170a9 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=POslfGUCWg19xbYTY0EA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDI2MyBTYWx0ZWRfX7PqVYPmmAkyT
 t1n5oZTbXhvwLKQuBoXCoXNfr+sdzIU9CzH9nmCqw8DveFCYw0ZUNsYjAvgGnSwHxLPp+DnlZSm
 Jp4qdr/M4osT1byQbNSQ+qO/SfdrKXE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210263


On Wed, 12 Aug 2026 16:58:05 +0200, Nicolas Escande wrote:
> When (multiple) hw restart occurs, we end up in a situation where we
> cannot accept new stations / mesh peers. This seems to be the
> 'num_stations' in 'struct ath11k' that did not get reset properly in
> this case. In ath11k_mac_op_start(), it was indeed the only accounting var
> that did not get reset so let's clear it too.
> 
> This avoids problems like those:
> 
> [...]

Applied, thanks!

[1/1] wifi: ath11k: reset ar->num_stations on hardware start
      commit: 7e0ad05ebc72fffba2bdf2400400902d94ed7272

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

