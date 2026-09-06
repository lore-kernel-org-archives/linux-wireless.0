Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A8E3B6C14;
	Sun,  6 Sep 2026 11:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788695384; cv=none; b=TxTTC1MXjEf6rVW+HdrnC9nTVX/eEh24lwX/KkNeaorSmBFghIFjl3iPg8kvrF4lF9h8eWc4S7KIiP+8qlSDFbDDFa0xrq4xuIuM19tb5BpgIfTo7DtNCwQbIn7jtHWJtQVMukMGI2V+ZOEvmGCo0NQMGWMj+y4IBEKK4YGWsEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788695384; c=relaxed/simple;
	bh=pmOpvwKv/Su6P41qSkFiN79XyyZDPQstpg1hqKz4EaI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Nc/tOh++V+fxFiRyPyYQZW7wsqomh6ecNh8eYmITc0bQkRJRb28t4Gh8uGubq548b+PSuSLwlMZbnif81vUaT99KYVDcia412dO1JBQ/gp5/ZbMWOvlkn7HcVaMfvGP5KC+CHmVvpsi/7KqKr3ws9YJgw0i9MHePAjE9XvweN0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=T6MACGCe; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="T6MACGCe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=XNdzB6j6US5wUuat8S8FJTGFFmsSf5Nta1dIyeRTbKU=;
	t=1788695380; x=1789904980; b=T6MACGCe5mPfqny4jmy8m1R/GSffKtSXaBvivBRNlcHu/jD
	JVsPd+lOGrCvdVvlkaH+UUyCtwVm+n85h4iVHp/zIhjrIswhlWKWfcY3CQuFUiTaY0Vk2wzf9MVSh
	GLFT+X94mzX7MtH9te4S89VeWoh8onml0lH+d4LIh5qZ8RFojeATSUeVR3K0FZY9RRIwH7MuZ9Kel
	J5ao9wMRHK0zw4k5wT7lJuL6YOKry/CnZXJhxUsnp9YWtdRKPDyQLerQhTRCQupDJwWvQBvHJysEl
	zlmEGK9XhV/XHq6zLJuOJhKLtRE/f+veHM9QlSAatNq8FrPYO9CFxezVWxiA3V4Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3BNI-00000003Fmb-0qd9;
	Sun, 06 Sep 2026 13:49:28 +0200
Message-ID: <087d18429b448d5b63f922fd6779925f827134c7.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: p54: fix incorrect frame length check in
 p54_find_ie()
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@gmail.com>, Wang Yan <wangyan01@kylinos.cn>
Cc: zilin@seu.edu.cn, linville@tuxdriver.com,
 linux-wireless@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Sun, 06 Sep 2026 13:49:27 +0200
In-Reply-To: <bdca394f-0371-45ad-bfee-b044444ad724@gmail.com>
References: <20260903081200.267514-1-wangyan01@kylinos.cn>
	 <bdca394f-0371-45ad-bfee-b044444ad724@gmail.com>
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

On Sun, 2026-09-06 at 13:06 +0200, Christian Lamparter wrote:
>=20
> >        pos =3D (u8 *)mgmt->u.beacon.variable;
> >        end =3D skb->data + skb->len;
> >        while (pos < end) {
> >                if (pos + 2 + pos[1] > end)
> >                        return NULL;
> >=20
> >                if (pos[0] =3D=3D ie)
> >                        return pos;
> >=20
> >                pos +=3D 2 + pos[1];
> >        }
> >        return NULL;
>=20
> The check in the while loop and the checks within the while loop make sur=
e that
> no "pos" is returned unless the IE is still within skb->len.
>=20
> But true, it should have been *mgmt and not mgmt.

FWIW, I dropped it because it really shouldn't have been there this way
since 'mgmt' can be far bigger than needed since it contains the union
for all kinds of action frames etc.

I'm not even sure it's needed regardless of the next check since the
beacon is built by mac80211.

Just blindly patching one mistake for another doesn't help anyone.

johannes
