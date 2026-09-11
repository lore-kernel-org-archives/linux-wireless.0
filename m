Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980193932EF
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 15:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789140508; cv=pass; b=W5IMbeuqQMz2RMP+9WGO6jmoj8CHUuykVpNPjEv8Ossop0oz5nAJUInExkjZQ3ZOd2VEwNtpm3wjpXtlRLXKubyvW74FCsRXYP+HZyiGEquUGTdEYUlpDrAs/hdUtnIf+tjndfKOs2dFIj6EtjC4on50hIoL9yOttAkLjYsoWy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789140508; c=relaxed/simple;
	bh=R5n/jjsRA/NUilRaVSmCDbA1/CUgsa8ZyoXeF0hNg3k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NhQ3Rd6aRVeDq7UjaWrxQlTylJxjHFq5Lv+mt9jrcZKCo96rrUFgAPQKv++m8XkD+nvV738298Xzc4ajCKiowcfD1m1GVGsH+yTAMRYg2AEy8fhtc/+q87ZeniKmmtJqhp1AFCtCjezohkQtJSC1CRdVNEUe39yYRvJ2F7C4q2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iofmqfl5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FsGULuh+; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iofmqfl5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FsGULuh+"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68BEm1DY269336
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 15:28:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	svMDt6dlhUloJNhLHfCFC18SuqeTtDnWBl2KFSnEON8=; b=iofmqfl5nUKEyiEf
	1wn6qM2a6QbNKP/CgNjsJxVOVb1oCEbjVJKoMNiryd3x1Nz16/z/rWyCA4nGhLVT
	Cs97sGwJrNfAgHqX2T1ZAnaFF5rqbc3xO/G6XYNZHDQozi2ynwcOaAqxWCVTjRit
	8sEV3ILYlyi7LBDIaI8vPvfNun6cbIuMqUyrVbSxFZAYSLD2EjD7peMXGmnHygE9
	cf+3W34zBnyPK4kXQFBNpeEeA7FXECt9zQfyFnAr7ckpwfum0hzC6pL2BNLsv+nc
	eQZ4YQBmZQ2HFYr69gVqBMviO3E9PmQK+R/4HKiJVBK0FmSFKsTjxhwLeBZ9XjgA
	HD/nYA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmbd52gf9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 15:28:26 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ccb687f82eso12759725ad.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 08:28:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789140506; cv=none;
        d=google.com; s=arc-20260327;
        b=TTMLxM78dCABIzXfUMhMbprrcrhD49O3Whet0rZ6cxve3RbJVB7yiR58cIpACyKe0A
         WDBEP72tB5YtoJHurkt9dMrZ3w2FdTKLjhfuCUer31ddFRt4k30bS2vDO/3/+aibyNXF
         6KDkXkbeUHVbDOFz6xJmA4QsjFKTJAgzy/4JZrhHwG3f87bACBF8QthGC2u6UoPpD0Rs
         zlBpjpaHqvImRPX9NIMzRo+COgxiVTGrI8olY2kHENmJukExzUFXxdE+Np5OZFBdXEhd
         vbFfT9eQcY9xFClNSBicF5d1sPbtM7lr1utsgjCK68ug9TtKyj/kJIiFwQrd7xQCfr0q
         bC6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=svMDt6dlhUloJNhLHfCFC18SuqeTtDnWBl2KFSnEON8=;
        fh=I1Z7L9hddwLbVfFX+qg4oPaPT7zeFU+UL+ZCMxt8Tcc=;
        b=n0UIwbx4uWGDJqLBrYviH50IfLyBGXnBLfOmdguqsnGMyo2HVV/hDM6hSLTE7FZ180
         MZVf0H4YN3dw3CCSXHFpTZiLSRDWr6pAlS4099ngzauf+fqGcNyNJ8LRC/6mbxEmef62
         x/LAN+sxkZfIem0tq9B0T09QL0/wMqQrW0TW319+2LsqgKZIYuV/tJnoxEcVJcYLHT0U
         xrnIkoCW/MYUZI0tZuZUZeXXeiXoeRarfQOFlvodt7ok9EEbrZpHnW3ky3dvYrAVLfxg
         14GHUzOTmRtKWFRdV455hoh4ZqtuB778bkLEVtdu94EePKtkNk+LeBWP90DWeoOEueGh
         oamA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789140506; x=1789745306; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=svMDt6dlhUloJNhLHfCFC18SuqeTtDnWBl2KFSnEON8=;
        b=FsGULuh+qf433375ubFP2FW9HdcXPgXhPXFRgs40e4P4jkJl6V/wuxO6PVEkQ1Rz9y
         gLkQX/PUj99p6VXoAaEP2OEbAhCNDL8NXarruIra1fDFPgOJBrRTMlvHiwTSGsPHqyMl
         ENhEUNfvmRdOS5qsOeXRXwoDDtZSaxkLLOCJq7+abinBsak5ofF9MwMNsgW+loaTHuTo
         +erkvgSaMJqpImaE0FOHSciEiEoQTEp9pJ13XIbvUKN/d/92DhZU72YeHh/8BKLEXm7b
         4u8YBa4il5nESSI+0ByryuTY7lLKMLVuHtfTt2El6ogrtUHxygXzVkuTw6qPRrEP0mHt
         dyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789140506; x=1789745306;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=svMDt6dlhUloJNhLHfCFC18SuqeTtDnWBl2KFSnEON8=;
        b=mEVyQVgOEr7qbNrli8xWMuBsl9Egfud0oD8MPfiWHeRwjrEIKmuNWh4G8i2kx3eKZX
         ORfxNLzaQadGE7CnwDPs71yqELHpmHYBtLEKctdBC56Gd0uFOlyRpf1GFcMsPAHONN0i
         nKsFIHDUS9ncq0nHYAru61tnDMbbbbWP6K6I0X7sQOcJyauP9vt4SgpLnwnUKzSgLfKw
         YOSVaHjyOTySsXLXuIkCupGnqp/kYq92UWoOGzm86Ll3JPecGVeHbpewFscJHILKiFde
         xtR/S5qZvqjZSi8H1ricJXdZUNeGRWjrXrWgnsduh7i/kpxky03AfNFXvIoCQtmZ66ev
         Bq7Q==
