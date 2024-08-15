Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FC51714C4;
	Thu, 15 Aug 2024 09:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723714991; cv=none; b=CdZyECOmki82LyRb/vF0bAMe8tU/iZajFpq7pvqea0s7UqRl4CCFBSx2olFy0sC3Qa7jwqFrylGmi5a5MonDw80w0lOvGQR0gfS6WKG3cae/z7cufF2snlKSNMJ+8ZSykCdfXxkWaXOVwUrXsfCbwQ/I9ePCGimXqNt3dRvMK1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723714991; c=relaxed/simple;
	bh=J/6CNqKbHSOfeOObDnt9v9X0seHR34W3LJo47Nsr+mA=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=L/k8LOmKdjRaEczf6krhCvEeZFFqQFXO/yFEWvXNlmhIkhTfGZ/AYrMnGZdtb1vCtXxaeT26FyEO8uHkDiFxo2dG1q8vt/Kcm6Hfh+/bFAWrG9BICKaHfT8zqsBL7DDYgjoeSYM4kEhEVe3kcPH8Jiyp5WYC3RwjHmPFr6BKKE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ud0V1iui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ud0V1iui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D99DC32786;
	Thu, 15 Aug 2024 09:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723714991;
	bh=J/6CNqKbHSOfeOObDnt9v9X0seHR34W3LJo47Nsr+mA=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=Ud0V1iuiLqyd9yRfAvzaI7nbl0v1ms+4hogLEbKvHI5tCE4lygeolZzgV5ro7eltq
	 QAtqy5zv0jpSIK8L4/h+qxojRZYz9ACTxrU6+Bp8mNdQLsZ2orwatbzK/jEbruaVja
	 LQi63QEUnCNaB8YmthbGg87D+zuui0wU5VVNHBRYGg2OsitpcVvFBcGXy4U1qmvJeE
	 X8Kfhs+zRuJ6BxxQGdDZBPnANuWbP0xhUuTw7rfoRveSd4oNQOWwPvatZfHpnp0BGQ
	 iklB6VNXm/Hy0+YBIj8kn8zfd+AzfzJVEfzVgb9EjHlojMbqYo1FXEAQt+g3df8YlP
	 raMd/WKuveGhg==
From: Kalle Valo <kvalo@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Lin <yu-hao.lin@nxp.com>,  "linux-wireless@vger.kernel.org"
 <linux-wireless@vger.kernel.org>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,  "johannes@sipsolutions.net"
 <johannes@sipsolutions.net>,  "briannorris@chromium.org"
 <briannorris@chromium.org>,  "francesco@dolcini.it"
 <francesco@dolcini.it>,  Pete Hsieh <tsung-hsien.hsieh@nxp.com>
Subject: Re: [EXT] Re: [PATCH v2 40/43] wifi: nxpwifi: add wmm.h
References: <20240809094533.1660-1-yu-hao.lin@nxp.com>
	<20240809094533.1660-41-yu-hao.lin@nxp.com>
	<2024081430-derail-diocese-78dc@gregkh>
	<PA4PR04MB9638C1186FC4D56569D7D0E4D1802@PA4PR04MB9638.eurprd04.prod.outlook.com>
	<2024081523-curator-pronounce-4619@gregkh>
Date: Thu, 15 Aug 2024 12:43:07 +0300
In-Reply-To: <2024081523-curator-pronounce-4619@gregkh> (Greg KH's message of
	"Thu, 15 Aug 2024 07:08:01 +0200")
Message-ID: <877cciyvdg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Greg KH <gregkh@linuxfoundation.org> writes:

> On Thu, Aug 15, 2024 at 01:52:18AM +0000, David Lin wrote:
>> Hi Greg,
>> 
>> 	Following the guideline for new driver, it should let every
>> file as a single patch for review and generate a final
>> 	single patch after reviewing. I think stuffs mentioned by you can be got from cover letter.
>> 
>> 	If I misunderstood anything, please let me know.
>
> Please read the kernel documentation for how to submit kernel changes in
> a way that we can properly review, and accept them.  As-is, there is
> nothing we can do with this series at all, sorry.

Greg, just a bit background for this:

Because wireless drivers can be huge in our documentation we have
actually requested to split the driver one patch per file for easier
review and avoid mailing list limits:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#new_driver

The final patch to be commited will be just one big patch with a proper
commit message.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
