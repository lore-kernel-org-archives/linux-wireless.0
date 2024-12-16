Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EE04F20C
	for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2024 16:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734365717; cv=none; b=jDZ2FCI/GBvglFjGqpkHFaCg/ds+82Z735JMW/fQgyyaA7lQiFt6wt66V+gmBygEssmd30mPzpL4kqtrXAjMBaYKCBuMLhmaGA8ZcVRYvxiwKV8DfyvygmmhaibhHsLLb2nhFCXs1ysNX7VVqpqcPbfqQiH2H1hlNvGbP3tO2tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734365717; c=relaxed/simple;
	bh=kQc4WqYLikLO8KzFWTQDDqCMkg1YfUkr5b9oT4SpHK0=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=HddFlBNlbn36sAyXf4AtGztEBQlWUr7EfcfsCAIzrUKMrjdoAj3TXksgEGr4in/+c19uvVrKRPxwtZyIrIboyj9unK/cfk8LnpbBhrY/oV2Aql2d/n1QVWWBbdFWlf/VEXiYGo7/DglA9EstAwyqDJHlJtMAL6tIKuywnh+20vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iYLJLmCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iYLJLmCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD12C4CED0;
	Mon, 16 Dec 2024 16:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734365716;
	bh=kQc4WqYLikLO8KzFWTQDDqCMkg1YfUkr5b9oT4SpHK0=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=iYLJLmCgvTP4poWfJGSsryZPzGVH2CFGrw7dhL16sSbZmY8Ek1nIoI+7C+n1mItpn
	 CK8XFNuV7fXSjzo7UZJ1obzjV2fi18EVeqoLHU7IhWbs1dHcIXthysSYMchaovWrjw
	 dQk8Ldm2SRmI4An4vkZ7bv8IlcNHDzoAnPOjX78scqDo1AjZR2FCUGUbV8JhpEshDT
	 U/8t4JTBVbQ1a9FkWNStQUacUVqHsvZ4SGk54AWRzbx/9ADYn4urq6MkBiXhHoooAj
	 J7GNhJWo4O3a9nNCRKARrsdvrMpQr5nH9tgzXM6azLtDc0f3egLGd98qQiW97Q0DX1
	 s5gqDu+SGstow==
From: Kalle Valo <kvalo@kernel.org>
To: P Praneesh <quic_ppranees@quicinc.com>
Cc: <ath12k@lists.infradead.org>,  <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wifi: ath12k: Add support for parsing 64-bit TLVs
References: <20241204071238.948885-1-quic_ppranees@quicinc.com>
Date: Mon, 16 Dec 2024 18:15:13 +0200
In-Reply-To: <20241204071238.948885-1-quic_ppranees@quicinc.com> (P.
	Praneesh's message of "Wed, 4 Dec 2024 12:42:38 +0530")
Message-ID: <87o71bmwoe.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

P Praneesh <quic_ppranees@quicinc.com> writes:

> There is mismatch between the format of monitor destination TLVs received
> and the expected format by the current implementation. The received TLVs
> are in 64-bit format, while the implementation is designed to handle
> 32-bit TLVs. This leads to incorrect parsing. Fix it by adding support
> for parsing 64-bit TLVs.
>
> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
>
> Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>

What about WCN7850? The commit message mentions nothing about it so I
can only assume that this breaks WCN7850.

Please remember that ath12k is not only a QCN9274 project. If I got 0.01
EUR every time I say that...

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
