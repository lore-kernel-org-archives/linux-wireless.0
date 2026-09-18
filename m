Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533EE3AE6E6;
	Fri, 18 Sep 2026 01:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789696214; cv=none; b=TB1qJGo3zTc2crGDaTuvzhP7PmZgYi7kfqBMMVfqrCnwjHLBAY+1XVPKCELGZUou6W9aUs7bmEY11rGWpchK5lj6IdKeFtiMTU1772y2juqXn8JGlJ8Ul8+JuPsv4gmNS0v2rpSx9+2IYvFsltuk5ZcQsWC9grhtnUto+C8wsN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789696214; c=relaxed/simple;
	bh=cZlGVswHNPOjYkFOSXLBGQGteAWL251diCFKXICBO6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=proVvTVDrtEffQ6T7/nY1CXu758P0DDyEi9Sht7Z6b2R7YmH7z6IzAYwcv9JVpefuO1e0H99OzyxhZpRzRbX8ZdniNecvVBq2VHaGTHRkX6Vz8z3fZySOF0zJ77QwlrjSpimD3PnF8wTtqhAinbC8GSD0OGSNrpCpHPG4oTUbtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1f4kL/8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1f4kL/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DB41F0089B;
	Fri, 18 Sep 2026 01:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789696201;
	bh=EKMAf9Vzg9bU9tgovjaQo6jPTYOiFpv712sI9S5dxvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1f4kL/8mWyqI7hOJLKnCIh8valDE4NZiwrIugZGtn2eW4dqA49tiNj+WCxhbHGJo
	 F6SoEDcC6VlPILrAkLl9uPJJMU1U3sdljM6S/vqsgvo55tW3zvIvTXUMfOvZCK9JDC
	 5ft526LVfDNtX+TxQvmJ5mGdyKOay/5LSXhYYYg0DiSdZE4R0BGFwQovOMFJ+Br/Gt
	 gzTbWxVwhyZ0/j8aqsfnufJ0/hpvsKJhizERIjuRQZ8yqbd+Xp5Pdbp4s1wkd9JVdd
	 q6eA/gkNHxtORF/Xh3i7LMypzX6QQk2Ry68xlEBrTmQJr0zqAvFTxhMZHic4vd7atR
	 jaatjgCRW6bZQ==
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
Date: Thu, 17 Sep 2026 20:49:49 -0500
Message-ID: <178969618819.1582337.9485761608259229279.b4-ty@kernel.org>
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

[2/7] dt-bindings: bluetooth: qcom,wcn6750-bt: Document WCN6755 Bluetooth
      commit: 15e9f90a4d86c9537e14901898ea1ab88a048169

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
