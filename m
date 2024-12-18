Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86CA1F9A98;
	Wed, 18 Dec 2024 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734544716; cv=none; b=s+oHs4R9h1T66qTyA/0VPrekqxeKGZd6rnL6MgDw5UqpUY+FNrDhXcuaoNIAYevIwlhreWJUXeHPt0UZRWHR4RTpp9oo231NAMEu79LtGReFsKobYxkWmwh/Fv0mZaa/PMokFsPn0k46t/8X8TlKdpJYXlTijiJX5u8K4OJFJ0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734544716; c=relaxed/simple;
	bh=jYkMMnH3Beid8aqVtuaIJ4XDnNZkms6tLHNG4Tu43q8=;
	h=Content-Type:MIME-Version:Subject:From:In-Reply-To:References:To:
	 Cc:Message-ID:Date; b=jc7UK/oHNKuITukYbQS3W8ZfAhJD2Nhf/KdsnuEKU4PwSEuTCAK6849H8Bssf9z2yAmedG8PwO2ToOZi7xQNCO7JCpKlfYO2x2agTYqe+Tuatk81VqIsPcQKKUrfvPy5wegMSsoz0CRbIHaarU5NXJ5QIgus1zH19wobwqAoDjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHCEo/AT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHCEo/AT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE61C4CECD;
	Wed, 18 Dec 2024 17:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734544716;
	bh=jYkMMnH3Beid8aqVtuaIJ4XDnNZkms6tLHNG4Tu43q8=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=kHCEo/AT9pbsypapvAV35PJWgqsdmziC/epgFJD9S3fE8uKvfZ+mzds3IUSVtN5fP
	 3Kp+g5Z7/G9C5mYjwRNL++lnxyJw2HDOtOeMsA0syak09PLxWiai+TK9pGHufFyt8e
	 Zdt88z78D7LTIG9A81jjKOQswXGq57rmwv1p9UKFuWKsktFW0Blhzd44IRKk1FNs8b
	 DeaZSFBuUU/0j+btoa2Si5B45hloGIyPPZ7dqXrO6s6IJvIrhXFHXi38SkSwBwlypW
	 wufedSE6Q8fklwbtOkC53C1x9Ob0BGJKIUzTtHtAZXFuvA98G3BHhIvTG8ZAXHPE/4
	 1nPYRf5EZ3dwg==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: cw1200: Fix potential NULL dereference
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20241217-cw1200-fix-v1-1-911e6b5823ec@linaro.org>
References: <20241217-cw1200-fix-v1-1-911e6b5823ec@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <lkp@intel.com>, Dan Carpenter <dan.carpenter@linaro.org>,
 Linus Walleij <linus.walleij@linaro.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <173454471281.1383964.2745543132291876467.kvalo@kernel.org>
Date: Wed, 18 Dec 2024 17:58:34 +0000 (UTC)

Linus Walleij <linus.walleij@linaro.org> wrote:

> A recent refactoring was identified by smatch to cause another potential NULL
> dereference:
> 
> drivers/net/wireless/st/cw1200/cw1200_spi.c:440 cw1200_spi_disconnect() error: we previously assumed 'self' could be null (see line 433)
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202411271742.Xa7CNVh1-lkp@intel.com/
> Fixes: 2719a9e7156c ("wifi: cw1200: Convert to GPIO descriptors")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Patch applied to wireless.git, thanks.

146b6057e1fd wifi: cw1200: Fix potential NULL dereference

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20241217-cw1200-fix-v1-1-911e6b5823ec@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

