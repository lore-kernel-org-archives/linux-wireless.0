Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309514C226D
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 15:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791213001; cv=none; b=s08KvewoWPD/vNvp7oMGUivHaCmehO2lk8wZjtmrimBslMQ4BqbI5oR78SuYYxUfuFVNiEEycPmNL35mrUMBTlvPvgEB7duTij3/wv/nSfbvxi42IBET+cZAxc5w2pHF7aBrTwqIDPXQ7R88DV0/nEwgc4yLiK1W4OLmi3eL6YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791213001; c=relaxed/simple;
	bh=6IeQM88uWsoEPW+UmEcejYga+D2dFtB5DxWxyb2IxlI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=gjdsqU1ZaXizwfvBQRbqm+KJz12FlACSV0C0nhhTk2UlAuVSF6c72yujZ/a+t1OPweFCiNrZ32YyhS8iMQB6CL/F7vUwfN62V517STxj1WCA/uEnUb1MKpCpuzp/iXQP6c4PMlaItLPBc5Q6SF55fgiVLtIrSFbi9usRciN9fns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AkpCwTj+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z/ERwA44; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AkpCwTj+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z/ERwA44"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695EPHxh3141754
	for <linux-wireless@vger.kernel.org>; Mon, 5 Oct 2026 15:09:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ufaCf0U2AcnN/hqLilmYCSsvPuytCqyVtjw/wA/CUsw=; b=AkpCwTj+wij4vo2h
	+jineqiZAyF5xU4j7prbDAmwfTt84sutibdVDJjeVAKNQSD3cD0jPtUr2D1sRa5h
	6RvPAlaSX3wBv9IP8aG4vrsq0NL8eRtfRVILiNt+Ao277uwmM5xO7DRgXRM5fmy4
	jNRnA36M1+QYuT915FxONO9/NjkODOPBD5bRx5Q8h7jL/s0Cj4+z577mw75OOC82
	NRtcAW/jA289nzzWPHuVcgGhB3ZMviywRKrSrbsrdpK3xzoWON7n4soQ7e1HwfO2
	afqnlJWhXRfwG2zTRtnbOrUKBxjeGgWQ+o89wfnUbUXhgxP5uMqsQ59tmq8muXL0
	2PpwDA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h49u4140h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 15:09:56 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb48f41343aso1046535a12.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 08:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791212996; x=1791817796; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ufaCf0U2AcnN/hqLilmYCSsvPuytCqyVtjw/wA/CUsw=;
        b=Z/ERwA44lHm5EIyc0G27Q+uiSf6gMrDg0PWqE5X6b1lHYOPckyr/9+jZEfwVaHb8zV
         KtBLbnRXEWi8QEEzgWbLsW4IuICnU0rUsl2xkEu2PdCtG3VxmZ3+aPE7mWWb/5aXv7iG
         9vzcRWP237bglBdI7hyIbF/c8xEYHP/NKie4hztgvxCHfsMfewAlb2iWVEmI1QWhNdPh
         JuQee9/+oGbryVGhtauaP+Zg46sMSDJm98UyZgybx++4Xidc9GJCyr1hZuDJQ0xj9mY3
         JRBugEtWJ70/g3yJtvLV6TuVBuykgQ5LNohErYwfC0Zz7uozQL/+zO8TA9UO8SdBJI0s
         bRgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791212996; x=1791817796;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ufaCf0U2AcnN/hqLilmYCSsvPuytCqyVtjw/wA/CUsw=;
        b=xeTkj9OEr7e67bzHguf001Dk44l/PBvoUGEBD4bSbNvL8gJk5m/mLQOHrvB+OGGTXS
         ksjt2XfU3eD/JnOcuBerzyvjNekID/lIOg65jvfWWmuFdDTzX/ooOkio6RtAX/W6Yi1L
         wmhm4V2RZBmg7N0vtOhrf05z8gpcyy4hpUWYoLscUcDDe9/ZXfbbgy0UJweVMmYAYSOP
         9cAB1MzY1q/L6n/mF1LrhMoItLxBmgpUkcnVJatnBugnf0UEdwB5qtrVIEUFlGBt5HBU
         sVxBTnWU9GorzZ/G4zS7YS2LBS8cgJaKYrXm/O6IqHaUBxHQPCkz7IBR2T4IKMUSY5pK
         UUiQ==
X-Gm-Message-State: AFq9FYKh20QAWtZ0hNw0zw5Gk1lIt1e5198eqhiStFj/Wh6qexRUphfe
	t+9T8ax4AePSL8pPbR1FlB08MZuoW/H8bakLPhh+h4HQruI6KPlDWgiE5SVyU9/V3IjMSEdb7ue
	TfHcN/thsPs3Uf7762oGv5+1C70kQwwjKCrDyyss6058/2oQTcVjJJx7e+juAnRG7yoEz1g==
