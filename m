Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E673033A005;
	Mon, 13 Jul 2026 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783955226; cv=none; b=GkM8j9iH/Ie1k1RKFCgbXe1XCYMdm76H3jb1aZbrmIbDPaNdW4Tw977BODR8VCuNiqJX34RuDji/ajHX1OFqvIf+Gl1jkVAdSR5PxLBPS56ZgR2p94xMEkBIP+byDjppMIXKQKXrVRx+ykZ544h8wSYKdO1EdaDN4okfER7J7h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783955226; c=relaxed/simple;
	bh=XmmT0VnuDbpJsBmhNrdz4eHBxtrQGyTQEUcd3Qlc9KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=awj7oIOUGkeVxE9Y9UL4xQHy5PP9NYzVX0tuCvG+Va/vX9nimYYWxIczNaB8HFSfKP1g03lfP0VD7GLkEjZD29y8xBHB/fcqTm80dGxbilJ2ZYhwxSXLSXSeuSu+aDhVZIRAjiW8S98JoXKcgiDtmWe0N+34li/Tl5HeVzVIZBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CcI3puIN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CcI3puIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF7C1F00ADE;
	Mon, 13 Jul 2026 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783955224;
	bh=CXZ1rcqmiiZoIildEIFOR3w8PfogXYlRD2D++r0wb0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcI3puINEWHumtKm/k5ofO6hjUX8VkNaypq4XypKEWenfIerBEGMQ8ypzso8ImTU1
	 E95VXYvBiAyLhz7ACy9Xt1kBxdZ5iPBFWFLN1WAcAE07mWoKof8uvFZTY08e0S6uQn
	 o4w004dTyjD356rb8g/2SDtPs1X6yjMbetP+Hyp3YNuWSjnBUZHz3bnZWTZgZDQ9zl
	 sppz/lieiSeyiSxOhKzrjGTzCqZF+n5IkicL9X9FpqKMBbGQ4lNNVmc/QB8LKH8F+f
	 N3pnK2L7vYZdUpdyjHna0kdDfzvvWbe1ntTsRxLo7fuk9JACVty2U8b04nqWG9roZL
	 OnOdsko5ITBvg==
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
Date: Mon, 13 Jul 2026 10:06:55 -0500
Message-ID: <178395521263.422064.7191945657582916493.b4-ty@kernel.org>
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

[08/14] drm/msm: Switch to generic PAS TZ APIs
        commit: 0be72be03ca7de55f22dd4c0622d81ac98aee38a

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
