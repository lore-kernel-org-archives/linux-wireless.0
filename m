Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F064E73B9
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618107; cv=none; b=feCx4VrmmuJmLxU4MLuKvt28e0/AqM39wAY4Nqg7Pf4u5Gbw2v5arGyWQBj23+geVkdsn2mph9RnVg5RupwhcbkEow4JA7GXz65YbxLi1yYKIbVWm4O5uu7MMobhpeS92P87/oGhGXObejbyWCJvqHs6o7VwzdxKZAdgGoOds+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618107; c=relaxed/simple;
	bh=6rXX3TlmKxsYP/x7KNn4p7QyzaDs70IAoTaAdnd2VCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTJQVjUk/RH4we3SeRjdLC/0IESwCHG2LnknrPssIDVDxP55BCyULi/wEWGbIS5rNaFCb6jwA0NtmT6HEP2IiN+H10jI0HymNm3QBA3kHndQPlAZvKeLKQnD+28q9VCQOw3+INMw73LHEcKrVlYU2C1sS2czHyqU0Txbt5VLy/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=L9vhzM0U; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="L9vhzM0U"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-3428f70d7e7so1882315eec.3
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 10:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790618105; x=1791222905; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6rXX3TlmKxsYP/x7KNn4p7QyzaDs70IAoTaAdnd2VCs=;
        b=L9vhzM0UpE6mghtGHaJTwkizr21OVrpptngkXR4y5y7j7AnOHhkWGEjAt7w8lCv3Y4
         1eGG8ATHi2KSwFY6eF8o7czzN1L+jFGna2kvC+zKPmkUUIJPG6fcbMlt/+Y7UBvsjWNQ
         8SN42F6XR4DcauNMIIf39+OrMpBZQHxYeMAC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618105; x=1791222905;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6rXX3TlmKxsYP/x7KNn4p7QyzaDs70IAoTaAdnd2VCs=;
        b=lJT4/KdAbxNP5O36RW+kBvo2gEwC7m53T8ZX6xqX8Ufnax8RgHCOAshZO5LsEo2TUL
         vH6I4vqD3WnMNmUy0lCfBORIgIhj/SpDqQO555PVvpiyNSwkkSwFxzg8ElDvSyVHm2LM
         Y3+wax4fiJ4W89nyU18sIsRJcQBr2NG8tG6Ixa0NGTIN5W0voFtJ8fzJnmVogJDjJYoI
         KLfeAErMaSHwebzeQ3fdWR6vv9bfJu0gCVFVi7F0zkMRKJdD/EsPdbjwoBELhiR3wnet
         7ZoKvsjtELsKA6idJScEKQY9eQxiZtP/y/L+dLKbWliSZ0sy2Kb2LsZB4a/FhTnCQRlz
         VdJw==
X-Forwarded-Encrypted: i=1; AKwUvBz6cSvSrp3+jWnLPYeRjpCQwodqHaVcYEQxhH79KZKURQZ+kFZscuig/bc7Z+S/YEMlJ1w3Xh7s/Kq9XRi/+w==@vger.kernel.org
X-Gm-Message-State: AFq9FYLfvcZgGtUutsiMjinYEPUixhObz3emQ4vvbEUMIM2Jqc5VFqNF
	HCM7PdJ95LZxKCqUsdhj6D7UOPdWJh7aGmku1WjM778/YYhLq5oc3FFBIb3lEyrjlQ==
