Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA6A3E5A20;
	Fri, 11 Sep 2026 02:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093558; cv=none; b=DA2Ip+cLmkeoxg7o1UZ4m8OazGvwLp5NHaQitC1HzcDIax0S2MOtiDe8lHDKgHR5eZDe0XpJlDeZvXLQngUoY2WtrAI/dLHHT+nS1pw0L+Ee+Z85V0YZv6afm6/FuuXIImH0WsJjdhlDtr/3liiUWz9VPCG3Pgis9JS4NE5Yi4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093558; c=relaxed/simple;
	bh=1WHJc2vBfbhN1u8S6jXwy1X7nOLX10IRUi8veykyYo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GA0QK2Qj9mTgGcahHHvN4k+8zGL9/UW+y4ddL02p7D1CrPH1uSyjLvELhMM71hAbxLNCUgU+fZy/Kn9c1miDaNNeS2t95z6jwlrFO42t8Df3MJj29YHG/AG+oFAsacyn6vTZlUctDlLMqRdn4KBLyn1k73QxdgiPHRixXbNQy2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UGNiU1My; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UGNiU1My"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91661F0089A;
	Fri, 11 Sep 2026 02:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789093556;
	bh=gsrQP+FKX7ACjXnioTe1PG7XirWH9x4PyAmk/UhDN6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGNiU1Myu3dLWOe3jlEypuiaVcN/rK8Gel2dEmf+zsSRFkaf/23qZz9othH7DtSZB
	 lJRqFrkyB3FKEqnG4y1zLAAlhLBSqXFMrml+81epQaaNzKdMwNZshbGGzCVRqN4k8K
	 4WTyC91TWsTj6+LMJ828U3YiOyBUirQaUSB8NTa+B5xcjUzK73MOKbtPvrYvXBCfcU
	 IW5gMM5LmU7lWhScRk+3fNXFL8cHOoAmb7TIaydOXPy1dMpQDZJjR+iQY5m6G77iZZ
	 PrgukZphQ1zkcrbuVAjf1b80Y/3WosaT2KYlPvhkMlnvix7BJ4nSsh+iwBsjjSvL7F
	 u7xBlVY0CM8LA==
From: Bjorn Andersson <andersson@kernel.org>
To: Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Linus Walleij <linusw@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-arm-msm@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: QCOM interfaces should depend on ARCH_QCOM
Date: Thu, 10 Sep 2026 21:25:34 -0500
Message-ID: <178909353836.920241.11751783764687425864.b4-ty@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <888efe8e63b6a18fae4acd5a90a1e0e69dcdf2ca.1786012495.git.geert+renesas@glider.be>
References: <888efe8e63b6a18fae4acd5a90a1e0e69dcdf2ca.1786012495.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 06 Aug 2026 12:35:15 +0200, Geert Uytterhoeven wrote:
> The various Qualcomm firmware interfaces are only present on Qualcomm
> systems.  Hence add dependencies on ARCH_QCOM, to prevent asking the
> user about them when configuring a kernel without Qualcomm SoC support.
> Make QCOM_PAS invisible instead, as it is already selected by its users
> when needed.
> 
> 
> [...]

Applied, thanks!

[1/1] firmware: QCOM interfaces should depend on ARCH_QCOM
      commit: 8fecd3194de338bdc0c57597be61fdcf33e1832d

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
