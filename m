Received: from mail-lr2-f33.google.com (mail-lr2-f33.google.com [74.125.230.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E4F47F2EA
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 10:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790935608; cv=pass; b=QjpjfsI02c4aiKPENZMJ7tPzbmtghwr+uXBbBK8/eCoiohpiP2ZFMsx1XY/oQrUNgwsTLPJlzgIqBYSkKgJUkZKzPZkIrFb1vkoIrY32yhtucUZCe77nJXxE5z2krWivKIMVStV+nUmQ/68P45gvoADu+engyLIj3vNN3bdVcUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790935608; c=relaxed/simple;
	bh=hEO0vwKwrqlXZ4TAvYBOxFpw+P9Ek/EqQqPC11dV1ZA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f7NoXyDmfv8ToD4xT0juWd6om1T7sH55KyvUOITnnXtIRo94qyT4jjQT/06bZpgzImivD1+H6q0zN2PKYVDStkyJTK7ng44PwwhkBEHa7agfJAz6r3q059tGR1DaypyNQZvlcobTWDSrgTtJkjZztzjDfrsoKbC+QdpPau9xoSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kV/PN54K; arc=pass smtp.client-ip=74.125.230.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kV/PN54K"
Received: by mail-lr2-f33.google.com with SMTP id 38308e7fff4ca-3a87a4aa6f2so11989841fa.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 03:06:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790935605; cv=none;
        d=google.com; s=arc-20260327;
        b=lv6Sj+G62Ds4kQpucj9hTM07aEKc3WhquFlhQ+9hXrYCb4jO3aXzKPZfO/zvQwy3E+
         HKXsjSwWYF6SD2h0mNtOpv3BUY/DnIcq9Y6ur/6GslRtXZikJXuxbxBXxQUaoKduUOnl
         9Z4/X3dHRQIcnfmCRM/lVe1ttBzS6hFgcc5NDR9plbOkv0T1bGkyp/ulWIlKn8y7gPWz
         vaLhJjBAztdDS2k4EZIMClBpr9T80eIxYqnnhIIwOM+klGhiAmuKNa4SS++bW5LtcVZe
         eGlrc8qVgl3ridAFSxgGBcDZgXL7iLQ1RCmsay8KRRU253G0EOW6WHM84USzU2LMLjuw
         u7fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=56xOfDITZcNEcJrgSxRUY3B7nxPxHMei30QaJ72H4oQ=;
        fh=Pwpj6XZhJG+6mWjebizXcpToAWntP7pg7P3VrcTmUfI=;
        b=Ofg/YabY1gM9I8evwRx19Uzf262XYLqqdrF1ut4WM2NRSYej+nVMsdbDht8DNEdc1H
         JRXVxvmYgFdFQg+wYAO6I7u2ZSlniuosAM7WBzR/+TSTdATuz9uBl87qGM3TI/hFKJ6M
         Yfqdxa6h4EPrTK6Skdrr0vsh9MNBudUBjT1aBF3LLiEWcaKn2RlxbItvTa7B2HfOCfbq
         R/8JuaZPrI0VyuRbZjTZ4mjCPigU0MgY8lVeCP7433Xva90JAwBlRzvS7sUnAuvxS9Ja
         /GfNMdGUxpJNqppPY6BVaHQrv4m3VjP0NUqNNfFh6ha8SCQtqHG3+3w/u+4WU7lUC50X
         ErWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790935605; x=1791540405; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=56xOfDITZcNEcJrgSxRUY3B7nxPxHMei30QaJ72H4oQ=;
        b=kV/PN54Kt/CFgtZWInPcN0fNRdr+/B5yZCGiB43z6g9Dpi+TG6/aCQCtph85JBw2d0
         BUoehj10Rpq6MXZ23tvdT6SucBtASmv7dx1IptvNnvXaVx6MZuaUVYul7L3xjKbuiSEv
         WSJFu30GVBculKOIHI1lSX8BUd+H34ET0bjxiaV1vl7hMv5ZbrDIL3yWl8iW3nINyeRW
         QLOP1ZRudK6pnft41ccPtQi7aAJQUUmP7Uwbvmlz+sP9gVEmOr3ANNdrC+ikZvwcMnWL
         +SMDj5BNxLo8cH/Ca1oMCXAxorlE91Epnl+Mkz3BUpd67npHl2kCrQH7N0bbNeiQ5wZT
         zwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790935605; x=1791540405;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=56xOfDITZcNEcJrgSxRUY3B7nxPxHMei30QaJ72H4oQ=;
        b=zCKaDWX5LUyFc9hAzJhfyBQuX9Cc/DW/ZPf7iC7pxVJtwSsiW0BJyNK++Whh49afO/
         ayLSX4olBENBzaQZxOqjy48aSUFlTWWIvMXEaKy4MkGG8V9Xg13qyTN8CSMziZuLdfmL
         eV/tF0WsxmJHtBBpzjY9G90sLlHT0PO+/eEL8f/zSKP+7TR5I6xApGR1egvjtM9NjkER
         M+rA4qf6s7TEgIS43eAA5fT/TQRPloGUmaoEoLjzObb7g9g858xf0WRJn1E1H/A1VS6W
         q1hByQZ7JrHslZTX96oEjNl933KmW28UJsItCI6PXcSiboAULbYX2RyOkTsA/tgLRi7V
         TI1A==
X-Forwarded-Encrypted: i=1; AKwUvBxa0uVF7AY7qU6tnTkVCYxThW0uG16yE2/5V+wmU7CKnzbCJIlqKH6DRRJectlSUn85p1ixEfzRQuz6IMT1Ug==@vger.kernel.org
X-Gm-Message-State: AFq9FYIwT0n3SSYyTHUwwkRhaS8k+jX9uJt8d2d41BxtCEEhN5l41Ola
	4UZsz/nrAGPMPwuGxuVKA73YBwpcXhMrZIH/PN/VtiSJIEBt538c95wYeXOtY38wuiGfFmuYzoQ
	gOAl2z8RHvoUiToXJZwOOB7X22W5/dO0=
X-Gm-Gg: AYBFou3tDGRtOorFiT8j3XpMP9F0gh+jgp6Gxqb+ZWcqq56XfbFKp/YVeAsIqAhrHM8
	iGRiFRgtCYcwFzBVglEgY7b49bssoErOcAYh0KeX6rSmA4Lz71LI1iv6I8t+D0RQgLjgUTSinxR
	UA6MyhmzYpE9pF8mF4fbdpoauWp/RN0ZWtxSM8VkzSYkqo6/5pZLr5LKjIU4/or0pqANLMuUGXu
	GtT/1WYqiR0tsGU6m+lRHnnHVF4AlrijPYirR3TGGPRSRhQX2IpD1/6NImEOiHgS5N6Ksb5nWnz
	NmV/I2vvfK3yZUi9Sar2foWzT9NwczZR/M2gmb/oK4LMpzjRMHf4ZbDNArg/dpbUAxHC4am6ztK
	MKbuTpDRoQsQaXUhgyfIKRQ==
X-Received: by 2002:a05:651c:31ce:b0:3a6:4e4d:9d1d with SMTP id
 38308e7fff4ca-3a87ec366b4mr5542271fa.0.1790935604459; Fri, 02 Oct 2026
 03:06:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930112842.21323-3-sigefriedhyy@gmail.com> <179089747937.434549.16341143363097629528@kernel.org>
In-Reply-To: <179089747937.434549.16341143363097629528@kernel.org>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Fri, 2 Oct 2026 19:06:34 +0900
X-Gm-Features: AclHuK8Nz_2jnmVTxCDn7TReanMq4quK1jlp8YMQzgl3WrXJWrYulmhcHHN9ymU
Message-ID: <CA+7S2vKBrjAMW5h_Dkpuy+TYum7m2=8GL1etaDx369ZSMRhHRA@mail.gmail.com>
Subject: Re: [PATCH net-next v9 2/6] net: change netdev_hw_addr_list count
 through helpers
To: netdev-bot+sashiko@kernel.org
Cc: ajay.kathat@microchip.com, aleksandr.loktionov@intel.com, 
	andrew+netdev@lunn.ch, claudiu.beznea@tuxon.dev, davem@davemloft.net, 
	dsahern@kernel.org, donald.hunter@gmail.com, edumazet@google.com, 
	idosch@nvidia.com, jacob.e.keller@intel.com, kuba@kernel.org, 
	johannes@sipsolutions.net, kees@kernel.org, kory.maincent@bootlin.com, 
	kuniyu@google.com, nicolas.dichtel@6wind.com, nickgarlis@gmail.com, 
	pabeni@redhat.com, sd@queasysnail.net, shuah@kernel.org, horms@kernel.org, 
	sdf.kernel@gmail.com, vadim.fedorenko@linux.dev, willemb@google.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> - [Low] In the commit "net: change netdev_hw_addr_list count through
>   helpers", a new comment on struct netdev_hw_addr_list::_count in=E2=80=
=A6

Agreed, but they are nit, will fold them into v10 if another version is nee=
ded.
