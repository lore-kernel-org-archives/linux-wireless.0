Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8214D522EFB
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 13:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792070570; cv=none; b=eFJSBRvl92yahRU6cFN1fEfnork+AC5r6L6r7nESQcaEeXK3v66CVxZdgJ7ORaGrSn52ItieV6dxwtil2Zpzv5sOBLVZLasBwKxRJoRXhiJ+/c6yj/TZaeyIaMYf57Ch5E8lO6waE/JVfOCQPeLmHwE3swgrUOYMV07mib9xbu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792070570; c=relaxed/simple;
	bh=vlGf1T13Z+dYbNgaE76AaMl6XNAcJozRNF/jbJktorc=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JzN7RkNl9kgFZlVLK/6gqGua9wU15k0r0yVZdSnkCRs9rXRbAMhm7N9YvGBL1QLsdYCZhn50+LvE1UvkXf+g8mgRx6bQicLHxpkfGTLU51mamIuU/jfz7I0udfxdKQcc2wKSKxzDP2i3cJTev/Cadr9/AzVkDBs9hLvY1iBVFlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBRqmuWK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBRqmuWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A11C1F000CA
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 13:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792070569;
	bh=vlGf1T13Z+dYbNgaE76AaMl6XNAcJozRNF/jbJktorc=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=dBRqmuWK2zLSWCkxNYW4OJpTwQKNTpkvCo/jQ6lhgNv16UISJugG6g32QJlrd5pDg
	 Kwh5BEcx/Yrkl/ijOrJZWHJp1BvPWy03JD1CB3fRjV3oITasnByLO4Dkv/p9BqWJ7W
	 YBg87zl7utcTaj47KB0Zvr1dD6GZJBc2mbUp0kBvwwgsRByrJchFu09zzjsLogM46G
	 1A+ZiCP64ZT6DdgUU4KZe6wqWqafdrjpYtJPYzgeFB3RZ9dHRKYnyKT+O8eMe4kHrm
	 PyiL0LQErfqQmH0g+6iIop1zb0MtNLx/2wp+POz8N6/nIqgVSQ4N62zYl9cooV3l54
	 2Glt1U9KKXKSg==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3a9e87ba7f2so29436081fa.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 06:22:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzhKH1W4BGCMCEE9RLoKzU7nfw547nzDKerp+OjC7IqP8UVHifqNNYoWABqwmvZPI9d3ykXkv2Ve5J0Y0ooVA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIpDhqT2/ImKH4iZn33aSviZb+/7xdrNsxKQYgkKJ6HfTxNy46B
	N+IBeWSd7FxB13KEFf2WP0n0xcFn+McoASVvVaY5Q59ccs4MQidD7rKjXUJxat3xYmPMfNBOkMx
	KKSEDFbdm5rtuRl1A6kgcUA8vJ4W/zOAf7REHPF1LSQ==
X-Received: by 2002:a2e:bc23:0:b0:3a5:af50:bc99 with SMTP id
 38308e7fff4ca-3a9c5354501mr44082971fa.13.1792070567993; Thu, 15 Oct 2026
 06:22:47 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Oct 2026 06:22:46 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Oct 2026 06:22:46 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20261014-b4-nvmem-efivar-v1-5-187c85f65018@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com> <20261014-b4-nvmem-efivar-v1-5-187c85f65018@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 06:22:46 -0700
X-Gmail-Original-Message-ID: <CAMRc=MeDZZjDzCOwqyK5cKOuTz3zOScNS20NS+D8j2bEk=B6MQ@mail.gmail.com>
X-Gm-Features: AclHuK8xL2vil4lfhLkzbT6CatB4Oy4PBPKqe80Zw3U5zHMs29jaaQ8CTSEyqXY
Message-ID: <CAMRc=MeDZZjDzCOwqyK5cKOuTz3zOScNS20NS+D8j2bEk=B6MQ@mail.gmail.com>
Subject: Re: [PATCH RFC 5/5] arm64: dts: qcom: glymur-crd: Source MAC
 addresses from a UEFI variable
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org, 
	ath12k@lists.infradead.org, Srinivas Kandagatla <srini@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bartosz Golaszewski <brgl@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Jeff Johnson <jjohnson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 14 Oct 2026 15:02:43 +0200, Abel Vesa <abel.vesa@oss.qualcomm.com> said:
> Add an nvmem-efivar provider exposing the "MacAddresses" UEFI variable,
> carrying the Bluetooth BD_ADDR (bytes 0-5) and the WLAN MAC address
> (bytes 6-11), both MSB first. The variable is looked up by name, so no
> vendor GUID needs to be hardcoded.
>
> Wire the bd-address cell to the Bluetooth controller and the mac-address
> cell to the WLAN endpoint (pci17cb,1107) via the standard nvmem-cells
> binding. Until the variable is provisioned the cells read as zeroes and
> the controllers keep using their default addresses.
>
> Assisted-by: LLM
> Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> ---

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
