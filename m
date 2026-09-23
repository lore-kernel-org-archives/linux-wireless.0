Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3498C3C819B;
	Wed, 23 Sep 2026 21:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790197717; cv=none; b=euNzqlAjg8khj+R2u3OZ1cO5TSzzA4PQ1zJaIcPZfc+R0qNevYTPRr0prIfzpIKIl9oiwdKwBBwiBafW7HfOf3u5hspD5KZH1rPLMzAGPksYYIfD61kGcmjfXiqw8Obk2M1VbmyQHKHe0dTCpK5tZXE5a62Bd+8DM8MvcyJRilo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790197717; c=relaxed/simple;
	bh=u9vyTnfDdTrmd9y7fzOYI9Chf27iTNx4Gu6KyxRoDT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RuXtoYZGpv/zZwNyyxNU0qkQCOvqjUWycU7RWBLbZp0hf7pq2/zW8B+53c+KU9xBZ3WuilBZ3G0Kg3ignOU6krv2kNiK5zZbTWZJaLExIr5dOO5wk5KzuAhPZOMYzGOlfuEVhCj2Ug7QVR89RTfJIl9MXbmgtXpuYNU72dkcZis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IFfLk5F+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IFfLk5F+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16721F00893;
	Wed, 23 Sep 2026 21:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790197711;
	bh=oYRyYQ7jGFmso8AY6dUwDwpqY0QEPIOZBmqP3y/+Wjw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IFfLk5F+vPh8IZNhqF0jC6aiB53HDZvSF2VK2z8f7otoMhT2JY81X0DRgu4kSZy1c
	 joRyiJr0iXdIujrsXvmcilGrrlkhEL9YLIUEvmzKixvjEeFJ8vxgxkwXlAMImcgbz5
	 ObT2M39E9XWkmhhoICbrZZTEJIdLs70sQZ7CLs85nDdlrYvQI58UEG0MV2Zli3ORfN
	 qEGaY7uobvyPgkqQYN9MxRINi7FLvSkgqHtmHbwFsTDaPMYxN2sV8xdrPRQjkvGaFE
	 AUROK5OvdNxX5Jpjfb4/VhakF9Jk6w7yYiqjrfNKsr4mXgTRJosRSZ3QC2bAL67QYd
	 6F00ow4Wk2EBQ==
Message-ID: <49153dff-b4e0-43ac-aa82-15175fea6445@kernel.org>
Date: Wed, 23 Sep 2026 22:08:19 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] firmware: qcom: scm: pass qcom_scm through the
 exported API
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
 <bRb6NzJiFvNGB0X3BeiVytgZNlRv88LFlcaBwwFIFa3GtVZhn5bh9EoRRDliRtgsnlQNMddvcIPK-5HK9x7z9Q==@protonmail.internalid>
 <20260914-scm-device-api-v1-2-3573e2596c51@redhat.com>
From: Bryan O'Donoghue <bod@kernel.org>
Content-Language: en-US
In-Reply-To: <20260914-scm-device-api-v1-2-3573e2596c51@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/09/2026 13:41, Albert Esteve wrote:
>   static int spm_cpuidle_drv_probe(struct platform_device *pdev)
>   {
> +	struct qcom_scm *scm = qcom_scm_get();
>   	int cpu, ret;
> 
> -	if (!qcom_scm_is_available())
> +	if (!scm)
>   		return -EPROBE_DEFER;

Is this equivalent code ?

Its also a bit confusing to me that the next patch adds a .available 
field to the qcom_scm struct.

I see where you do get drvdata but I haven't managed to find in the 
series where the data gets set - haven't asked an LLM either - I think 
the logic to associate the scm pointer and get it should live together 
in one patch so that the logic is easier to find and reason about.

---
bod
