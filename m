Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F504F3910
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790013612; cv=none; b=i/hwa1QUXJazlZEHh0VeQhRve+tg3vkqvDEA4BDKXXjgobz2cRUQw4l3i+1qusi33iIck9C/TSLtaUE94UlRSnoDNtJED4DtAcXuBujX0hj8ZuZLc/haHisHxJXXTyVDDLmSWBqlyM3Vx8mN0zYnigSCRhyit11KjRLOozzMLts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790013612; c=relaxed/simple;
	bh=qnjIr7ufpSiWgcA3UBuiw3KQKetDv48AI0yoqsaVosk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=G+r2+Ag1L83C5usRu6nXnArTz0K9XDuyZNRRxTuKTlctg5hQJowFgj+z+IFfl5IjS4aTnB6KSNI56J8Z0i45Dl2D/3pGQt7HGleauJf+9u+iV1jC0M+TzmF0+jLhUG9g+L2sS1d17qkrc2F8Se2ZxejLuhlsrwonvXW8N/zl5JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PLY162nA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YzTyVIHI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PLY162nA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YzTyVIHI"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LFAEPW1677364
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:00:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	RXG6SArb6rBNA99uIb237bVvZes3omrjbk8/Rx/1TfQ=; b=PLY162nAhUzCpbGd
	zr+Bnah07BWjJUgb4qeYJCBx/aoT+Om83QZYjbuWsw0BlSTgnLIRIliQg0TAlPTk
	nXLerp4fJPHMvGfBc7/cGP9gVeVQ0OdRDbDYXvPZEFXVimisLRzCI9HD8xRHw+y2
	reMuuU8npVhk5Ufi5qUlC/0UxF2WcpEWaCrhFDW5uNlQx0gvLJej0fIdi3hkOgXa
	cUt/CP83zHgWRpOLQnH2zKeTcO7v8Nz3gvnMPUx+EXBc5sYqEuHshf92vCmGfO0V
	qujSlh5QRoRdMH6lohXPkaPelD7qB2slnAanyWyh5GekwGvvvPmIR/C0j3szeoSC
	BZwfiQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu3cshs94-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:00:10 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39e3dad7ab3so4438252a91.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 11:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790013610; x=1790618410; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RXG6SArb6rBNA99uIb237bVvZes3omrjbk8/Rx/1TfQ=;
        b=YzTyVIHIUTaxxNY2ScmAfOsCEB7obBUjOzVmis/MbfGoxalnsB1fhOzmu4OBAlTm4w
         05jAbCE95oMRnd/2YDY87CK1J2Y++Km/v4G5dyhzHSKW4zTRh9ZTfU0PF++WNxb5nuYQ
         BZoKl4PP85VLFLKJYXtsBMAwFFrbn+Didc9+7IJb2t05QelGzLYZ85pMejLGDbXdpn/s
         1GBfdvScdP5xipD0kO4u5P4W8UgDD24/jmX50cru7GI1L31zJIlO9HAaquOUG346/C0U
         rBrQ2rTi6YALJZypPlrc7DUgqI07BPNzjBYnRCM8dh8I2nSJTjY4IwrhEftnJoNzxOCv
         N3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790013610; x=1790618410;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RXG6SArb6rBNA99uIb237bVvZes3omrjbk8/Rx/1TfQ=;
        b=O6g09lhM9A9eTuKIp1r5hTL5I1FcjOkeV3Nq8wHhFwuBzZPSUCZuXBl23ZZRNqf1mG
         GiMF+xzcCLTMpxkWj/b4aoKmVAmjyrlGZYghDsiaOekrUYEuPi6oDXlevMTLzzMqmJsH
         A4WQmcMUJgHdDDfbnNI5C8+lvb5zuSoQh6z9mWfQC8JeyshMDR8SbAc6ANfqxagcbW9H
         fZwjn3quYKQjAKPlg/5R2utaFQUEw54i7g/yGkcpFbwCJZKCLkPgu7oiS3/1bMYCE1U5
         FPsx58ztkC+YzJHbSjgWvkHMQA80nSDjPbl4VLC9N9sgKtYyLvmmqKe4/gibCYL0t+uQ
         6tFA==
X-Gm-Message-State: AFuF++kheNmkFtid/vHLB4ML9iZdyHLTlpAorIOAGq2dH6lYsrVAXmaR
	cKlbBDLizGP9u5zKnzt0NlCWj5jUJHGcKJdO8VKa54PshlduIZ1Kd3WhIctqaiVOzqju3pGoSed
	7xaY+jQrmGDj07yqzAPycN8Pzy5NdMGY0WmKV90TBJ2t6jbRZTOpSG3lPLXoPR1Immx6vOACICT
	YG0A==
