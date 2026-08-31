Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1E938C42F;
	Mon, 31 Aug 2026 20:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788207708; cv=none; b=IO/qFxSFxFqAm/RN6ttWVVbEZ8SN4wYdjuF6f1vFZuLuhopuRepi4dI4SQSUWRi31HgXewR0f1gFWGoMb1YwbsSIFCMlPmvmXEdVxPbSI5nekRAKtjZju/LY0JYyA/8othcAKBEjEBcPTh2Rpf5+c5u8MJITpcoFEkL7PxMXBWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788207708; c=relaxed/simple;
	bh=baAnBGS6HUzUYibjASouvQ1Ll8c4w8rkmzbZsjAm2YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fNhx3zM/UUPoNJ5m58NtKkaS56pqMeve6kkq1X+8fgX4ISGadFeZiO6IRHYMxy+oa6+11mxeRU2kySk8LBZYZc3vfcHoznTlgnhEF8FtMQEAADCVF6Umv0pGlpjakGaUR5IMjSsUd0P3DE8K3mhjyD2fgufLYK36IR+uVDBvdfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DrRF98Jo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DrRF98Jo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2A51F00ACA;
	Mon, 31 Aug 2026 20:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788207707;
	bh=i4mXV3EO3vioncRCnbhvBa71PgQUXVNsl5KiuAmXZr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrRF98Jo3vsRDvXpFD7+P8lC1rFverf+ywAb5KCIa5S3Fd1RU5APK/MKG/PoNT0og
	 AfsxSB6tphmud9l6t3NQXy6Lx0ymx+Zufw1Rp3Y2XIa+fPrfRbYN7PKrLjay7ChlXX
	 C7fTl7sBprBAtJa9D7V+ND3ovxeJaihkdiGPy63S3fIs2kLFPbVoxNSyVz/D/+peio
	 rttll2tvoQq0Vv5Wi0iC9pn8fq6IDfvxH16BTUVhWDrqMook9DOMB2scgf+KRqXt2r
	 Odtfn53oa1nf7I+boZ52ZJwMBYcOKs2VHQXXmj5RuTe48fSy89K3sncy6RQp42PpCF
	 GndBKeC5Ij4IQ==
From: Bjorn Andersson <andersson@kernel.org>
To: Konrad Dybcio <konradybcio@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexander Koskovich <AKoskovich@pm.me>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
	Rocky Liao <quic_rjliao@quicinc.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jeff Johnson <jjohnson@kernel.org>,
	Luca Weiss <luca.weiss@fairphone.com>
Cc: ~postmarketos/upstreaming@lists.sr.ht,
	phone-devel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: (subset) [PATCH v2 0/7] Enable Bluetooth and WiFi on Fairphone (Gen. 6)
Date: Mon, 31 Aug 2026 15:21:23 -0500
Message-ID: <178820768635.1699313.4119708799289566517.b4-ty@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260403-milos-fp6-bt-wifi-v2-0-393322b27c5f@fairphone.com>
References: <20260403-milos-fp6-bt-wifi-v2-0-393322b27c5f@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 03 Apr 2026 15:52:46 +0200, Luca Weiss wrote:
> Add the required bits to enable Bluetooth and WiFi on the Milos
> SoC-based Fairphone (Gen. 6) smartphone.
> 
> 

Applied, thanks!

[3/7] dt-bindings: net: wireless: ath11k: Document WCN6755 WiFi
      commit: e506d34e57236c41cebacc43e50f35f5b52dc675

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
