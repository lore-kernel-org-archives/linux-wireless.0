Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793105350;
	b=EKTwSl9sElnBoEMZn5BYyY4omf2v2GH72C0IkgT9CVNAzlDOfWKjZHtdZcZUfx1tOk4C
	 YdnPOrduEUOoWxj3w+xw/hZnU3B0ZKs7XahvI6jvyaLCPL4EcPyyzmt6GVI4h8WalRW15
	 vcsGoqdlee5tG3qnfcGx0i+lGVk6dGNrzLNu9y2HNcjdWOl/GC2io129g7HURvuwsqKdI
	 KH0HIBmjJRZmw0j62N+UqYbi3pUG2uD1bh2P8e3D73ar26hT3/Al63kUQKFxAKwMZJ+FP
	 VOMdS1tIQa1yooxR1tqQ9DHFLRaQJaT63I74OR+CxtCzFQTfEq1SAEywUEfHkW51/fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793105350;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Fk4tWvtlQqWKIFqJ5KSuzG0MEcWeW6IEPLtAR2pn3Ag=;
	b=CXu28XXq6gq5wibjE2KlnSw+Od6io57Yr2MG2tb00p5A7M9FeXdY5k5/cxoCoN/wQ+93
	 hW91NZHYynMKAf2dornRDQP8cuvseOCUilvX+9HGE5+nx1cjekGcUdcMrSV0+jH/WDM62
	 GOLA/p2Ne7hhGUZtqpetJfL0vUsMXdxpj7hIu9hrl9HWSKLfQgUk/cwd0tV/HFaBfy6l4
	 vwXGh7AFmTe+yTIycl22k8LOLY/tvgn6eWGKhq43mC+d6hjpVSiLoJWz8GQnzLADdqMVM
	 vTGdnn/lgVf4OCiZWhb8BuafXy3/m8r6Dlt7o5/rSoKWFGsMyX8RisiwFs71CleaOwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ieee.org;
	spf=pass smtp.mailfrom=ieee.org;
	dkim=pass header.d=ieee.org header.i=@ieee.org header.a=rsa-sha256 header.s=google header.b=WiLlRCPE;
	arc=none smtp.remote-ip=209.85.222.178
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07442606A339
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 12:49:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07442606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ieee.org header.i=@ieee.org header.a=rsa-sha256 header.s=google header.b=WiLlRCPE
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93efc0452b5so267987885a.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 05:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1793105348; x=1793710148; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fk4tWvtlQqWKIFqJ5KSuzG0MEcWeW6IEPLtAR2pn3Ag=;
        b=WiLlRCPEdcKxVRkxZZqDI0Of8j/YUHQ6LS4ozirUJJdpxPXPdnzPLdYFRcQOvo4/Qh
         kaM1KrVlcAdeEQlKG7Dp5+1ZbNXqS8mP0v8jn7zOVZpb+/XX4ik2Un0lMLbRgcwUhbOk
         ZgM7HTwfGtUGBuxb1l3NzKDURXoUGn6pOrbic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793105348; x=1793710148;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fk4tWvtlQqWKIFqJ5KSuzG0MEcWeW6IEPLtAR2pn3Ag=;
        b=O2L48SRPAxcmfWJO/yQGkBhAK9IOe8k1bqR74kje86rGtdgRQH4dnVmEygCA3rRVVP
         5YS41acPhURdynfXNhUxBm5uWyeXq/HgumEt59IMMtfT2XeDwKq5diDzXpm3yxSBr5QH
         scr5UHkbnSAPNv1I/yOPWx3/rPZr1vdg3F8169ApnyE17Sz2FCzTBSvrWLCHri5bNw1Q
         EATIO4cyYjob+YpNcx2oXP8kP7ZznSSoSLGOPeQpcqg2JZCYrLHHLXBD86IolkwlUrYR
         iIJ5ms8uUHfKZha3w2a+NczyPBx5G6IJHFsCpSzZTSypY+9nbzNH/SR42c4VAPFO/4lY
         zHJA==
X-Forwarded-Encrypted: i=1; AKwUvByayYiaL51JUX9/EwUkQ9Qa5ZdCo/CmtNocLH/Vr20pii3wbUE/PCm8bee7HuTd+0iTM/1lsJSN2OvguQp1bg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJM5M9hetIWzDyktMYV2huoeSuAiTVmaUh6RMYFsMaWahCr5NtU
	lT8n0Gd26iZNOG3AlUGXYx8VnJCZvB7zgO0rQLpF1KTaxhaSz22I9dksOM72Ok26uA==
X-Gm-Gg: AYBFou3f+Grd5FS5h2K5cm08AO8C+0T5Ay9vG/TZOaVFqnOwbTyhoFQaotMk7yS6DG7
	ByKJL0nLEcmI44/Ib9/2U9aFqOYXRLzV6U8pmu9OFZLcNon+30daA2t8Hjdn0RjW9+ofZ+HR5xp
	HcjOVhFYD3eTP7eJtWbhO7JDpaXylkDKZie5UwI8ONc8V/kRR+BCtPMsqwWMB5xNaQLlP+stLQK
	y50/6JSD0C0RtFL/Fo6hbxgfu14K5LIVaNVX8t4JMNj8YOFg8jMWXRPoW/tkGFGThUZgtVSMboJ
	0maSXd/iSAxI1hBhBnzTVwGVTQbUbuD+F8HuFEpS7kE0zSd43aB3T+HfjQufT+GFvOPB7AEMWkf
	bum1+Y7iBo6FgLyyyaqCEdaVGYnPd/yLLeUr5QgBgXfw8QnBOpdIuJrqbkZH9K4xfh3e2lxehTx
	/k2YlzNjTw0g7ZXYcWa6BqjMBGYyvwX5eR+yTficMwatmXKERETM8sK84KVJY3eP51PCBzLl8tD
	PGXGC6ZYAAJ1EK0XGP4MZoP0jHspSLoRe0fnyR27k/4nHd0+Sg=
