Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85CA243387
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 06:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788329180; cv=none; b=jDB4T1OkShV7N21VzEDBuzQETV0Y84fiuu48nTgvPW2FMkO3fPEu+5yzeRuVF3ZMdAS1Cql3BXid1vAAi4iOL0oge2N6aJvW1JS+8KPCR6DqvAH7QOV+Wo4dqeHZY6E4k10flnpD94DC0bYzgCNRaPkzr1kQyBO2+AsZIs0BLgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788329180; c=relaxed/simple;
	bh=6Lm6mSsXB8uS1BU0c0jzJNyf1KmULSzxJMaecOduInY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MjIXS/JLVJDkXjE5idEjG/YNTey2M60X3YQItP6EeRdFmmDP6fVEt8Jqi7aSzMwRpJkiGnLrDQ3hXY9widtJUsXHv7VGKwwk0fw5dPeGQ7LOCo0Jy5N21ud4DzlnLG64jnqcQdwOjpAThK0GsrnLGUuaUf8vKGL8t6Da9BSaeeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WPrwD9WT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=S2XNEP79; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WPrwD9WT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="S2XNEP79"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6825YJqO3630639
	for <linux-wireless@vger.kernel.org>; Wed, 2 Sep 2026 06:06:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tgWNP6qLVbMN69vs1xIE4IuqaLsloF7xQyx07Wr7XwM=; b=WPrwD9WT8KqaRfXh
	a7gZ029rnmuc8CabOA2bkbDvCPIQPou8RP9S4zEDayHAhSAqvFucoev/UN/xy+74
	Z6VELw5w2R5QjRSGH3Pq1jOhOA3bGxmQRLIBljKXHa60DG2Qf8MdCJIcApK2VHDr
	QyDEFm1nf92+60ky7CfRf2BwnFbmlwxB9v5jdTjKRHZms+rCFYgAgesBxabtBVTL
	UOAYGa4Ea64FaeD+Es2z09VL4S/gQeSj9DV4yXvbB5idFuDiagSw9JioFj40q+qw
	0n5iCwBICQly1ALZzDV9hagHvNFcF7LR3vG5ClwfV0yJ21NTIWsbi75sFIp2ZnwP
	9eaN4w==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ge39cjbg0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2026 06:06:17 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38f283baf1fso984600a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 23:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788329177; x=1788933977; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tgWNP6qLVbMN69vs1xIE4IuqaLsloF7xQyx07Wr7XwM=;
        b=S2XNEP79gMs9eNT2dOsDXdp7RQIne0cLlBOHHR6kkmQhCyVmDbYg/bWQ8pNseVYew4
         QRs7vUkbrIWxKFndt14qtU73OoW0niE0KfrF4GEg8c2+eArhxXPY8Mw6zMT3ylW0iMDG
         xAM6Zn9fc2/pnAWlY+NGRdbOeV+5dVa0BnoQfRYpSGRf31SB/dqOzeFNjI/2yCr7oho1
         Ke6JvdQpMgfK6k6UtD4nQWnHYy7G4Nysr4LgeE+hvp6hGXEWVohctV4C3pvaS9NWZ44V
         xZMrydj3GX6fBzT094kerdBp/kbPqWLGkuBLEf5BkolnIai8AnToBHrE57dZZ6R2d05W
         rPKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788329177; x=1788933977;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tgWNP6qLVbMN69vs1xIE4IuqaLsloF7xQyx07Wr7XwM=;
        b=EEJoCK1WiFYQ5/nJyW/DGEkeN/96Ge6qWO60wLW9zK82El2yH5C2IOx3JWChw26T2F
         MjIa3rZn0DD5hktOdgcC48o+/VgIvhbXEAHcsg1p86SaNei2hwvuPAAHRKxNHvQR4AuY
         S9+UkhdLWAsukYDzeJUEz7uqU6g3fwE4MgIshSndayXU4QNN0y+ew43bbboRY9QVx1WD
         3axjk60mFPRzBhbeanhXc5kamsFRh0bDwA7K2n/FpYyTPS2wgwIvUlU+fUBiPoU/uuff
         eT311xTeAb/JAT1YSmPEHSXz+ZGLKDUMImFmMtUZhuX78+9Sb6ojmrBue9RZ8zqX15QR
         T2gA==
X-Gm-Message-State: AFuF++nmbwc44u2ufI9oFsETzKj6e6sUwA3RAw47/9sN51PyyOmuleb8
	4zyBLz4LV4DHUHLyvB3abQMWspjZxuAT6wxlYfZmVk5+LPdrvh+FfbYrjXv9bvVF3wi+U+cMx2q
	kAMzZzPOG8hIqYN3eS9pBNb6+h7XlnAz9AGO7OC3rOS7MaMx9GOVZhY29oPdQ+xgqT9qJBw==
