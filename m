Received: from mail-43170.protonmail.ch (mail-43170.protonmail.ch [185.70.43.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DD94219FF
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2026 16:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781107853; cv=none; b=P/2Fru8PhD0fJF3MxkeEtXS5qjIbwpCscGqiTItLaY3Pc+ARNg/+WFZl7Z/OC2/BfSIe2n+yMWWtw4ef6fJM6tAOEqlZKCXvGSzJ2Sjjgp6ChjBH1bDXIf51sTMS63VBB3y3L5khHYtu2XlFOQV+ZNTzsWZFmlfOwjPOL+CWHr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781107853; c=relaxed/simple;
	bh=n6myGGLlEswD+VGjTFRSobSrXkL9iSUqLoHocO4EGsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4QwXpR9YRbMeUEPC/Ee6z0bagEHXE/3Gxj/bzNlnlpiGBPyg9BNEJz6TUf6wmznfP8Rg4d8gFa1w5pbGipPKDQDsh8ylzd9pWC18HXTZqeLHPBE8bzCdUlaQS865Rt+WVGJqUg/wkNwfQy9MGrA/yWd0671aJl3qa9i2AT0zJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beims.me; spf=pass smtp.mailfrom=beims.me; dkim=pass (2048-bit key) header.d=beims.me header.i=@beims.me header.b=B+17TuVY; arc=none smtp.client-ip=185.70.43.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=beims.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=beims.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beims.me header.i=@beims.me header.b="B+17TuVY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=beims.me;
	s=protonmail; t=1781107840; x=1781367040;
	bh=n6myGGLlEswD+VGjTFRSobSrXkL9iSUqLoHocO4EGsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:In-Reply-To:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=B+17TuVYAK/T7Tsns3fhiYAGhVIeSUf74wNpJ/4+3mt0gNteGz82Myu67O3ODNF2h
	 ZmUpXKjt/rIVRMj0XEBQpttMyySEOWhxj8He6AYNgEjAfT2F6QT96jsuczDbtw43JP
	 GFi0VZtezYvx9WLaejXgug5MPeRjotFLhroeMIBkr79+xnFBF0IaH6jnm2UVA2AWC1
	 T3toHophlJ8POF0EFWcm8DufFs8icaFD47q/Z+CMab0GhSPp5e9KI0fAeDhTVRzVyf
	 TWMoXuZzvtUU2bY5vi/MQRKWO7bOpLXlTnN30SevCa9PZDP7AFeissnk8KWmFYUndF
	 j6c5xZ2A+/dRA==
X-Pm-Submission-Id: 4gb9jm68gbz2Schx
Date: Wed, 10 Jun 2026 13:10:32 -0300
From: Rafael Beims <rafael@beims.me>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	briannorris@chromium.org, johannes@sipsolutions.net,
	francesco@dolcini.it, wyatt.hsu@nxp.com, s.hauer@pengutronix.de,
	ulf.hansson@linaro.org
Subject: Re: [PATCH v12 10/22] wifi: nxpwifi: implement cfg80211 ops for STA
 and AP modes
Message-ID: <aimMeKc7yODvwNOT@burns.beims.me>
References: <20260605161335.2415583-1-jeff.chen_1@nxp.com>
 <20260605161335.2415583-11-jeff.chen_1@nxp.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605161335.2415583-11-jeff.chen_1@nxp.com>

After a quick check, it seems that this patch contains the same
problem being fixed here:
https://lore.kernel.org/all/20260610150021.1018611-1-rafael@beims.me/

Maybe it would be worth it to confirm and fix it before sending the pull request.

Rafael
