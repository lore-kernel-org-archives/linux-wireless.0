Received: from mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7389E44F557
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 20:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790800587; cv=none; b=KVW3JhwLF1tTjJidirpwbEYBWrFc6b0ktmPU3ACzTMsr8u3ndGu/0QtNQbdmN4hKTmfB1QiyBMcZOX+uObC1hwj6Y84YKNpptvwIBO0eFJnL2dIW6jPHr/h+IhjIUiJwISs8wJlefC+4FA2KTB7h3boeq/umP07oYKZ0U5fVwpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790800587; c=relaxed/simple;
	bh=8GEzaaNJ8Gtor/d0CB8nLk0zfpE1j0uU/SLKeWOBpk8=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=dItaBbRmA3AtsuyujoK94JltzIYeL2o0qK2ixhDA/TY2S7Xd4kxGHu/ag1EI3SAbf86XM7rA5myuvtnvAql1PWhql84yn5ASOrlxe9x3Q68o2Gb/GmHmk78RBk/MPoRvT/n6uTYrcT0OXLrweswIfZtz88cimbIIZ9syeGBUnHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RjJiS9/D; arc=none smtp.client-ip=95.215.58.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RjJiS9/D"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8GEzaaNJ8Gtor/d0CB8nLk0zfpE1j0uU/SLKeWOBpk8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790800583; v=1; x=1791405383;
 b=RjJiS9/DfB5ktkO0KX+1JSnkmudtWptTYHfR6MX9IFTVXt3gCaA1KEhzbUtLfvj0Cg+Jn39+
 YAMtLXlf3WxVMT0kIvwNuDqs1UUvDxtgLUTVacAUKPRIZ8RDjZNoxlvPpvTb9uEY5qJ/TX8+NTK
 DrgGdOvNvdvVmkxLU6Gx5Qxo=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id eb9d3e35343149f6;
	Wed, 30 Sep 2026 20:36:23 +0000
X-Mizu-Trace-ID: eb9d3e35343149f6
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 30 Sep 2026 20:36:22 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <3c53130d1d4738a9b3173806264fc1d0b5682072@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v5 rtw-next 2/7] wifi: rtw88: assign the RCR per chip in
 rtw_core_init
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, luka.gejak@linux.dev
In-Reply-To: <d398a8dd-a182-4e69-8f5e-12a820594093@gmail.com>
References: <20260930091604.52891-1-luka.gejak@linux.dev>
 <20260930091604.52891-3-luka.gejak@linux.dev>
 <d398a8dd-a182-4e69-8f5e-12a820594093@gmail.com>

September 30, 2026 at 20:03, "Bitterblue Smith" <rtl8821cerfe2@gmail.com =
mailto:rtl8821cerfe2@gmail.com?to=3D%22Bitterblue%20Smith%22%20%3Crtl8821=
cerfe2%40gmail.com%3E > wrote:


>=20
>=20On 30/09/2026 12:15, Luka Gejak wrote:
>=20
>=20>=20
>=20> The receive control word is the same for every chip today. The gene=
ric
> >  default is written in rtw_core_init(), so a chip that needs a differ=
ent
> >  value has to overwrite it afterwards, in its own init path, far away
> >  from where the default is decided.
> >=20
>=20I still don't understand why RTL8723B(S) would need a different value=
.
>=20

Because=200x700060ce is what the vendor driver leaves in REG_RCR for this
chip, and it is what rtw8723x_mac_init() already writes for it. I have
both from tracing this card: a register dump at the end of
rtl8723bs_hal_init prints RCR=3D0x700060ce, and the same dump in rtw88
matched it field for field.

The default is a different filter. It sets BIT_PKTCTL_DLEN, which the
8723B vendor HAL and rtlwifi's rtl8723be never set, and it clears
BIT_AMF, BIT_CBSSID_DATA and BIT_CBSSID_BCN, which the vendor value
sets. Four bits in total.

That value does not survive rtw_core_start(), which writes REG_RCR from
hal.rcr after power_on. The field is what keeps it. BIT_APP_FCS is the on=
ly
bit added on top, because rtw88 advertises RX_INCLUDES_FCS.

Best regards,
Luka Gejak