X-Gm-Gg: AYBFou0lPNFETmpzZSywp0oxOGh2YrX7wlE2F//QxYoOgnIEKyleBQkQFR8QQRuoPS8
	z1itcL7FjU1Oa3ZuN1BqQgtv/7Aga2YhLnVVWFvy2xg0n6xmDf2TrMZhuzUKzNz1rcQUGD1A2yi
	xrriVyylPlXEx06R4e8qtEXYSUHcuFtcq4/QfjVNtaWt2eK4ZGV3BuxgMNfQaD5QFl61UQuI0Fy
	o0xrWFAg1ktcjs1hF3e6MpGyIpS7z/PlRHT1kqU1wkSuyF069BnBfjYULaUdIOf+6O9mRPFwlki
	fNl0UTmLHzAmxTbJd1KYw9Hetnxxw6UluRzWhhM/Zt2T+dNxEWrLMgUmCiJFjb59IXFMoBMdRrq
	h/qXod/psTp37fmiZaTxQGIuxWHOGTnyDYwdjGCI6J5/WLzJbyQO8xQw+hduW5nrCn4Dx5jmzD9
	LyFuv3qj9buveldcdNynOoYOfoLypcdsIe1gjD6avGAi7AomE5NcE/bnylEIU4+7VmN9/sQGxDr
	1oYfOhRDVMGB++9geNHnWfW/UY7PdxipNEEsQ==
X-Received: by 2002:a05:7300:7313:b0:33b:dd45:716c with SMTP id 5a478bee46e88-34270bc0851mr15186191eec.13.1790618103931;
        Mon, 28 Sep 2026 10:55:03 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:a706:cad8:8223:aefa])
        by smtp.gmail.com with UTF8SMTPSA id 5a478bee46e88-34145c17074sm27542619eec.26.2026.09.28.10.54.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:55:03 -0700 (PDT)
Date: Mon, 28 Sep 2026 10:54:54 -0700
From: Brian Norris <briannorris@chromium.org>
To: Andreas Kemnade <andreas@kemnade.info>
Cc: David Lin <yu-hao.lin@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	=?utf-8?B?VGFtw6FzIFN6xbFjcw==?= <tszucs@protonmail.ch>,
	"linux-firmware@kernel.org" <linux-firmware@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"lukas@wunner.de" <lukas@wunner.de>
Subject: Re: [EXT] Re: mwifiex firmware mrvl/sd8987_uapsta.bin missing in the
 firmware git
Message-ID: <arqp7k55wqW5ZgCV@google.com>
References: <20240605160013.6bea8d4d@aktux>
 <_pNnwoI9WHlb2EY635KdIv6t_goU-ZYp9Vav31jkFOCf9fCE9EeKdyCea2m-L8pgfsKIQvODlnQLhQqmWSYip9e6FFZwaJHL5-u5rdOS_kY=@protonmail.ch>
 <20240605174709.5043af8f@akair>
 <20240606101839.GA76158@francesco-nb>
 <PA4PR04MB9638D1FD47BFBFDDB096C778D1C02@PA4PR04MB9638.eurprd04.prod.outlook.com>
 <ZmlEny2W0nArOf1T@gaggiata.pivistrello.it>
 <PA4PR04MB96381A69AD86ED9C9E4AD9CDD1CD2@PA4PR04MB9638.eurprd04.prod.outlook.com>
 <20260925165814.567c9ab7@kemnade.info>
 <arag95IJHR5FiFo9@google.com>
 <20260926090026.22b00f57@kemnade.info>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926090026.22b00f57@kemnade.info>

On Sat, Sep 26, 2026 at 09:00:26AM +0200, Andreas Kemnade wrote:
> There are rules what licenses might forbid and what not in LICENSE-CRITERIA.md.

Ohhh, nice. I was looking for exactly such a file, but I was looking at
a too-old copy of linux-firmware.git -- that seems to have appeared in
the last few months.

> At least submitting it to the firmware repo (so from NXP sight a third
> party repo) sounds like some permission for distribution.

Reading that doc: actually, no, that doc seems to suggest otherwise. It
specifically delineates various "terms that will cause rejection", and
it seems the current NXP license triggers several of those. NXP would
almost certainly need to provide an updated license, not just a sign-off
with their existing license.

This seems entirely up to NXP to unblock. If they want to work within
the open source community, then they need to learn to work with the
rules of that community.

Brian
