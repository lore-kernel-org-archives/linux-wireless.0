Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB034502F
	for <linux-wireless@vger.kernel.org>; Sun,  9 Aug 2026 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786294600; cv=none; b=CBTC1l7zhANwjoLaFauSrpchBhyTZDflFtxx2xEmgZm6BqY7Ky7QFy6CbgnL2o0nYkcUZz2QqsVaewfy4+FinCdB5AHrMz1FoSDXVGXcUaVi8Yf+WK1YwUkXonIgIsREanhKuTVbFWw6jFS7tuOy3GkYAdDNpt/Vrxd8C36PUP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786294600; c=relaxed/simple;
	bh=txqa91q72Cu3wOoIOnH6POVtteeX1eCmRdt5UR1rueI=;
	h=Message-ID:Date:MIME-Version:To:Cc:Subject:From:Content-Type; b=XXq6S2infPiCFNyBDJtxcGy97LJYpIaJLXWstXC059iTRNBdnuaHXTkgjh0vDHf6Dq5jA2q61P+nVtgiMWA581sMRy4hfXd6VQyURCKLAyylYP8ikuT3qxkoNGWHbHxkbiiAMhYgBBctUVwwUfK9Y/QvLc7g2H/BcwBvbd2tLV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ias4j0lI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eUhlJgLs; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ias4j0lI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eUhlJgLs"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 679FMmud2777257
	for <linux-wireless@vger.kernel.org>; Sun, 9 Aug 2026 16:56:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=FRMtojNYebz5pnxWFacqhh
	jzm6+711Mk/YGMwYi3xFA=; b=Ias4j0lIMSFUAPycl6i+j0wnbv91lYzuClBcvu
	/LmWCPr61vcusvhpi7Hu3FotmTb2GvTwmxkxxyp5+Bd+aaLF4higEAz4TVT8PxTE
	CUlEp4AQH0g4TiTZ51GtlLD7G9Vwzu9PeTW4s062cZ8sWjVrDwQpWpceb+HL5d45
	quEDJztb5nJgShcZ+JHCeBc0JMBIO1BZKy4mZT2F/pheGpgLhawL/zh9JCmdiKW9
	meBmlsAYlXo7IraptnFrmjwOOAJM3dxbi3zhtNWtuwcZxRa/Izya65riLc6FDQ5R
	fr2KtTy/koRFlERN7nVIvtLvx5yR33KzJjAONqtowAHzSoPg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fww7cu54c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2026 16:56:38 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cfca8558d2so16234185ad.2
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2026 09:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786294597; x=1786899397; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FRMtojNYebz5pnxWFacqhhjzm6+711Mk/YGMwYi3xFA=;
        b=eUhlJgLshgnroO4c5ut24Gn1N3seyvTWV5W1gF9/nxGTpge8UBBorgekJC5NjnB0ES
         6yWRG6Q7JlXh1NgpSapknn9JHV02OGEvvTFr0Au0vskC4rSl1+hIDu269jc3MEFcC38h
         VLY5cfXr8qM0rANrvjfIVQzwAFQpwST4vDfsL+5tYrOK8Tw6SuaUY3wholxdH+jclRNe
         XtfujJPj1l0WWkzFlXOL2rrwCVayFtS4iDQdGK1g0fbiPwfNw9c2KveBeMHip7+NdT1W
         I12gFlDMTXaPqAvSpzo/uErKUM6yfVQtgVQ1pJnljI7OtPcXTZCtLcL8SgpWl61IPHBO
         sf9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786294597; x=1786899397;
        h=content-transfer-encoding:content-type:from:content-language
         :subject:cc:to:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FRMtojNYebz5pnxWFacqhhjzm6+711Mk/YGMwYi3xFA=;
        b=Dqqq/boBWn9aePGo7spCxc84yxUKanO3KfVJ0uoA+ROVNeIzEUx+aoy6BzMtj6Ogk0
         JLkCyGVik7MDpleWw0g/fPb2YtsMAU3n1qlnQ24PoM2E0ODUtXz07pLUWsuOzjwzjpe9
         qSOAp7YCPIBfN8wZ/G42ZGM9oxWMJcFF99KHBgv3wnVIGwGYL/tiyr862gsUzlpjP4ZA
         A9uwnC7UwVIyUav1V1ESCGHBtQE+PDAync3+4lp5SUZHU0oFVx0bYSW4eK8/KprlpJ/n
         WwRRSNrKG6ufo/kUQKQzbvJm39H37cvA2Bn+fFB7IObwMAh5OUUnWhfu81M7qvE0X/Jk
         K6Hw==
X-Gm-Message-State: AOJu0Yxckcrf+QX2sQiUZNkMFz4FwalntHfuMB79OtH9FazTjtLgA++G
	hH18bX39ZrEJpcZXjJkQUwJmYUqexUDxjHxdMYivny1yMxPGKQogwtSdZvbpR/ADS9c42YQa1y4
	d210k3DZyr765qsNO96w+Yf2TIm1HKXaScyYVEyedxUO7ShS4pyBZCkm8ZRLStr+/M6vmIw==
