Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CB5375ACF;
	Fri, 17 Jul 2026 03:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784258628; cv=none; b=lq3/ha9bSQ+G9xBbrkpBwEZVUQR6bn1gmg1NNWsjF6pBTZsaa2WIxGG4k6L4zL8YPDILVJSwx6ALLh+fsAgFfinKXRu/vZmy/ybGbyWHweF1q3BFvawc0SfsJvE38ym3bzytPpyZHTQ9UXkSaqbVbw734kjOlHqqUAxxY7MaU5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784258628; c=relaxed/simple;
	bh=ODwML5rJqM3Y9J+1dv0JFw4+OGMl1ouYw+zwW7IM/k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tJIltS9OvNzFNJRsXg9dlZg2P3NrWZYH5vjD9jh3bGHFqgGzK0g3j+Ar7N2PJ3tNPq3inYe/y0d+gekmJ+nYWx5kfX7dS8eD1SrzkZ9VDyre09sHV2zQTg9cTyDE5sWNVQZD7A73k/6qp8LER5KoY4Gl1RfLohcv+1yaPUBBGp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUqzZrRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUqzZrRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2FA1F00A3E;
	Fri, 17 Jul 2026 03:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784258621;
	bh=2Sawr9XzpFp2rxdJvgZDvuQs9ByLR9DjNmLMSBWdSiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUqzZrRQ35Qd5vZtf84WVjc55Pe+9QyiuUlC2fPQI3Emosr2TfhiCPsVYcjYv6Y+9
	 7rB2f9bUmKXUDcOq6jq6c6twbVnweBxRJJ1w1c7zm3pP7tZ4ZTknIgYVUjtAvwRXoo
	 h8wTaCURvriVcBDQKHRFsf12bXNYqFxWHuemCFAJ9C6G1fcAOA6uBs+0llH5+Lls1Q
	 nZKUKxnkmN+C5L5L2sDBIE3/mLvt/V9WuJcXXuvkuv0h7JMX7LFHA6a3h1PxoWcd/J
	 J4xYNaMSSSGcCBM2ZIGkBsnMh2rsw3k1b/fDJWL864fh9m8H1D0rhr3kvaZ54101+W
	 cMArFnvJ2P4Fg==
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
Date: Thu, 16 Jul 2026 22:23:28 -0500
Message-ID: <178425854615.1084804.10241911437238961566.b4-ty@kernel.org>
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

[11/14] net: ipa: Switch to generic PAS TZ APIs
        commit: 85b88ceeeeb7bb93cd0af7ccaf2a4b010d5bc5c6

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