X-Gm-Gg: AYBFou1SdqQ7tNUlo4FUujEJBgu1chvcvahEbL+MDSImTQCJL8h7P6SkALm3KbUUheO
	NXwkOY/l7TIp+ikQl279+mv9rstXFGCY6QeoI3P3OoqYBLSAyAnIXDLaWPwfPldgc28oQv8tqhz
	c/XDX4MRXSw23irXtYawK0XFuvhd4PQyGpUqyT+3FtGDNuhObGjc4dR21fBI2jQxxjZX0ZMo0qs
	1I7U12tPOQKb/o6XHtU0qvi9Pe6+LuwS8SbiSbA2y9xi3WoNctqWvhyJe9uE3i2qI0nq23kvWg3
	a0LHGr2OvhGkIieDpzSHNYmEXNzsgCiWx9SPYdBsQ1UOZVNM3+xyV4UMgqxEb38ofEwHsWun5lp
	ATQ2RVtmhJvoAyw+Q+CvhoW9Mzx+g+dr5duz7rUDwrLmvRuny7Q2UAyc=
X-Received: by 2002:a17:90b:2d4c:b0:3a0:d7f2:5a58 with SMTP id 98e67ed59e1d1-3a6ce606ea0mr6489956a91.3.1791212995721;
        Mon, 05 Oct 2026 08:09:55 -0700 (PDT)
X-Received: by 2002:a17:90b:2d4c:b0:3a0:d7f2:5a58 with SMTP id 98e67ed59e1d1-3a6ce606ea0mr6489926a91.3.1791212995189;
        Mon, 05 Oct 2026 08:09:55 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5cae1bfsm9130075ad.28.2026.10.05.08.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 08:09:53 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Govind Singh <govinds@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Albert Esteve <aesteve@redhat.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260914-fix-ath10k-dangling-v1-1-15c5089682b1@redhat.com>
References: <20260914-fix-ath10k-dangling-v1-1-15c5089682b1@redhat.com>
Subject: Re: [PATCH] ath10k: clear QMI if failed during init
Message-Id: <179121299276.2358654.4837860539167198110.b4-ty@oss.qualcomm.com>
Date: Mon, 05 Oct 2026 08:09:52 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: X6E5u3-94smrraU8wVIbs3a68AezvKSx
X-Proofpoint-GUID: X6E5u3-94smrraU8wVIbs3a68AezvKSx
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA1OSBTYWx0ZWRfX3tuuwHW3Y6PB
 xg1qKkZIX//xArcuIK0DIUEwGTU/hVg/oZ/bqD2PLxBhXtdVPHEL9lGMlx/p/PJbK6y5NzhKufg
 dY2psxizRMbbAKAWcHzhFUcwMOmNDBo=
X-Authority-Analysis: v=2.4 cv=LuEHWXdc c=1 sm=1 tr=0 ts=6ac3bdc4 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=5T_40O9Wg91NOdeNfzkA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA1OSBTYWx0ZWRfX8CEslYrbwhiy
 S9Re3SeXVuMQqzHplIp0n1VhS7e0OZrQy3PzRw110XPbYElvnZJxjiGmxdh3pvvlJSAejuy+AkG
 xyJIn9g1aXEWJUHW4pJGIZIE96L8rBADQZCKFa3asi1HK6AuC1+es64+2r/QRsvukddEl6dRPYb
 YqBAZK4jm6CUN2G0HkqlKcG7zF+Ryk6i0yjR6SIZUpa7ln6wmhPF1Ttb4zVCNmZDezXlx/wZo8F
 ZH+24/Tc5a+G4tZJ4igdH9FG4hWIMrEf0Qu6BVfmHxyQOXOF7IhC94cclBF3znXm/Papc1gI3L/
 2Hlug/cgjHauNNszxDzd8gYd0Rew/i72XErx+qTJrqLKkFLXgx70Aadkm3U9lya7O0xUJjO+v+z
 jU5aes9RySgrdWl57fH4qoOdV5mX/UUBpiMjWSc+U/kjkHZxZfEcM7t8XmBztMXmUWVVMdlPVOA
 +l2KYOcTwpfPulT0s4A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_04,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610050059


On Mon, 14 Sep 2026 15:05:19 +0200, Albert Esteve wrote:
> A failed ath10k_qmi_init() left a dangling
> pointer (ar_snoc->qmi) in the cleanup path.
> Clear the pointer on the way out for hygiene
> and consistency with deinit().
> 
> 

Applied, thanks!

[1/1] ath10k: clear QMI if failed during init
      commit: 129324b60343dec19d45dcf87736f129b18b95bb

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