X-Gm-Gg: AR+sD11DTrm2nugoxlQ3nJphCXqcVqfUKNGILqXbyzT2Urtw0O2d1PtpmGdLIrDWhiB
	jwo3wLbeHMECUk9UgUpap9rC5cu6PKPMe5oylZeVPiJCYfSm6FcHpkYADBZlLlJvcm2HF9N17Pd
	Jt/ekqKhH1asutS2uwXZG/u034KutioP/oKeHpsjcqtpZvTnFPHTy4j//fEOalz5r0N1bqFEWu5
	qw0lwK1/QnergInp1KS/Yf24kJnNYQ950lOjacyJXZk2Vg+Tf1y+kjsaHz/cZuIphHnvWZ4NPb1
	nuxne1eefsWTp7NMTfaKupb/uoIwDqb2bkX22TiUpuEomQj/27k8NC+JR+ijkGoeLBuMZbHgI46
	lY4ilTNR1u62QeZ4vh8NXNhroHAG7+oQhPpa0
X-Received: by 2002:a17:902:d492:b0:2ca:2079:91cc with SMTP id d9443c01a7336-2d2a8458c42mr151822745ad.5.1786294597461;
        Sun, 09 Aug 2026 09:56:37 -0700 (PDT)
X-Received: by 2002:a17:902:d492:b0:2ca:2079:91cc with SMTP id d9443c01a7336-2d2a8458c42mr151822505ad.5.1786294597034;
        Sun, 09 Aug 2026 09:56:37 -0700 (PDT)
Received: from [10.81.91.45] (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315beb8844fsm34239760eec.16.2026.08.09.09.56.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2026 09:56:36 -0700 (PDT)
Message-ID: <8476e576-04aa-4fd6-bde6-e34c918ff28c@oss.qualcomm.com>
Date: Sun, 9 Aug 2026 09:56:35 -0700
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
        jjohnson@kernel.org
Subject: [PULL linux-firmware] ath10k, ath11k and ath12k firmware ath-20260809
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 7UjFfpDH84G9TkZfKAQTMI4Fulb-WgaE
X-Proofpoint-ORIG-GUID: 7UjFfpDH84G9TkZfKAQTMI4Fulb-WgaE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA5MDE1MiBTYWx0ZWRfX2Upx8xtLyQe4
 A98dcIjCMs8DVLFn6zFI0g2SldsP3miVMxVTnYf2WUl03gV7HXVl89R0p52UScaRmejp5190VI1
 lja6dqFWkWBSKb6eFrzpc02J4rq1X8bWHh5oomOvlLh+CkDSHI15lwfPns+x8RcdT9LZwylzinc
 WfUogbol2x9l3mwnrxC3JRCraaXkyork4eD3p6xeUb+gTT2Tc8fGZa20zqZxfft0PNafMLTuxQd
 2ov/U0OkqJjNDLOrHYngmIBbSkkBV1buiCa+M9F2RFrqXoyEWAzMMfZRC50eHCBIp4+maSFk32K
 rs+O+PK4A32HHHTtnVOjJcbEDjZUG/VpP879gVsMMlwe7tZVyy5FJJRKpnLgW+W/3Z3C9qaYU5w
 Sc2AtYuR43dF9DYkaj9UOv92dzGWubxgdzm70SavRT2wUzUr2AaHnM/sS+k3KVOwz76rMVf33Bw
 cxePliWbblUd+aW/8qQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA5MDE1MiBTYWx0ZWRfXxqQEr+r/IFSZ
 vNuJnL9+/0GZ9xVrJWERGj4smzSGqft3PiWxpVTC16SJP5AA13GFsIb/Lw/0S/nEl456mwUOTA8
 C+LtjV892nIzsI0uuvqY6bS/RgVa+ec=
X-Authority-Analysis: v=2.4 cv=IPsyzAvG c=1 sm=1 tr=0 ts=6a78b146 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=5BXK2PN6kyUBF_VKF64A:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-09_05,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 bulkscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608090152

Hi,
Here's a new pull request for ath10k, ath11k and ath12k firmware.

There are no changes for ath11k or ath12k.
For ath10k, add board file for WCN3990 variant Shikra_EVK

Please let me know if there are any problems.

Thanks,
/jeff
---
The following changes since commit 16d815da3637f645bc67e4c71b757e70ae44d498:

  Merge branch 'airoha' into 'main' (2026-08-06 12:07:51 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ath/linux-firmware.git ath-20260809

for you to fetch changes up to 796029ba95ac00dec03264eae3807e0ea0ae988c:

  ath10k: WCN3990 hw1.0: update board-2.bin (2026-08-09 08:00:34 -0700)

----------------------------------------------------------------
Jeff Johnson (1):
      ath10k: WCN3990 hw1.0: update board-2.bin

 ath10k/WCN3990/hw1.0/board-2.bin | Bin 867116 -> 893528 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
