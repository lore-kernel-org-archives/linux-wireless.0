Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C3B3CB57D;
	Tue,  4 Aug 2026 22:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785882691; cv=none; b=BZiJOrFvG6HsAZ89OVdRw9yBDJpyeGpgFoSKp+KV8cpD1sJNQegoRWxQ7QRng8bzaz16wlKDNh5p8V45wecAAG/3knADj07N6/ITY+cd/d8USevJ7wW3mtCiGpjxgPM3RoxDvqKl3//jX0ioqVHj4aQy4jzcvUaOMEhym+OdcZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785882691; c=relaxed/simple;
	bh=mG1SLwAJIubIVjXdTFNOBu8EzWB7e3//i6VKXIlyBlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GIL1tRAGhXa2ctKkf5q1cZGh/dhagDAxBuUz/sibERw+Q8EyZq4g69hlfdhP4QhkNKKW+KpY47Kn+D1OgRsRabMMPLwLXIj69zf7G0mP18vHixzPs7KmvYQBKYPHRU1CWTJJHxHvixNl7kP+ruUPSBHWo++ZHcvMEb/x/PrR+bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VSdW48Lc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSdW48Lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C731F00A3D;
	Tue,  4 Aug 2026 22:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785882685;
	bh=1rNKgpIx6sZKzmYQ6FweqLBwIUVjPux1He9OuvdAw/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSdW48Lc4jRQjSvOYK6+1RkSCe23ufhDsOsXhNt4Ddw8D/YQHxmW320dvP2P7ORz+
	 Nzz4hCaj/lJheSxjNhu3iK8vKtbjkdRaSYOp9A3xKfMCmjo1wFCtcIoxttJJ7CHyTW
	 6FMLdwzCEAHkqLj2FEznUUNVP76O0jKtDVItxv3ED11ABBaD/MjbZTwf7dKQLMYfYP
	 dEaRKsKWQs/SpA7P9pNqP15pttyCi9lzKbUd8DJdKNkfS4l3ybZmwCkpxRabdDxoZc
	 l51MfSH06sfXgb8HFBXSqbR2LPPJEGwI4O/DC9mCeNnBGbOkIY2Ycs3abL1ZRO0ZNw
	 8giP29bCtxPug==
From: Bjorn Andersson <andersson@kernel.org>
To: konradybcio@kernel.org,
	Sumit Garg <sumit.garg@kernel.org>
Cc: linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-remoteproc@vger.kernel.org,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	robin.clark@oss.qualcomm.com,
	sean@poorly.run,
	akhilpo@oss.qualcomm.com,
	lumag@kernel.org,
	abhinav.kumar@linux.dev,
	jesszhan0024@gmail.com,
	marijn.suijten@somainline.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	vikash.garodia@oss.qualcomm.com,
	bod@kernel.org,
	mchehab@kernel.org,
	elder@kernel.org,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	jjohnson@kernel.org,
	mathieu.poirier@linaro.org,
	trilokkumar.soni@oss.qualcomm.com,
	mukesh.ojha@oss.qualcomm.com,
	pavan.kondeti@oss.qualcomm.com,
	jorge.ramirez@oss.qualcomm.com,
	tonyh@qti.qualcomm.com,
	vignesh.viswanathan@oss.qualcomm.com,
	srinivas.kandagatla@oss.qualcomm.com,
	amirreza.zarrabi@oss.qualcomm.com,
	jenswi@kernel.org,
	op-tee@lists.trustedfirmware.org,
	apurupa@qti.qualcomm.com,
	skare@qti.qualcomm.com,
	linux-kernel@vger.kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: Re: (subset) [PATCH v9 00/14] firmware: qcom: Add OP-TEE PAS service support
Date: Tue,  4 Aug 2026 17:31:15 -0500
Message-ID: <178588267268.451855.11887423649046062153.b4-ty@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260702115835.167602-1-sumit.garg@kernel.org>
References: <20260702115835.167602-1-sumit.garg@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 02 Jul 2026 17:28:16 +0530, Sumit Garg wrote:
> From: Sumit Garg <sumit.garg@oss.qualcomm.com>
> 
> Qcom platforms has the legacy of using non-standard SCM calls
> splintered over the various kernel drivers. These SCM calls aren't
> compliant with the standard SMC calling conventions which is a
> prerequisite to enable migration to the FF-A specifications from Arm.
> 
> [...]

Applied, thanks!

[09/14] media: qcom: Switch to generic PAS TZ APIs
        commit: 94d3305d990b055e1561e3b78275344b1f40c86e

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
