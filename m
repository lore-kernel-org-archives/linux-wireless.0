Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BCC364038;
	Thu, 30 Apr 2026 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777571787; cv=none; b=Ovi9DjCMfBwRd+ahMvDqDaD9Ddyp4r00KRs1pcaG/0llZJpPcaY4N6zjrpX2rhEbO/hKNhZTA639IVkrZ5wBBXM1juQ6xvIW9FYTYcMJ+SO/wmVustFvqGcC8ApVkzlnO+3wCROTOG0YCXU5SzH6INRVdKYHq/AjW7wVFgVqLhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777571787; c=relaxed/simple;
	bh=bxJhILJOj52ikSwAlpqvCXweZKZMwSWKG7xehCSproo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=PRQwsy/vM/GIDnEmCgm24HJUA8gIgVyQN/KJwn2fcI1w4BbDC2KVCQ3YdB6HjJ5b/9ScQmCWWyraR2A2KMmEeZAqo0CbsFR41CO8q7T7hxLC8Kgj8I+9Mi78cg+9MUi1jSqQQv+lx+mb2TbOxYLHQSgXMTWN2QI5KNVe8GUPkJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EnW8loyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EnW8loyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7F7C2BCB3;
	Thu, 30 Apr 2026 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777571787;
	bh=bxJhILJOj52ikSwAlpqvCXweZKZMwSWKG7xehCSproo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=EnW8loyDS+MFh9w1Z8tgZUxJJgHEupnAfw00NSjwn9rJL9EmNSfwcnkp6XsHz39Rp
	 Fi7xE1lr1xiSz6Me0DCRM0xiw9owT6ttmYSQ0bs22vCtCEiUOFamgkcOUks48jVjxl
	 HMx37kydLKviLYJfKsv8L9IEmrJvopNxlWPqaWrPvdFWY7SiA12CvyGl4y9f7YHsdx
	 c5hpEnT9/LxEXfJ8lWaHSGMA0/s/usUCwOMuzCU9GtlCtviNlJopTlNxhQpjbS+3cV
	 zfGz+w5er68eozEZBXR2zV1V5ZP3UDs7EYMiS/juDxNDH95MD4C0RwR3nbthmEq3Z6
	 sE97C0G75clVg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9EE7380AA62;
	Thu, 30 Apr 2026 17:55:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/7] Enable Bluetooth and WiFi on Fairphone (Gen. 6)
From: patchwork-bot+bluetooth@kernel.org
Message-Id: 
 <177757174129.3109994.12376905026107591695.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 17:55:41 +0000
References: <20260403-milos-fp6-bt-wifi-v2-0-393322b27c5f@fairphone.com>
In-Reply-To: <20260403-milos-fp6-bt-wifi-v2-0-393322b27c5f@fairphone.com>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: andersson@kernel.org, konradybcio@kernel.org, robh@kernel.org,
 krzk+dt@kernel.org, conor+dt@kernel.org, AKoskovich@pm.me,
 lgirdwood@gmail.com, broonie@kernel.org, brgl@kernel.org,
 marcel@holtmann.org, luiz.dentz@gmail.com, quic_bgodavar@quicinc.com,
 quic_rjliao@quicinc.com, johannes@sipsolutions.net, jjohnson@kernel.org,
 ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 dmitry.baryshkov@oss.qualcomm.com

Hello:

This series was applied to bluetooth/bluetooth-next.git (master)
by Mark Brown <broonie@kernel.org>:

On Fri, 03 Apr 2026 15:52:46 +0200 you wrote:
> Add the required bits to enable Bluetooth and WiFi on the Milos
> SoC-based Fairphone (Gen. 6) smartphone.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
> Changes in v2:
> - Drop applied pd-mapper patch
> - Add compatibles for wcn6755 with fallback to wcn6750 (wifi & bt)
> - Rebase on linux-next
> - Pick up one tag (discard the rest due to addition of wcn6755
>   compatibles)
> - Link to v1: https://lore.kernel.org/r/20260116-milos-fp6-bt-wifi-v1-0-27b4fbb77e9c@fairphone.com
> 
> [...]

Here is the summary with links:
  - [v2,1/7] regulator: dt-bindings: qcom,qca6390-pmu: Document WCN6755 PMU
    https://git.kernel.org/bluetooth/bluetooth-next/c/b043657c35e5
  - [v2,2/7] dt-bindings: bluetooth: qcom,wcn6750-bt: Document WCN6755 Bluetooth
    (no matching commit)
  - [v2,3/7] dt-bindings: net: wireless: ath11k: Document WCN6755 WiFi
    (no matching commit)
  - [v2,4/7] arm64: dts: qcom: milos: Split up uart11 pinctrl
    (no matching commit)
  - [v2,5/7] arm64: dts: qcom: milos: Add WCN6755 WiFi node
    (no matching commit)
  - [v2,6/7] arm64: dts: qcom: milos-fairphone-fp6: Enable Bluetooth
    (no matching commit)
  - [v2,7/7] arm64: dts: qcom: milos-fairphone-fp6: Enable WiFi
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