X-Gm-Message-State: AFuF++lyRH4MVdjHP3gcCnQpwcad+7z3dXtXmj3OuK/VlNJw173KeCTe
	Cm3ypWO0csvYLDzxXcO7Xg3ublxnQr8dqCgwLeK68QHDz2JeqEsfrAiyrIMuOhWdx7elnmVnnkM
	ql3cbxap3Epk2YW3h8ky4uKnheUXH9CKSH91bcQKW2U8s7n+eRe7IFavn2E6LAZihb5koQNG1c3
	1hLIqyJiJgkywDPH8stX7WALr7AeJpxCWyoYnrGR7nnV/B
X-Gm-Gg: AYBFou2kKOK51pC3j+LGY5WNOoQuD5sD1RiMP7NbJoZRuaQNkVs01KYnhWJFC6lv9HQ
	VUUMNhCPG4DPfCXVYWBbDrY9dmhhNULMqpp0zzVjj8i3KeER/O286AIs7wyoflJaPCWxrVk3SMt
	GuVeYckWDAG4lr1AxD2/Swygn0FI1mncVCUN9id6nT0KdNwahEegioDfJvng==
X-Received: by 2002:a17:903:2f8b:b0:2d8:d4d0:7930 with SMTP id d9443c01a7336-2dd2a455062mr81599615ad.20.1789140506062;
        Fri, 11 Sep 2026 08:28:26 -0700 (PDT)
X-Received: by 2002:a17:903:2f8b:b0:2d8:d4d0:7930 with SMTP id
 d9443c01a7336-2dd2a455062mr81599245ad.20.1789140505659; Fri, 11 Sep 2026
 08:28:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908093758.596444-1-chunfan.chen@gmail.com> <20260908093758.596444-2-chunfan.chen@gmail.com>
