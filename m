Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B687A3546E9;
	Wed,  9 Sep 2026 05:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933198; cv=none; b=WpT3vkBkBhqGQHmGio5t3FNTylrnbRPVeLkU/O8x71ZHXmv6dPw8L7I7LUpxKvSlp51mjlbpMLXJdrBvweU/G/Gp+P7qrzhKmq4tnEwR/odu2ZDxNn97pmD620IU1SclvRUJAIL0CgbdzFeGK/DMklpEKY/bVGU5TQsXhnhwZXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933198; c=relaxed/simple;
	bh=/Mhe+TGwpITJ5l85bZCjeSMXVvHI6Gxgg3Z+in9G8gQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n2lTeV+DaJWnLiZRgVnyUchQaE4xo9yW6NGq0xIj6+ubX9S6FacG2zSQPddk/axwZusj1Y/7hYzZQJ5z+mwlS0pyP1oOxmpqSl3HqnjQPi17xMGK8I0xFaiCQ+ArOjtuOVFeoBXqD8iEGw6d0XL5fJ5uCT2jy4xivy/zUNRgxCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=pTQTZV0r; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="pTQTZV0r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/Mhe+TGwpITJ5l85bZCjeSMXVvHI6Gxgg3Z+in9G8gQ=;
	t=1788933196; x=1790142796; b=pTQTZV0rbo7EvBjTgPY0sVuLjB/mcsc1yvaPlgebPIYLl5V
	88Q0CXFT4ySMSo+aZ0ta6FfvrP6M08vv7i8n+wJ5WAZIzgHiiy6wM0Z+tt35Wwgu/uIM3TNhHy7mz
	K7oAu8IhKGJtUCMhLe3NlPiv20DesTpaNc/GfR1ps1G5K6H/KLh32lI2jLtecEYitikk+wZtvyUJf
	8lhP01nK1sqj4PZSo2CG8a2/cD7Z+hmjD2wFH7qytiwE8sGQrFPtyXBLhOtPStfC5kV99ccVA95XI
	tJeP4V9pNxofWcBZTlmdo5V6JREyH+aSMUN8tHrQWuw8z4hC4e1ujxzwUFwg9tNQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x4BF8-00000007djD-0drd;
	Wed, 09 Sep 2026 07:53:10 +0200
Message-ID: <e9b36721c9e2b0b24c89c2e1b5b03b17c438f30c.camel@sipsolutions.net>
Subject: Re: [PATCH RESEND wireless-next 00/18] wifi: Add Seamless Mobility
 Domain (SMD) AP support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Jakub Kicinski
	 <kuba@kernel.org>
Cc: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>, "David S . Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
	 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org
Date: Wed, 09 Sep 2026 07:53:09 +0200
In-Reply-To: <e7089219-ed02-4288-a678-660a52289e61@oss.qualcomm.com>
References: <20260908-smd-v1-0-9fd2d876a1fb@oss.qualcomm.com>
	 <20260908125017.0fb226c5@kernel.org>
	 <404004c4c97bf776077685b7ec33a14fa777cd70.camel@sipsolutions.net>
	 <80266eb9666d6106110d998cb6330868da55bf59.camel@sipsolutions.net>
	 <20260908132004.29176fec@kernel.org>
	 <0e950f7f0c3f5a2c1f6476e255716b09876624f4.camel@sipsolutions.net>
	 <e7089219-ed02-4288-a678-660a52289e61@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Tue, 2026-09-08 at 17:20 -0700, Jeff Johnson wrote:
>=20
> Apologies for the AI-like commit messages. Those are at my prompting sinc=
e I
> want these patches to be understandable by folks who may not know or
> understand the underlying details of SMD roaming so I requested they cont=
ain
> enough detail that referencing the spec should not be necessary.
>=20
> AFAIK none of this code is AI generated.

Did you read it? The comments (in patch 1 we were talking about) are
also all clearly generated.

johannes
