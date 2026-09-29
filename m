Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A345A3CB2F8
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790691869; cv=none; b=Ra5q4q5MxuqYroykNnPnAvEiIXRYAE3V5OO6tAug8RHytlAlRiTtEObzyeO3p7yAi3r4eEOBv7mt1I5C7KHtvxVZRaHs7QTY+QKnKSl5j9iISOmkHAnGF0zxqkhNCXcOXMX3bCFkmZkt8RQFrDGnTLhv+oNZA6xw/e9hs/eoXe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790691869; c=relaxed/simple;
	bh=zBJy8QBBxbOEZNLk4+nQd0jm68kLRG0Rh/k8TECalXE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=D5xB4rOTpAdy00xLehNAu4uHl3OXwqMTHyw+Kk17dknCd1Gb1GKnzMGUx4QzCSZ7+9HaFALFz3P/FKICqAoGvCLNCLdI3F765OQLMufBFgBG8ib/GhOlcFdhKBaLm7al6l4w/GtgO6NV63m7vL4xYiqRejEPsf2pZVALlsuMWu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iUMJKNAn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TggUXdvY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iUMJKNAn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TggUXdvY"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TCqe5k3842772
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:24:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NQntaQMdAv6bwmg1427kVvEeX1pxaOhWQXRF0oq0sCA=; b=iUMJKNAnEyr9EIEY
	7sxN4UC9Q2iDr8I+qVYCt4amid2hNma3P+5q56O+XjggR0tThDG7j/mZr6sRDmpd
	rDYy4eaNIL+AvkR6BDhDsUHoduAdqkppGUKxBjjV7fSTiQ2Dg4zemI0e5trFJa9D
	y9Av8qudgf8+tIvgQfcGpNo68vUm5uxAxto6HyBEHxnrpPPFzMc64NMOhFIjFKtD
	rryCA00zZC0YbGITWK0qsfS/AwCOZLZ+G2Ejt1CgrGx1UaeAI+yll4+Qe4U6Eq+T
	0LPuPjoQ+4vcRWAGuN06Za/+YKeG2nV9xlN4xU3BZVkdB52sEBeZWAgiYdnkKLXQ
	162lKg==
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h0b0v95vq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:24:24 +0000 (GMT)
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-1438fef603cso8977313c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 07:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790691863; x=1791296663; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NQntaQMdAv6bwmg1427kVvEeX1pxaOhWQXRF0oq0sCA=;
        b=TggUXdvYRKC21LxfVakXVKTI20dWrpuy3cBiCzVzcDSmOAf9BoBeOSJcYCLyjNW5iG
         jHHepV5FJHRaaZA1v1DXpkR+NMV19ARVjRZbr3oNY+wnU/ig4lVyJCCtmSs50tyTu0Zc
         SBoSLbywWkuylCLhD8vFLvNhQpsk2nuMd7wmoaH3nKPZfsWeXB9G95yZaJX+EeqsFUPj
         hOQw/F/odUfUtpeh/kaZ27muWE4fdJZqUyIOOzNW+wawlQtZrDvDPIq8i8+riuQ44EYV
         Z3zPS0AMee0D+/jZAtpvbml7O41DqeBdHD8/PknzyuZ9wC5+eWIGUqgJlO8ceoAzIcJR
         n5IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790691863; x=1791296663;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NQntaQMdAv6bwmg1427kVvEeX1pxaOhWQXRF0oq0sCA=;
        b=VmRClOas+DHauGYsCiR4GQYPdnCDFyHn38Fqcd3WnpQf7osHCcKWdRq7WoQfxJQm5e
         1bKOgFKz9lxFfhIQcdRzmR8cnCxIJ9VzMQfteccdnbkw6JIEXNd91QBi7xJIN/7+7jUJ
         qcN9jeMAjiaIjwbMjAOMZz55l6aTtq+HkdrJwFRjCjlEvFnp2jHLK0+FvPl8sUIgX3Op
         Zu28qFQ33AMFiFpxbMQvPeQmgOfESnjkpw3GADOWbNPyjWwaMpAJ/iR248w7MvOSKrxo
         6K+zpR0nny8pxSxibYV8H9qtfMQm2lV+ljho389JG3KypFsDJPSx95vf38tYvEn3Z8x7
         RCeg==
X-Gm-Message-State: AFuF++kQNd/wy26moFvqt2cvwGllhsmWqlDaaFNfSfNosaZdqiw1qoDX
	2iVvKmYwG5ccNZcqRG76Aojw+4gHPw1gV01bvnydu5c3jWT8wqltLLG08CfgEiBxM8eXFJjsZX9
	QPF4wCUid9YlyBUxt6At0dPmFjI9fkkO7fSoZNYjsZXtkg3jFMBi5YHCZcu4Q8x42N2N6xQ==
