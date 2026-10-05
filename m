Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8D04C14EC
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 15:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212999; cv=none; b=YjBlDnMXtxvCjBOn9Hh/dCOeUv9eL5GilcoQIae46gXDOTgQu/CFqRJx87OA7u1STX9vRi/AACQNFyCgFdDhXut7q7ZJ5P8qJ0jF8qtTn2EhTFDB+JU6Vz4IlcbccI6c7nzuTZVvozYiaGiYrzRacidNbkU4E0fVVufk54tB4Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212999; c=relaxed/simple;
	bh=z7pGQWfb1LAA/kgbLXti5Rmd5f63nEbmiUqodt0mor0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OSk0IGlTprXjwm67/TKE8dcjwdgy7/JUPNhe5CD214o3DFxnvoVOwK2QusZFdnQQjNpp75IASE27obg9e7jVR1Dy92WBGTJgMz5QyHUowc28H0izzCqQN8ngCUg7GDa3hJ8MmASyXVEbLDa3AmyYJF0M3fHTp07Z+cba4RdwakU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MjLF8oYf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dLTloOSJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MjLF8oYf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dLTloOSJ"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695EP8ir2515704
	for <linux-wireless@vger.kernel.org>; Mon, 5 Oct 2026 15:09:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	k7BOMJomIb9HIja7jhV/C5sopCF+u5DG9RsBVy1jMAI=; b=MjLF8oYf6UQDqEcG
	hhN+MQfqZvDMVlzvUnqzAtZ2EUVtRgdJq/Fb8a27TIfIXF/k6ddlobO9ycR9TIeb
	h1dT6XofYnZ5MRHL4xrTAXRL+Ll0pc8nz4/oBNZyltenionpC3uoLFR5T6ikvQ8Z
	NVRDFxZwDHWDjZDvNf+S06YXdb9XTWFGW5LQ+570KTU9nvbFlSZW4yC9oybyhM4m
	2DoeChcmuZPnm/W+BPpJ2Zbfc0OVqCR0rOkaylpY9OXktCPwzzdfLpbUfgpXq4hp
	JFmSPcR9woD/UvIEW7o29bGzogbYgrHbZcyQWQKXgvxAeiqMBz8VpR4KL3YecmoO
	E1Aj2g==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h4bhg0ser-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 15:09:52 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2df5a65671eso22075885ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 08:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791212992; x=1791817792; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k7BOMJomIb9HIja7jhV/C5sopCF+u5DG9RsBVy1jMAI=;
        b=dLTloOSJtSv/2U6ob2YPoWGsPDR1K/4g+ZfS2i1O4uA/OHBf/sr0o2hsjLP2Rqe6F7
         Ui9UxPvfk71Q3506AFS1+lPUlVHq4NOK9qC1GM7DgYgjla+VHKj0b1V/maVyMEZ3eJvC
         KpncH+Ks8xlYvTiKZlNiGgNCdS5hHTNVv0m3WzNI3yNVI6oekMAChnSP+vAXhXYL2kqj
         CjbXdC9iwEIiPYvALFZhwVJjcQRdPl3lEBxk4PYg1rkqTvkyAlQxbKHPr5ftfJJuB5Rz
         YzCGN65Hu98TiTULLNEG40ZCCniWC/1zbZd99UMR4x3JxaNfxipaJ5928lyvRYqK2LTz
         VSSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791212992; x=1791817792;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k7BOMJomIb9HIja7jhV/C5sopCF+u5DG9RsBVy1jMAI=;
        b=C1QAoP4UW+TnkRokl+O7raJVcvFT6b0H2OoMuLjR1qTEbXkVHakgSrUsuSNqGNgq3a
         FVOENUtk0uWcaGlhoVQGS7aj7lpDV+1/Yq/1sLAnAYa7qinbuD2p62bP6yrD1EvVX+I9
         Edj6kmmGAQxSGzVD9grdxZh+NB8ZHlW/q2fTgrmeU2FW9yqAIPR5C49bXU1ZgH+LiRFM
         bf49z2XFKOerCMlXYRDhuTdalsQHDagdEuas9TgaIBhahCddoA7iq2sxRuuRBgA+xpPF
         KHWLZYE1hrjDWCJasf4HfO5RKY9eVaK6KqLvKYYkTafEiPpatcCPVTFAag9YB9VBnziC
         Yskw==
X-Gm-Message-State: AFq9FYLPsrbUph7RCz0079vVuNIKwmF0XA9FuOre8DTHa3BCIzQ8WR8d
	AOEzEYxzxWf8qZ390H9Aw2Mu4UdrAKELby/H0SUaW87X0KSorn0z+uMplRy+hquQolq/5bvcGyj
	p+PJOBlRuxiDj+ZEj2CXrClXbr6oX9MOaeFBuwIPRl4G17RkDbEf/62Lh+/3yjzBMD83EzQ==