X-Gm-Gg: AYBFou03X26sBKwGGhGlcWvLTvEM3k7NLyb//SmwXHsoWIOhZhMMZgUl32CDdKa7ROz
	rB5YpAfMYU295WyCZ3iOi3jjY+rzgdwLsSVDdEQE6evY8mC9F3KLnQXLievIGyH3GFygs+/vu5i
	bCYi/NtJqrnTA79ssYCfxu+u59BoYfRVSQ0Ttv5qVuLgVA54hwHxV8nnn3qLKzDsEt0aLcwCpBy
	zhmi3G+1pA6qJFkeA0bDlDVXZwjLSwbzMucJv5i7E+3xnbx3BKbXcMWBKWXVqF6x3zFylxQS+9p
	hBfkhTBx/3jacs0/Q2BpXaA9vG6Uqgget3Pn9S3V76S05MSi4T6c00hc6W5RUqxrdzedGvPlFOG
	HD2klv8JFMAHfB/94CkRbgsFWOb/PYJFvqP0qB1W/iQdq0cM6OOLh9V6m525nVTZv9Kt6c3k=
X-Received: by 2002:a17:90b:52c8:b0:398:9be9:ab8f with SMTP id 98e67ed59e1d1-39aee125891mr3382140a91.20.1788329177130;
        Tue, 01 Sep 2026 23:06:17 -0700 (PDT)
X-Received: by 2002:a17:90b:52c8:b0:398:9be9:ab8f with SMTP id 98e67ed59e1d1-39aee125891mr3382082a91.20.1788329176573;
        Tue, 01 Sep 2026 23:06:16 -0700 (PDT)
Received: from [10.133.33.22] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990baaeec3sm9846860a91.0.2026.09.01.23.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 23:06:16 -0700 (PDT)
Message-ID: <0ed9ddbe-4591-4653-8ec0-06301599c89b@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 14:06:13 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ath-next] wifi: ath12k: preserve PPDU state across monitor
 status buffers
To: Kang Yang <kang.yang@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20260828065534.1537-1-kang.yang@oss.qualcomm.com>
From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260828065534.1537-1-kang.yang@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=T968ifKQ c=1 sm=1 tr=0 ts=6a97bcd9 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=YJL9QbDTW_f5VMqXTPAA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: jW-jKzR_Ka1sojIn7uDxlOl0PuT705s3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA1MSBTYWx0ZWRfX/EHhz/NthbHq
 M6J9cV5LJtGtePcpYGvla0/aa97KkQV/Hw20iAshqk2RwUgpJX9u+6jS3oOZxzkM9TbHHyQcMt+
 mcdvEiimx0h8Uv+yoaqglhBO2FWlKtI=
X-Proofpoint-GUID: jW-jKzR_Ka1sojIn7uDxlOl0PuT705s3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA1MSBTYWx0ZWRfX/fRtFGUwgELJ
 CiyG3vgG77K2GzRn1XfSGVEEmDcr/q5G7o9kapMB+Z7xE7wPh/zXtLmMdrqyHSKIqc6D2bcPOKy
 /fh7sjrZk3fG3tBd98pVI7W/SPz5x7z4Kq5eJvhAmzDCASQnhfnpAgrXuHCUXF/Qfi7uOQQvhHP
 vSVdQj0KDkNeAfxY9gcfIuYFRb6Ys/9qozuvF86Bornke/xO7rHXWSYVfvAt/Hnz8/Tz9utbk8V
 sp1WR/rcixQs9Kr+iotJIxPtUrvAcWk2vYeOeso0G6U+r9drdO6zVbhtxVdSM5fVk4M6Wbj8/Y8
 gCSWpwe3jXIWNuHy8Qfqym3FtAwvdPMvpWXiXhP20pIq0VqdjsfGyOJpcavYR9gleIfgYiQM75y
 NnH9JJWvEqIvaoB6T97YQpo3K4vtw+541/WbfMo1wtEfifQEi17WXbmn/sDlQkg03RqInYoJ7I9
 +IjuJAWfa4SQbNPB2KA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_06,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020051



On 8/28/2026 2:55 PM, Kang Yang wrote:
> A monitor PPDU may span multiple status buffers. However,
> __ath12k_wifi7_dp_mon_process_ring() clears mon_ppdu_info before
> processing every buffer.
> 
> As a result, continuation buffers lose PPDU state collected from
> earlier buffers, including ppdu_id and PHY metadata.
> 
> This can cause monitor RX processing to fail when
> ath12k_wifi7_dp_rx_mon_dest_process() observes a PPDU ID mismatch
> between status and destination rings, preventing MSDUs from being
> delivered. It can also produce incomplete EHT metadata that triggers
> warnings from mac80211:
> 	Rate marked as an EHT rate but data is invalid: MCS:0, NSS:0
> 
> ath12k_wifi7_dp_mon_srng_process() already tracks status TLV
> continuations via ppdu_continuation. Apply the same logic here and
> only reinitialize mon_ppdu_info when starting a new PPDU.
> 
> mon_ppdu_info persists across ar->monitor_started transitions. If
> monitor mode stops while a PPDU is mid-continuation, ppdu_continuation
> stays set and could leak into the next monitor session. Reset it
> when monitor mode starts.
> 
> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> Fixes: 78d3d907d0f1 ("wifi: ath12k: add support to reap and process monitor status ring")
> Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
