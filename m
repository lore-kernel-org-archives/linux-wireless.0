Received: from out203-205-221-153.mail.qq.com (out203-205-221-153.mail.qq.com [203.205.221.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B97834A797;
	Mon, 12 Oct 2026 13:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812582; cv=none; b=dp10C3JeLEmWLnRwVBoYrPpeG1t3LG3sJW1yZqrzmbQ1STnZYAQ8mRYwOR6Kkr7Fe1CrjWGItUp43WU0opK9uOpysWQWwahzYzsgJAHpijgXGnzLvJ8CZ5aQX02vUMztYOeXZFopre4HqMcFBOlHxeVWRMLrHrJRqbxHF6S/ALo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812582; c=relaxed/simple;
	bh=Y18ogn0gqtieb1sLuTqTsM9ccFM2YaweZGTDZPJGvsM=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o4R88EuXzRxJSCFa1GMtx9x/dTXCElATcMLmw2FQPcdm2r2khFwyPhE3bF2dmYl3c71IXg+2xsC9Bvibqswm2nVCFc22gpVQ0IItL55l0vCvlXEqWCDodqnGdKhwD7ysnxvEo2pW9+sI31RFvueQkeo+FMwoj6r1cAD1gpCbZaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=LZzAp+d3; arc=none smtp.client-ip=203.205.221.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="LZzAp+d3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1791812569; bh=FdMBeUyH9/KPSqkAwxchV4wK08hokb4rFryGn1qp4nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZzAp+d3aB6wJJsak6UpEF9f5p5oVCDBgCiI+G6NC42WmXR6nV9paRUGYsLCVbi1p
	 5sXzJMYjLtJ+76WfywDBw3qYVQAVML5x4t3Q5Aq9LPHwfE5SfHzYSrMvq1pHPZ2v9z
	 tHwsRBqR0sddKn4v65Q2RyNNOEVa24MXsLao695Y=
Received: from chichu-arch.ibis-mark.ts.net ([27.38.246.181])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id AAF836EB; Mon, 12 Oct 2026 21:42:47 +0800
X-QQ-mid: xmsmtpt1791812567t8aq6c6kv
Message-ID: <tencent_B6DCCE2CE592B4FCCDD65E6D07A91C4D6307@qq.com>
X-QQ-XMAILINFO: MBP/tcZPA+qnRzKiw4aoT0zuxD7/mILx01e40A/xqWOvC1NaUsW35PA56rRghs
	 v0CqZMocfYy4q/w63CRkP3WAD+oBgZUhVRgoyMGPjyn5msQxfU3dIXOUOM770MBRO/xrZQ1C2LlA
	 6gDVW9FzZomnh84Ro4ieHzD4uHhJk/2Uvk+bmcahIdpiqvVxVfWsv97XlETuYxHD4gJtCGI4DX4i
	 Di2VSIujeEgVOYUNWR88l13vGYKAKCAEIXmXiIFLzLEI9uI24pyrM7r00f/jiElH1ZoU1/xZUWYy
	 09ygm3z9lN3S5cDOB7jQj5UNuQeYlAHLfhcxogG/owXCtTDoCozAS3RfRFRtfC+AZ5f9MbTG97fn
	 XH9Wk/ZZoK3XD1ZUWWhUXaFfIH1/4UXlHqMUTNL354uqyownfVxLEoB6GwBQpZK4pO0cdVtrG+GD
	 Hh7mrAxcQtJZ+e3+QSQ6Jy6CVvMZMxplVxiv7TWiLnPiok6It/j77VRDL2WySLqbys5MJHqLWUsz
	 jTvOshkeUo+nuHzcV2wr0pOqnQe+rbcM75/OZm+iIWoiQCMs7GpTga1+Mg2UnrVyDI01BoG42kOJ
	 o3vh3kNfUv1caWGzzdsz+JjsG5WbQt214hEjdrmKLd8it4fchpW8Y7xOZ8kPWAQLBpIgfUVzDdcJ
	 GVzPHzXQhQ+816CKDVDQ66iEU54Smgow2vrHXr4Wu01rRY8sR2Wn5blpt3tCYzBdgVNYlFlXW0hU
	 zOod79/ujWeER9lRhLvDm0E9Z5OKUUX4frdYQbntMqBwnNLvMvwliBD+ndKo/LP1bEr+Yaf7n2tH
	 fAFVHQyVk7VpUUr5Z9oeuowKzuKET8pcbzCm2gg+xdwHhhE3AoDwUZgKpP1TkfWuLqYWoxMNOCvp
	 M8emuVb692onb1zVaQeXPKHNO7Md4rystdXUOWvjX6r+I9BIl/hbjxuOht/sM/Ijin5yQ1j5LRhF
	 9IpsHVWNPBml5lJh9QjtBpdC7K32O1daNhvuLdrFjPw3Q85hG3HQoK7d7idgMUr+VhWqkrjg+m1b
	 p9IdlGn1UXRM6t++Yq/VMhVydm7n4jK/Cjn2ZDoxtkP8GBWAGAPc8VHQQaT48=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: TangYi <1914018426@qq.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org,
	johannes@sipsolutions.net,
	1914018426@qq.com
Subject: Re: [PATCH] wifi: cfg80211: allow IR on a channel the wiphy already operates on
Date: Mon, 12 Oct 2026 21:42:47 +0800
X-OQ-MSGID: <20261012132000.2-1914018426@qq.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261012125955.1519379-1-1914018426@qq.com>
References: <20261012125955.1519379-1-1914018426@qq.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, 2026-10-12 at 20:59 +0800, Johannes Berg wrote:
> This isn't how regulatory works, sorry.

Thanks for the correction - the "already radiating" argument was the
wrong frame, please disregard that reasoning.

Let me ask the constructive version, with the concrete observation that
led me here. On this iwlwifi device (Meteor Lake CNVi, firmware in LAR),
after the station associates on ch149:

 - iw reg get (phy section) shows the learned domain marking
   5735-5775 MHz as IR-CONCURRENT;

 - iw phy shows channel 5745 with plain "no IR" and no IR_CONCURRENT
   flag;

 - and the iwlwifi source contains no IR_CONCURRENT handling at all.

So the domain rules and the per-channel flags disagree, and the
reg_can_beacon relaxation cannot trigger (it requires the channel
flag). Should the driver be propagating the domain's IR_CONCURRENT rule
onto the channel flags once the firmware has a usable domain? Or is AP
operation on such channels simply not intended until a country is
learned?

Happy to take this to the iwlwifi side if that's where the fix belongs.

TangYi

