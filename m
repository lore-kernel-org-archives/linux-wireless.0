Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBD234BA5B;
	Wed, 23 Sep 2026 21:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790197218; cv=none; b=fjChbBzCZ/XmWUOFh3sBIYRkMB+Nxhi3gJibCy405T4T9v7CWo6ZmYpaj4s6Bd5RGH8jcJ79Jhtj8K1PiWV5wjTkvNfjjxtbVEbcJ1LrprCBqdHOuHlKP/zRCcqqxFdutlkJYRUOBTVKp6PXktDZPlpZ6loDcRdqFNM3SafQqdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790197218; c=relaxed/simple;
	bh=ccQz9YvjRV9nNKuWS/TlWg8SWDYqOPJmHdP9RIhMSUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k+74p+jxc23Ei45KM9hDwStLJumySJJikhfpl2M2/NdFHZt86q0mnUfNnl6l0I8KcccRUo/4YZKiRn0NPCY4KhNt0UV+xbee2PPROeHBjnUOzFFqwGMPPObztoMF3ktfACpKyTBf6JTdD4TyLWiwFehRgbWh2W/ewTQnZZQfLrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j12baXkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j12baXkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A831F000FF;
	Wed, 23 Sep 2026 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790197216;
	bh=gopMSo0mzfjrUmtaCVKnC5i427RNBJMYYN+bfD5UTH4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j12baXkZU6VWzbYrJ0+NzEVS/CfB8Rh8M798lc+51zoz+KwjyW3gRw6z7EbYzEKEt
	 ZvK0X4S2aRfw3cy98PCg798VnCw2rE7bfIYDt0xAL3U971Y+q8VpPNSApFBWoOB/KT
	 GYT2UyxeQI99pJh0d6zdMidf9LV8/FqeIZJtB0pCSDN+mByRuB8vFuwtybfAlOxXz5
	 Emh6muuBBbpxRkqAdRwCwdcgzHCg2AkyVLFkGW5mRTdrDHfNbeedm2Zedp/LbGYsw9
	 HH+YBEKk6Hr2IUcRUjHJrynTu5TcVnQd3Gg0SAZBacZirPA9pv1eDsGDNBQUY5X6UD
	 eqECMtzKo5Dig==
Message-ID: <b1340496-1ff3-4ad7-87c3-36d2162efbfa@kernel.org>
Date: Wed, 23 Sep 2026 22:00:01 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] firmware: qcom: scm: pass qcom_scm to internal
 helpers
To: Albert Esteve <aesteve@redhat.com>, Bjorn Andersson
 <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>,
 Philipp Zabel <p.zabel@pengutronix.de>, Russell King
 <linux@armlinux.org.uk>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Daniel Lezcano <daniel.lezcano@kernel.org>,
 Christian Loehle <christian.loehle@arm.com>,
 Maximilian Luz <luzmaximilian@gmail.com>,
 Bartosz Golaszewski <brgl@kernel.org>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Sean Paul <sean@poorly.run>,
 Akhil P Oommen <akhilpo@oss.qualcomm.com>,
 Dmitry Baryshkov <lumag@kernel.org>, Abhinav Kumar
 <abhinav.kumar@linux.dev>, Jessica Zhang <jesszhan0024@gmail.com>,
 Marijn Suijten <marijn.suijten@somainline.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Thomas Gleixner <tglx@kernel.org>,
 Radu Rendec <radu@rendec.net>,
 Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
 Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>,
 Srinivas Kandagatla <srini@kernel.org>,
 Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jeff Johnson <jjohnson@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Amirreza Zarrabi <amirreza.zarrabi@oss.qualcomm.com>,
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>,
 Amit Kucheria <amitk@kernel.org>, Thara Gopinath <thara.gopinath@gmail.com>,
 Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
 Brian Norris <briannorris@chromium.org>,
 Govind Singh <govinds@codeaurora.org>,
 Niklas Cassel <niklas.cassel@linaro.org>, Kalle Valo <kvalo@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 iommu@lists.linux.dev, linux-media@vger.kernel.org,
 linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
 linux-gpio@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 op-tee@lists.trustedfirmware.org, Maxime Ripard <mripard@kernel.org>
References: <20260914-scm-device-api-v1-0-3573e2596c51@redhat.com>
 <EKwbCgCnxbNX4p95qJ3xoytzeNBBLc2L_HOVWr-S-y8n7pNOIToj37TyoXRcLyIK1gjq_IvbreQ331gw6jIK9Q==@protonmail.internalid>
 <20260914-scm-device-api-v1-1-3573e2596c51@redhat.com>
From: Bryan O'Donoghue <bod@kernel.org>
Content-Language: en-US
In-Reply-To: <20260914-scm-device-api-v1-1-3573e2596c51@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/09/2026 13:41, Albert Esteve wrote:
>   int qcom_scm_pas_auth_and_reset(u32 pas_id)
>   {
> -	return __qcom_scm_pas_auth_and_reset(__scm->dev, pas_id);
> +	struct qcom_scm *scm = __scm;
> +
> +	return __qcom_scm_pas_auth_and_reset(scm->dev, pas_id);
>   }
>   EXPORT_SYMBOL_GPL(qcom_scm_pas_auth_and_reset);

Why make this change at all though ?

It takes a pointer to the file static _scm

The reset of the patch looks straight-forward to me but this change 
caught my eye.

---
bod