X-Gm-Gg: AYBFou2qQBW/qx6ZaASJg/czM3yIE7tvX7WC2yJG9trQ6yfb/5h0Shymc9OKFhl3cUu
	4NRdGuhN6R7VNQVJtI4TRnA8DJgJGmpEKd2JvTyxR/UFAmkMIUnLSzkGQBGfhMdg6FY8J+3/kKq
	sBR3LE/13+X9QA3E77hyBl6BthUG8UxTy1suWvsnjEXmtgp+eb+RcY+rY7L6igs1l9ICZv4GhzD
	aK1tQEbPikG7ygVd9DldySMTdvtD5mldyCJF+BhoXnxM4lWSENKQFiZCSyqYNCetA8JIKrx+o0w
	XxACdQ/o6eNVy1qcAwPlOWqE5PLUtdK3mWcgEFxrPJgAEdMT9p/37FsGHIIIUK6+JFrhB0Jf9oF
	i6mEAM+/TJBS0iSNcEJ9dfqNt0OSb6O5OylXk+RyqVu5NeVh8lHSlKhs=
X-Received: by 2002:a17:902:d512:b0:2df:375f:b7ee with SMTP id d9443c01a7336-2e49b675014mr77177765ad.18.1791212991935;
        Mon, 05 Oct 2026 08:09:51 -0700 (PDT)
X-Received: by 2002:a17:902:d512:b0:2df:375f:b7ee with SMTP id d9443c01a7336-2e49b675014mr77177375ad.18.1791212991307;
        Mon, 05 Oct 2026 08:09:51 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5cae1bfsm9130075ad.28.2026.10.05.08.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 08:09:49 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: linux-wireless@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Cc: =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260911213144.130192-1-rosenp@gmail.com>
References: <20260911213144.130192-1-rosenp@gmail.com>
Subject: Re: [PATCHv2 ath-next] wifi: ath9k: delete channel-context timers
 on deinit
Message-Id: <179121298946.2358654.16856566476480505783.b4-ty@oss.qualcomm.com>
Date: Mon, 05 Oct 2026 08:09:49 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: TgqaGfEjNc-5ST8UxKXs3nlBuGq4VUv3
X-Authority-Analysis: v=2.4 cv=GMGdgeNK c=1 sm=1 tr=0 ts=6ac3bdc1 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=7eYl0IV7dGDCLOCTNgAA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA1OSBTYWx0ZWRfX/JuEoZ1DiqiS
 MCrv+VUH8a/EmANK7iPalmt3GmbeQTlYnxjcUG9riuWuWg6ESs6872ZCuhhaPfBN9c7cZlX+8yL
 bWTqDZ+UhaLulSU7HFOxMLRraA9AbYg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA1OSBTYWx0ZWRfX9oNXG0b0y3sB
 dxLPzVO5pcmJXxhkqfSmwGMgd3m3B7OODP6AOjNDsp5AaNaLpcxi3J2P7D8JFjI/JhrPnb+FWI4
 fELRG+zbDCc/atcds+WTBsKqUGF3+Z3Ae4k0jH37V5h5DUX8mAcea1yHSYBAbbXQ8HPIAWajB4y
 G+onArtyH3m2s+xKKF4grgZO7Z4NxIS1diLPt/RWtVmOLdEuIS7Ndcjz9ABD8vAb9g0bDkRfnWd
 P/jjuVkZfgnXO+uSwHaYgTUKqdHCREWkIk6CBCFI/t+5XK0kn92JtYFMBUqsii61Hjk2ntWnlaa
 SlVAfsQxLOMbmrY8oVQcRsysmEB4exVozl3JTYx2x3khNr8AHcVRTylkFdPbgmoVunCMyVh6AWF
 OxV6dB+j+GU8L5iesABkxnjhdfvh2Q8lTG1QlizhYyFLD+vd6f0IF0XykTeKLWTeQHmuO9njUZN
 GoVgnl6rs+urmzgVhdQ==
X-Proofpoint-GUID: TgqaGfEjNc-5ST8UxKXs3nlBuGq4VUv3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_04,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610050059


On Fri, 11 Sep 2026 14:31:44 -0700, Rosen Penev wrote:
> ath9k_deinit_channel_context() cancels chanctx_work but does not delete
> the offchannel and sched timers set up by ath9k_init_channel_context().
> If either timer fires after deinit (e.g. during driver unload or
> suspend), it accesses sc->sc_ah which may already be freed by
> ath9k_hw_deinit(), causing a use-after-free.
> 
> Delete both timers with timer_shutdown_sync() before cancelling the work
> item.
> 
> [...]

Applied, thanks!

[1/1] wifi: ath9k: delete channel-context timers on deinit
      commit: 81394dfb9a7905472957628b560ae894eae3a30f

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