X-Gm-Gg: AYBFou0Dn84868N+HBxryVcmNeY/lz8Yec2r6PcIOIDc/hxiFgBPwcYOqFTR7DH7eiq
	VtvzvIeE2bqS/+8rI9DlxA7/s+b24THMy/6w/8AulZZbrplptd10bBuK01L6bEPUWq1S6L+w5ju
	M/dZAgvPVACsWlg2r376vgUdIcORKQYwg4iyoDnI02kgZ+xMQdE5j8NwwJTkXB4XDIw+CSuxriZ
	SttIUFbW8d3U+gPs3Bs6xG1nc9K5qKbLUZbeNhPbwM0u9sCkFM/W5DxYXet81NQQZXrGzSuJLQZ
	2vuGUlG5iq+C/dhSOXebaLKunNuG8F5m/3fQxc/8OtFkQo5RnLp7LFGBKoXhZpz5/+wIcnYbCBV
	fGSw3xLYcrYmCC/XMRYWbKzoSxDRrr+CdyK20QBQcsp95eDo+FqmZ0A==
X-Received: by 2002:a17:90b:5706:b0:39e:6c6a:209e with SMTP id 98e67ed59e1d1-39e6c6a234emr9581506a91.63.1790013609649;
        Mon, 21 Sep 2026 11:00:09 -0700 (PDT)
X-Received: by 2002:a17:90b:5706:b0:39e:6c6a:209e with SMTP id 98e67ed59e1d1-39e6c6a234emr9581469a91.63.1790013609195;
        Mon, 21 Sep 2026 11:00:09 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c3311a716sm22873198eec.8.2026.09.21.11.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 11:00:08 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20260908170520.112946-1-toke@redhat.com>
References: <20260908170520.112946-1-toke@redhat.com>
Subject: Re: [PATCH] wifi: ath9k: Clean up device initialisation guards
Message-Id: <179001360837.250336.964591354535633802.b4-ty@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 11:00:08 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDI2MyBTYWx0ZWRfX7rXzOfzFQMBF
 2ACMxpuyPk5mnsNymohMuJ00ghal9JrmefdkWst33B3chgigQz0cbLt3Utm+ntRewfEYjDJAfmz
 Iecsh9baQ0zUbP5YTupCzcdUafChmo4=
X-Proofpoint-GUID: XodVhyg3rMk6LDrGR3o6wLPXWx4_9Nr_
X-Authority-Analysis: v=2.4 cv=QovLTlyd c=1 sm=1 tr=0 ts=6ab170aa cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=WD2RVSGR4ZOmZR8fVjQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDI2MyBTYWx0ZWRfX7qgAAKCm0Uw9
 jVm5l90NDQS4LAC8wSm4xj318GriIkggFqjOlZzBp7seX3d9HFqzEh86juOtCCVi7Py6kHld9C8
 RFGCgI/3EdFM7SGZdO4k85et9CpwV40Bym0pUNTh4nY7a5GeY/8EukP+AhBm4iQCk9lbwUAeY4E
 f+jbSgp2MwN3inuIDNQn5xvm8l7KjVtTxwmzwHad3QlN9b8dvIBhkVADz1frl0GuSJ+ROXvQdDT
 GdxKN34SOotuqjyCkieEOTfQOwMESXYudFzof2S48xhuKDz0IJodNDWHj7U0jdr5CSv8D6BDYbH
 Fy0dX2tdLe3JIaq5P3Lb2L02ueWu4rnZ4SV3iD0JBGhOMzcpqifb7TWJ0hg7uwb75Yow1kcKVUC
 1XYGe8AV25AEcaRwGmJYdbxLsHdiQdeEL0RqTtyLMgje3KP4zen+ku80EKkUYdf8qEjq8p4Piel
 d1Vm+BNOlVhAr++i9eA==
X-Proofpoint-ORIG-GUID: XodVhyg3rMk6LDrGR3o6wLPXWx4_9Nr_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210263


On Tue, 08 Sep 2026 19:05:18 +0200, Toke Høiland-Jørgensen wrote:
> The ath9k driver has a couple of guards against the RX path running
> until device initialisation has completed. However, they are problematic
> for several reasons:
> 
> - They use smp_wmb() paired with a data_race() annotation, instead of
>   the idiomatic smb_store_release()/smb_load_acquire() pair.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath9k: Clean up device initialisation guards
      commit: 1af8dc9ca726cf53767f9c0661171396f95c146a

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

