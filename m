Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE504582C8
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 08:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789980841; cv=none; b=n/KEuSHU5Sqaq8SmhOq1F/jninj40Lj+raI6dxq09SF5UoNdykRXBhUdNGD3QHxAnqLmkszpd8mV2iVVaJlRdZXmbVLMsDXk1H8+iVWLQaV7dvHKm3aewnWdCRfG3IT9ix+vt1/JXBQzOSgrMDMDZ6eR1pzRNGy5FxQELA4jnrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789980841; c=relaxed/simple;
	bh=5Cm8lO62ypSVfy7Yt8KT8jDr9wdenB+Kgd6g1CnvYzo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZLZw8+WOp4+8hfoNMS7YRBmA0q5N7N1P9TuDg0nUQ6/QXsUbXlcRosz/E0SVzm/jtOGsoIgyT1+pm4q/0B6Ie5SnxkYi1M1xnzftxv3m93e767vJeEsvLk3sijLcdGw0Ir8fbe+k/9AtPczz92ebXJ2Wxlx9GobNpqR/P24QNfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=uy2kCuWj; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="uy2kCuWj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=LfVsLM1FJR1Yyx5RdZ+fr9gR1crniF1SoB/V7VD4OBk=;
	t=1789980838; x=1791190438; b=uy2kCuWjFoJa5a+BtFCi+ccgOvUKqL6j3zwsUn8t+JTwLix
	DIFSdUemlvab/1De24fnwWT3wElsQ0K2OgCM6Wrx9k/XDBFWNCAHXaa+bMXeyjWVmXwyBYf5RhuQA
	cHotZxZvUhduwg3QzbXx/hptwTaeevGBD5ls/ftNHrNJtQOeds0AV7eufZVhtl2+7c6jaxmRyj+Kg
	TsUJSoVJ+5XrD4IPMM9R67gjVKje+vV88DvzzN2/ksv8b9pYK29/wYKcTh8ywMFkl8uwqfnJChlDM
	QhdSeD27V/Cmp9OpDiQQa7iavr+sYc7TZhnu/MKGjkaWWifXpk+umEEKD0enPENg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8ZmX-00000005hF6-0peo;
	Mon, 21 Sep 2026 10:53:49 +0200
Message-ID: <b6da845800e730982ff8bce33070ad0af4025248.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: mwifiex: append hotfix number to firmware version
 string
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Chen <chunfan.chen@gmail.com>, linux-wireless@vger.kernel.org
Cc: lukas@wunner.de, briannorris@chromium.org, francesco@dolcini.it, Jeff
 Chen	 <jeff.chen_1@nxp.com>
Date: Mon, 21 Sep 2026 10:53:48 +0200
In-Reply-To: <20260917032350.2323119-1-chunfan.chen@gmail.com>
References: <20260917032350.2323119-1-chunfan.chen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-09-17 at 11:23 +0800, Jeff Chen wrote:
> +++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> @@ -1594,11 +1594,17 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_privat=
e *priv,
>  						    api_rev->major_ver,
>  						    api_rev->minor_ver);
>  					break;
> -				case FW_HOTFIX_VER_ID:
> +				case FW_HOTFIX_VER_ID: {
> +					struct hw_spec_fw_hotfix_ver *hf;
> +
> +					hf =3D (void *)tlv;
> +					adapter->fw_hotfix_ver =3D
> +						le16_to_cpu(hf->hotfix_ver);


Add a length check before the LLMs complain ...

johannes