X-Received: by 2002:a05:620a:801c:b0:93e:7944:b874 with SMTP id af79cd13be357-940ef93a596mr1396495185a.33.1793105347945;
        Tue, 27 Oct 2026 05:49:07 -0700 (PDT)
Received: from [172.22.22.28] ([73.62.185.64])
        by smtp.googlemail.com with ESMTPSA id af79cd13be357-940f0a8549fsm956941085a.39.2026.10.27.05.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2026 05:49:06 -0700 (PDT)
Message-ID: <ccf0300c-80e8-41a5-a394-6ec55fddc913@ieee.org>
Date: Tue, 27 Oct 2026 07:49:03 -0500
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] net: ipa: migrate firmware loading to
 qcom_mdt_pas_load() and qcom_pas_prepare_and_auth_reset()
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
 Sumit Garg <sumit.garg@oss.qualcomm.com>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
 Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
 Bryan O'Donoghue <bod@kernel.org>, Mauro Carvalho Chehab
 <mchehab@kernel.org>, Alex Elder <elder@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jeff Johnson <jjohnson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Abel Vesa <abelvesa@kernel.org>, Sean Paul <sean@poorly.run>,
 Akhil P Oommen <akhilpo@oss.qualcomm.com>,
 Abhinav Kumar <abhinav.kumar@linux.dev>,
 Jessica Zhang <jesszhan0024@gmail.com>,
 Marijn Suijten <marijn.suijten@somainline.org>,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-media@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
 linux-remoteproc@vger.kernel.org
References: <20260925155737.4161358-1-mukesh.ojha@oss.qualcomm.com>
 <20260925155737.4161358-6-mukesh.ojha@oss.qualcomm.com>
Content-Language: en-US
From: Alex Elder <elder@ieee.org>
In-Reply-To: <20260925155737.4161358-6-mukesh.ojha@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/26 10:57 AM, Mukesh Ojha wrote:
> ipa_firmware_load() calls qcom_mdt_load() which bundles metadata init,
> memory setup, and segment loading with no PAS context, then calls
> qcom_pas_auth_and_reset() which skips the shmbridge prepare step required
> before TrustZone authentication.
> 
> Replace the open-coded memremap()/qcom_mdt_load()/memunmap() sequence
> with devm_qcom_pas_context_alloc() and qcom_mdt_pas_load(), then pass
> the same context to qcom_pas_prepare_and_auth_reset().
> 
> Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

I think this does the right thing, however the IPA driver does
not use resource-managed (devm) interfaces, and this would be
a first.

Why does "qcom_pas.c" not offer an interface that can be used
without devm_kzalloc()?  What if someone wanted to pass in a
preallocated structure to be initialized with the (publicly
defined) PAS context?

I was going to suggest that you just rework the code to use
gotos and the cleanup path as used everywhere else in this
driver, but it looks like that's not easy.

I'm willing to ack this but I would have preferred to preserve
consistency.

Reluctantly:

Acked-by: Alex Elder <elder@riscstar.com>


> ---
>   drivers/net/ipa/ipa_main.c | 24 +++++++++++-------------
>   1 file changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> index 14ac2d2faf7c..6964395caedd 100644
> --- a/drivers/net/ipa/ipa_main.c
> +++ b/drivers/net/ipa/ipa_main.c
> @@ -585,12 +585,11 @@ static void ipa_deconfig(struct ipa *ipa)
>   
>   static int ipa_firmware_load(struct device *dev)
>   {
> +	struct qcom_pas_context *ctx;
>   	const struct firmware *fw;
>   	struct resource res;
>   	phys_addr_t phys;
>   	const char *path;
> -	ssize_t size;
> -	void *virt;
>   	int ret;
>   
>   	ret = of_reserved_mem_region_to_resource(dev->of_node, 0, &res);
> @@ -615,24 +614,23 @@ static int ipa_firmware_load(struct device *dev)
>   	}
>   
>   	phys = res.start;
> -	size = (size_t)resource_size(&res);
> -	virt = memremap(phys, size, MEMREMAP_WC);
> -	if (!virt) {
> -		dev_err(dev, "unable to remap firmware memory\n");
> -		ret = -ENOMEM;
> +	ctx = devm_qcom_pas_context_alloc(dev, IPA_PAS_ID, phys,
> +					  resource_size(&res));
> +	if (IS_ERR(ctx)) {
> +		ret = PTR_ERR(ctx);
>   		goto out_release_firmware;
>   	}
>   
> -	ret = qcom_mdt_load(dev, fw, path, IPA_PAS_ID, virt, phys, size, NULL);
> +	ret = qcom_mdt_pas_load(ctx, fw, path, NULL);
>   	if (ret) {
>   		dev_err(dev, "error %d loading \"%s\"\n", ret, path);
> -	} else {
> -		ret = qcom_pas_auth_and_reset(IPA_PAS_ID);
> -		if (ret)
> -			dev_err(dev, "error %d authenticating \"%s\"\n", ret, path);
> +		goto out_release_firmware;
>   	}
>   
> -	memunmap(virt);
> +	ret = qcom_pas_prepare_and_auth_reset(ctx);
> +	if (ret)
> +		dev_err(dev, "error %d authenticating \"%s\"\n", ret, path);
> +
>   out_release_firmware:
>   	release_firmware(fw);
>   

