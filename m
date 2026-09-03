Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8843876BB
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 05:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414662; cv=none; b=QabvmiIo9JpTHJgno5DAGGmdTRXnV0PJpy8v8aqNgEAhyZtuWCMVw9N2WhTJQZ65dgqRysfHZsUb/morZlra9ILdzEQff2s0APd29JgXfvgfgLy2r4EG/mptEF7txwKGESRHdF93nM0Z5smSIOGbe9/7jaWn1FTZvzwHLkNv8gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414662; c=relaxed/simple;
	bh=+gVhpxcksjKVyl9EAwj7Sjb4BGkg9V3deVP7DXNIZSc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Qgbnl5wtwbWcHfDeqa9qnSzuy8fXf+3R532J7i3Nn6sEwx9MgStVv2MKN2BNbahZDxGPMqbd4Y+TxRAQMDLk/8EzD6kBwX1CEu/6B3oZ4pC63OM5UsmKy0O85grxwz7aUmzT7xnCqbJsabqECZ/CuFuRwP1C/Qub/zE8EYxg7ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BWWXl674; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BWWXl674"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143801F00A3A;
	Thu,  3 Sep 2026 05:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788414661;
	bh=Y0d4ZkvIsJqGDcwfEHltdfaJ72NPOzJatdFgoZDNW54=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=BWWXl674GRGX30sXBxJ5BlaztgE95PwTcXVyA7pqkQjiJnEziMdOHLxOFzI7vHEyc
	 cynPaEC2AyCQop/xCQQ3665cc7fLnrEc+trHp1CqgTOfxAUlpgO5Kx5n+nVgSyj0WV
	 rhqcPHE5dhF3ibvRWxOCMMnkJAr+2kr+OHdMD8VlN/lmkpsrpzsqS01w6qAHx0zDa3
	 Slq574ZqpROj7OgJYYi1HBYUx9uUrpc1rziJdYu2pYgtAjMzU41WTSJ6JuK4dG23MV
	 vBS5OJdAphNaFkNdAyyjLgYI3NudiZCehc0SbjG/Wu7bfrNgkk+uLU/0yHQRixPBUv
	 ow1gPKBIk7nNA==
Received: from wens.tw (localhost [127.0.0.1])
	by wens.tw (Postfix) with ESMTP id 731065F82A;
	Thu, 03 Sep 2026 13:50:58 +0800 (CST)
From: Chen-Yu Tsai <wens@kernel.org>
To: linux-wireless@vger.kernel.org, Chen-Yu Tsai <wens@kernel.org>
Cc: wireless-regdb@lists.infradead.org, Ping-Ke Shih <pkshih@realtek.com>, 
 Morgan Wong <pbodq2@gmail.com>
In-Reply-To: <20260824070730.2089862-1-wens@kernel.org>
References: <20260824070730.2089862-1-wens@kernel.org>
Subject: Re: [PATCH] wireless-regdb: allow 320MHz channel width for Hong
 Kong (HK)
Message-Id: <178841465844.2208520.10356423568006013058.b4-ty@b4>
Date: Thu, 03 Sep 2026 13:50:58 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Mon, 24 Aug 2026 15:07:28 +0800, Chen-Yu Tsai wrote:
> There are no restrictions on channel width. Allow 320 MHz channels on
> the 6 GHz band for WiFi 7.

Applied to master in wens/wireless-regdb.git, thanks!

[1/1] wireless-regdb: allow 320MHz channel width for Hong Kong (HK)
      https://git.kernel.org/wens/wireless-regdb/c/8f1e802020f4

Best regards,
-- 
Chen-Yu Tsai <wens@kernel.org>