In-Reply-To: <20260908093758.596444-2-chunfan.chen@gmail.com>
From: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
Date: Fri, 11 Sep 2026 17:28:14 +0200
X-Gm-Features: AcwNN1Vt7W-bt4IR2okAT9VgkUOIhH5DNfot7X0_JsNH2glYNJpfmkK5igPON3U
Message-ID: <CAPx+jO8xjqpmChF_F_ZAU0AmbTY8ww-K3vq62VDpR3n+YJe=jg@mail.gmail.com>
Subject: Re: [PATCH wireless-next 1/4] mmc: sdio: add NXP IW610 device ID
To: Jeff Chen <chunfan.chen@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        francesco@dolcini.it, linux-mmc@vger.kernel.org,
        Ulf Hansson <ulfh@kernel.org>, Jeff Chen <jeff.chen_1@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: ZZvbpn8ErADfWfB_q3C81jrE_offO4aA
X-Proofpoint-ORIG-GUID: ZZvbpn8ErADfWfB_q3C81jrE_offO4aA
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDIxNiBTYWx0ZWRfXzvvsoGkX6qBS
 Vy6EWfrLaKeBs9EhhjV/4s0trPbXIUDDM0JA5TD3S9Zx4xoBu0iKmxLngdwxZPddrVqCWVf1QX8
 KHkmbULOkK/kafxTeCjyEz42k0VAq/Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDIxNiBTYWx0ZWRfX7rUWsDbEF67Y
 MpHMQPL0UrVoT3QhOrhz7xya/oEe4tGnsKI+tLH035ncDvdRBVg4XnbwEZaJfMXeuP2Mq4P2a8c
 jWaFw+pl8GWxhD9rFihahLbh6QHR1+gVeKa3UOW3Ca9bdZm3gbS7OL+DWKTipnWcDkBT+1nn3we
 gJ99NY48iyMKNH2sgfn7584sWZTVuJMw64L12RUX1CQo+mVsaI5CgUgDTWC+HgD2mPRRewLESuD
 3lF+p5Mk0qHfYNh3K8jRH4/d8+X4RQkHxmIU2hpKe/Z3BfcIVO+BIF0/Pw3PJYr+vLB49BUoJaP
 XJTMSjjmwyVBkIeoWZp0z+78JMLQ+6l/6I5twHEq7PrJyNWM3klmCqx6PuKqXcLynMuZBdto1US
 j53R7+lLe9EBYHyFybsd/E3lHFysM8pVcG0w79u/N2OHy2zgQfyaYE5l/SSytNTV/+i3QWJCo7M
 LWxcMD51jj2Teoukz8w==
X-Authority-Analysis: v=2.4 cv=db0VTnXe c=1 sm=1 tr=0 ts=6aa41e1a cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=pGLkceISAAAA:8 a=8AirrxEcAAAA:8 a=VwQbUJbxAAAA:8
 a=GLjWqU4heM0_rUE6tFkA:9 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
 a=ST-jHhOKWsTCqRlWije3:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_05,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 impostorscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110216

On Tue, Sep 8, 2026 at 11:38=E2=80=AFAM Jeff Chen <chunfan.chen@gmail.com> =
wrote:
>
> From: Jeff Chen <jeff.chen_1@nxp.com>
>
> Add SDIO device ID (0x0215) for NXP IW610 to sdio_ids.h. It is used
> by the nxpwifi driver to probe the IW610 chip over SDIO.
>
> Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>

Acked-by: Ulf Hansson <ulfh@kernel.org>

Kind regards
Uffe

> ---
>  include/linux/mmc/sdio_ids.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index afae93f6f245..5eff5e348eb0 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -123,6 +123,7 @@
>  #define SDIO_VENDOR_ID_NXP                     0x0471
>  #define SDIO_DEVICE_ID_NXP_IW61X_BASE          0x0204
>  #define SDIO_DEVICE_ID_NXP_IW61X               0x0205
> +#define SDIO_DEVICE_ID_NXP_IW610               0x0215
>
>  #define SDIO_VENDOR_ID_REALTEK                 0x024c
>  #define SDIO_DEVICE_ID_REALTEK_RTW8723BS       0xb723
> --
> 2.34.1
>
