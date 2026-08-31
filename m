Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A56237AA65;
	Mon, 31 Aug 2026 22:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214033; cv=none; b=loxoXCRbm1Ns2sdYlaFk/04WZqRCQ6zupqj4OJ/PkUQBUdCBjb7NeiBpYS1I5aZ58AZ2OA1Z8KaXJShmIm8iPdHcqNMOkX+1NPHC2g+I+pYYUGL9NY0n2uFGzfSlRsmCW0roxmrQbwyWRBEnwPLlWXZa4K1FA1Xlv/S+kGMJI4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214033; c=relaxed/simple;
	bh=yp51dUsBfJr/qx894VTDIv+37PybbiqJ9BORpa7P9hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iIXnY0aWYoDYZTaQ3Zjk9X4Hc1ndB01KRKfQYS7fs6cFVnkeeBBUJcKC+HjLRWtrLsTK9FIqWpqt7zRfdZMlcGaX+rOoTu0SdjBu/Lce227Gkxsam0DBETFsQlhR0hEOvxgsSmbt+c89CMJK//ofRE+0HO04s7IxcsKNykmqpn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gYnoG23j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gYnoG23j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6401F000E9;
	Mon, 31 Aug 2026 22:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788214032;
	bh=OvuYd2E9gNoEafLJQR92iLzGR8RBPvPVUyVxGnAPjF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYnoG23jCYrZH9URvUkK4HQ8u1Y6rRbB+8IwiaAp6UhhaEmRaPOT3Ngz2Z4VCY7Sv
	 GwmBOowSmdCdbr2xCF4omQIBbTDWpWaNvbBykc8cFezNpu1mRYW0OPHKT2gAYD7sc+
	 EMv1yltzIr/Yz9erkJ0K5dKroK9HsYTt00ckq8iD/xNvg0PD2ZeViy+bGPyrD7T7Df
	 6beBM0whRsZmwsBAUBq/Jz3Ds/ClEqxoQ0jws07Fh5m0S0YmFlkhhxXYZjx2m0VltQ
	 LXnxB55DqI2y3JxXp+9D9uHtZObB9Z6dU302sCKiMgRFW3FzsTcvQOQNbr/50p75N0
	 44dch5lJjT2ag==
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
Date: Mon, 31 Aug 2026 17:07:06 -0500
Message-ID: <178821402262.1706165.9287098624107788227.b4-ty@kernel.org>
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

[13/14] firmware: qcom_scm: Remove SCM PAS wrappers
        commit: 3eda4fa73e30207eb7afedde6987f7f321f74fbc

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
