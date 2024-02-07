Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D849131A6B;
	Wed,  7 Feb 2024 18:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707330983; cv=none; b=MLrUaW6wRbAcdKeW6fPrJKANGEREXbHl7dWo0+dccYdBecJ6+XyNcfA//mxPcfl6DakOIRD4zsYEHbgGf05JZCVBtQGpIL+UGnyrWTDWjPoszznk7oIvV48Bk6FSVUE6QFS71Nib58yFl7aIG9CUKIJMvFGHHW4HJcke6tlfeeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707330983; c=relaxed/simple;
	bh=gXm5WVFNtj5VnIEEhQdrT3BhRsWV9gkvhypeG0+0z9w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sznOPrfSiAWZ+w3m2o4hvsFj80hul1o/Zc3lWSyP59lrooog90ZUIt3HgdbZXIM/7vthEBYdKbmE0LrXpPf3LoLGCFapFvsEp+ALSp74jKJA5ury+UgWbZ08gzxvJCyPi/pgUgDXn/Rbqb6inHyveHUBXk8uwianZuC6ebKc2lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCGoVibD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCGoVibD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE73C433F1;
	Wed,  7 Feb 2024 18:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707330983;
	bh=gXm5WVFNtj5VnIEEhQdrT3BhRsWV9gkvhypeG0+0z9w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VCGoVibDcuEzr/EEiFBFG2/hrGl7ZLB+ipGTiIyl9eHUCsRNAYOvzf/bcBuojcc2U
	 6UK45gWBChxeLkC6g8bMJHH0Bus5ESTV6kenzzxMV7lKUgt7nNF+0cr4Z04dqKfitq
	 4v5UqmyJOw5nLcI4UqlXk/IPW9GioRHrs+OJs1W1xXto2DVO43GxDBRZKhP/XLwOB7
	 KfTIvbOl3ZaTCeG8dEeOCfOM4chhKqmRANSFbyh3uS/iQvRL94Y86FkNcHhJ/JqGgw
	 oGfShwPxlZGSWDJJGQcyV1U4r7dzeeamS+sqBkZP1uul0y5p0vBejT8xvKlaVHbGOk
	 dSuf3UVErXyZg==
Date: Wed, 7 Feb 2024 10:36:22 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Kalle Valo <kvalo@kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-2024-02-06
Message-ID: <20240207103622.6d9d4697@kernel.org>
In-Reply-To: <20240206095722.CD9D2C433F1@smtp.kernel.org>
References: <20240206095722.CD9D2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  6 Feb 2024 09:57:22 +0000 (UTC) Kalle Valo wrote:
> This time we have unusually large wireless pull request. Several
> functionality fixes to both stack and iwlwifi. Lots of fixes to
> warnings, especially to MODULE_DESCRIPTION().

 	Errors and warnings before: 1105 after this patch: 1059

Yay! :)
