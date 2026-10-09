Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184734078E5;
	Fri,  9 Oct 2026 06:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526247; cv=none; b=k8shpWEaRNGzB47m2KUWrn1su1dz7sS3F3g6YcscGUlaFCUIFmtyGXLEH2KDK7rf8GEC7tUMgJW3gv7+EWkHOVY2IPAKWQUO9Vhqw46k6OjSDcTsMF/NXFMxrCk+aOg2miFx6idd2L9OQcG9KMdZgIju9zjEcxVqgohVaabGPF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526247; c=relaxed/simple;
	bh=tpSWAIBE2NZmENU1+lRjNUka/ldTZzirYybVoDkRLTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CdiixzTadxVQ79MPpmULi9w26w0beFCqjLPoscm7neIKGnSm+CYf1QgzNh7Cxk7YOPPp+h35j1o6l5oRyIc1H39h+DsXpe2Fb8pY4YjFFK8c0kNC8t44kx72FiTuX7jZUlNP3rWVjYYC2caYEXhs+5zcq/KeIBWlZrSF9RAaUbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DW78Z9Du; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DW78Z9Du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5BC1F00898;
	Fri,  9 Oct 2026 06:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526245;
	bh=/zMC9Wvp0WqRqn5KkYbehx24bkhR7OpxAAkMSSa5KFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DW78Z9Du79e9xO14UOQ75C9YX6ZAZd5Zyw+Vpsjr0u792QlFyDZvNZ88ZxwKYIJJp
	 vqCXbyQnNtXhGPrlRcoS9C/I1UYDPvIo9mSe3CQ+Aav36+5XdK5d04FqhnAtEwpvcL
	 RYfeb4m/ThkmxUBYA+0+QamokZ7L/LSB3EOYCMkTkM7YVEKrNkKwVe1kbbtwL3gTgz
	 Q3T3vY9b+6BHlyBZVGjMxZXTyGkUKgQQAN8Y2Q90LRAGYAY3ymruZVv7BbGDL++t8L
	 rIhsSD8GQg3BKeV1EdPhGQTP0hO1HnG3p075AoU08MTlzSa/gPS250Mg41PRCbRyVB
	 tCSNbVtU6pI+g==
Date: Fri, 9 Oct 2026 08:10:42 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Haotian Zhang <vulab@iscas.ac.cn>
Cc: "John W. Linville" <linville@tuxdriver.com>, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>, 
	=?utf-8?B?UmFmYcOFwoIgTWnDhcKCZWNraQ==?= <zajec5@gmail.com>
Subject: Re: [PATCH] bcma: fix device node refcount leak in bcma_of_get_irq()
Message-ID: <20261009-magnetic-beneficial-butterfly-54c52c@quoll>
References: <20261008183446.2777503-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261008183446.2777503-1-vulab@iscas.ac.cn>


On Fri, 09 Oct 2026 02:34:46 +0800, Haotian Zhang wrote:
> bcma_of_get_irq() parses the interrupt specifier with
> bcma_of_irq_parse(), which on success returns with the refcount of
> out_irq.np increased by one, owned by the caller. The function then
> passes out_irq to irq_create_of_mapping(), which does not consume that
> reference, and returns without ever calling of_node_put(), leaking one
> reference to the interrupt parent node on every successful call.
> 
> Release the out_irq.np reference after irq_create_of_mapping(), matching
> irq_of_parse_and_map().
> 
> Fixes: 71783576b534 ("bcma: get IRQ numbers from dt")
> Assisted-by: DeepSeek-V4.1-Flash
> Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
> ---
>  drivers/bcma/main.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 



Multiple things here:
1. Your team ignored completely previous feedback.

2. You use multiple identities with this email, thus I actually doubt we speak
   with actual person.

3. Finally, same feedback:
You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem (so a patchset grouping multiple patches with a short cover
letter), how to document usage of LLM and how what you should not do
if this was posted in a good faith.

Best regards,
Krzysztof