X-Gm-Gg: AYBFou2bgRRJuYju206/Z8JpK3Ao6uvukJKmHMqfWjO4EX4A/i5XUUSe/EMlKQGWIoc
	GWdiRJilqL++tspldwBM4N2NtNoYjgIYGwOiN+9NkUQZw9t4FUQF/Z0Mbg4D75x8xXIOk3pA/F7
	LOIo2whcuaMoUBstmaQzMEh4pRsc4QFn2mZ3hP8KwGQ5lzwVxo6SlnauA/XWZtJEje9hvkWWSd+
	tq2dRQalyJS4XgBcS68jJv+9ueJWAjTE7oUTKIU0Z5Ot9XfqsBVBCL/YTef1fYEb991Z6EMREIM
	WzK+ENXDuaDzliF4OBI0J7KJpLMaMbRIPVcekIzSboGPDKzkaXdgifIg/sEmGE4KVX4pZX5Ie/f
	LxStC1bZKayxdlhf42wfc3QAXmNCtUt+NFkPqAKTwxS1YF5ADDvP3xg==
X-Received: by 2002:a05:7022:380d:b0:144:eaa7:2758 with SMTP id a92af1059eb24-146ce39b1camr14807602c88.19.1790691863190;
        Tue, 29 Sep 2026 07:24:23 -0700 (PDT)
X-Received: by 2002:a05:7022:380d:b0:144:eaa7:2758 with SMTP id a92af1059eb24-146ce39b1camr14807538c88.19.1790691862289;
        Tue, 29 Sep 2026 07:24:22 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14c60c55ed9sm63209c88.2.2026.09.29.07.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 07:24:21 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>,
        Julius Bairaktaris <julius@bairaktaris.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org
In-Reply-To: <20260928-ath11k-unbalanced-irq-enable-disable-v1-1-75166f534763@oss.qualcomm.com>
References: <20260928-ath11k-unbalanced-irq-enable-disable-v1-1-75166f534763@oss.qualcomm.com>
Subject: Re: [PATCH ath-current] wifi: ath11k: fix unbalanced IRQ
 enable/disable during suspend/resume
Message-Id: <179069186099.4017622.11718063394355949427.b4-ty@oss.qualcomm.com>
Date: Tue, 29 Sep 2026 07:24:20 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Proofpoint-ORIG-GUID: BnJ5tTq3izWMFzZdrWd5vrl6EZwq6lqW
X-Proofpoint-GUID: BnJ5tTq3izWMFzZdrWd5vrl6EZwq6lqW
X-Authority-Analysis: v=2.4 cv=Z+55j3RA c=1 sm=1 tr=0 ts=6abbca18 cx=c_pps
 a=SvEPeNj+VMjHSW//kvnxuw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=Tf6FFpAjyP9XlBvCETIA:9 a=QEXdDO2ut3YA:10
 a=Kq8ClHjjuc5pcCNDwlU0:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA1NyBTYWx0ZWRfX/pF1e4355Tbd
 iLbr1+CqnJEki/vzG/tSC4JYig7Lz/0tH+B/lgfo+V1EY3HuoBtwm//1qBl6YOint7D+jP7T8fS
 eCqV3vCCWe44lLOzlLevPtXna9iQtRHBcE8ls7DL763FYXMilUnW97UAZXNviHdu1LR71Gyaqpl
 h6deLFlVM7WjEkrcy8G8UEESF5Zj/6r6nY6N5l/kgHsyY6ZB6UPUcrNV7TpoR0u9BFQJ3a7Szeb
 6Z74tN7ZPvJT14TrtfYRa9CUqTVmbPzlNdR2I8aRTWu2mhJX08D2QCAnD0F29DH+MY5K3bEv4wk
 4ITJO2dPitIpSe148cMIUJTwEb/G/nAmUrFya6E6Lq+APBwmYvLeJcez/q/PGZSplB2tJTIL1Uf
 B4Biamtk7eZIPeibtsQHKwf6ZFWUHOE4pTkS2+Q/2juHlITpdUwLZ1PaqOKoNkQyQvSY2VbrTbw
 eXQQPVPitmP7ntpVA+A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA1NyBTYWx0ZWRfX4wvHRB375Ag2
 UrRPhB5RgdXZnJuqUPRk2lOTcEz5mUMb0/8KTtiPVjWMQrlMIlDwHrA1sPuGJ+Csdk1ZPWg5bH0
 fWN/Kn3G6B+KwCTeURVbJ46DuLXVChg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609290057


On Mon, 28 Sep 2026 18:45:25 +0800, Baochen Qiang wrote:
> Commit f7a74e131d3f ("wifi: ath11k: disable interrupts during firmware
> crash recovery") added an unconditional ath11k_hif_irq_disable()/
> ath11k_hif_ce_irq_disable() pair inside
> ath11k_core_reconfigure_on_crash(), guarded by "if (!ab->is_reset)", to
> stop the DP NAPI from touching rings that have just been torn down. That
> fixes AHB device recovery, but breaks PCI device suspend/resume. During
> suspend, IRQs are disabled once in ath11k_core_suspend_late(). Then during
> resume, ath11k_core_reconfigure_on_crash() sees ab->is_reset clear and
> disables them a second time. Those IRQs are enabled only once during
> the following reinitialization, leaving the IRQ lines masked. As a result,
> HTC control responses never arrive, and resume fails:
> 
> [...]

Applied, thanks!

[1/1] wifi: ath11k: fix unbalanced IRQ enable/disable during suspend/resume
      commit: d52302171b61dbba6c9c15e80e9a5f02f1e9f95c

Best regards,
-- 
Jeff Johnson <jeff.johnson@oss.qualcomm.com>

