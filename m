Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815ED2750FB;
	Thu,  9 Jul 2026 19:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783625569; cv=none; b=XNC4L1m4vgsBpWr0w1DazUMn8QDQ0MxGhTXJtwxxK40YYTCPwSvR2SiVzQjVz54T+UBBiL5Oc2iUCBo8+h/tTSYsIRrfFj8wpm5vp5GHG3ry8+YvSWBO9UR2bzKtfgiWPHce23qUtWcGeD5eksreGbMHt5B46TOPc6YcG2mAZE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783625569; c=relaxed/simple;
	bh=lBVcNbE3SdloI5j4P8VPbIu6NmrvZndG9ZjUXvjaqfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TFTcnLos4OqI86xXTqRDbcr+Cil5Phkyqb9OksLquAU2EDCtJMyfuxjI6fqC8o61JL+ToAaoDJJ16Rq03JegWRlo6Yq9Gse/mDtBI0nTsRVGdKbdFK+CowT7LFfKjs3NyeSsPvAjqYeANxRu5H2ESKg8IvkM7srNqs8Fnyc3Nxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=auzMKv1K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="auzMKv1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244A21F000E9;
	Thu,  9 Jul 2026 19:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783625568;
	bh=kAnk8wurZx5c5OpGGojggK9/9lXOvy6JHQHST6N14hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=auzMKv1KlscxwXNmEZXTOFba3AzC1zvV5+KdLqK0W5IDP55KMnvUDomWlmIqurbJq
	 KvnBdQZTeHn6OnilAVzhRDXElp2+lyOAqSt8AzaPojSa6/oownhsZAeRZ66qSpL/oZ
	 QPffV5w4Rg1Ou9qpCF7MsXqreDvfczmOByHdhc/WAsKhMv9fb0+4/LyVRMjvolSXnM
	 gyP9Q5qvjQcq8TuiOCwfjhGGvo1RbIJw+Ef2lv9z7fc6OWQJoR7zsX7App24WvM+x2
	 0Sx8wwnFRJlrbavFkDmXz0Sm0yUuWQncw1ncAwrPth0JOYmqq7jEyRTmUKtvOrGDpc
	 uBdy+bMWI8DJw==
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
Date: Thu,  9 Jul 2026 14:32:39 -0500
Message-ID: <178362521364.2422497.1305957434056184382.b4-ty@kernel.org>
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

[01/14] firmware: qcom: Add a generic PAS service
        commit: 08314e7c2c38b9ae6a5e01c58ed10a950859404d
[02/14] firmware: qcom_scm: Migrate to generic PAS service
        commit: 5c1a2975d23c51c01aca51945d0f10a4ee4c9020
[03/14] firmware: qcom: Add a PAS TEE service
        commit: b6f7978da0c4d26fe465aa6634f5a0b48f900de0
[14/14] MAINTAINERS: Add maintainer entry for Qualcomm PAS TZ service
        commit: 6701259025d49139131a0eb2257659a066dcca22

This is available as an immutable branch, for other subsystems to pull at:
  https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git 20260702115835.167602-2-sumit.garg@kernel.org


[04/14] remoteproc: qcom_q6v5_pas: Switch over to generic PAS TZ APIs
        commit: 254030af0d81b12b7624d9ce85c6bdd3171629c6
[05/14] remoteproc: qcom_q6v5_mss: Switch to generic PAS TZ APIs
        commit: f3b1357673ddb37ae8b9a8fe44df73cbd2a519c5
[06/14] remoteproc: qcom_wcnss: Switch to generic PAS TZ APIs
        commit: ea3b5245f5deba916320b32a8e6510a74c034c17
[07/14] remoteproc: qcom: Select QCOM_PAS generic service
        commit: c4383254ac7a529736577e304176a10371c2ee0b

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
