Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED7341E6C9
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 07:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792137128; cv=none; b=toZRfzXRzuq5QNcpu30uCeX4jcmMhzqIt+LDXln2OmRakcaAcnIZILoim1SFKjVUYcAX3/r8+YeAqUl/W0drLGl8wImApwbZDuO9+Jzq4QHZCcwitb51PX39M3f0r27Ln4O/0rZPOMMDh2KwsYgIOtWpOYh8tE+zYNatpS21Y3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792137128; c=relaxed/simple;
	bh=7L40ECaDW6Q4fyFrh8ZIirtf7DW9k3FlJoAwdPa+8Vw=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k9DOYTqDW0Kbj+9X7rEF2yKLxczXLnW4B2RgidQuLVwWJeFrxfgqp5fT2lQX+t7o+Ho7wvDTbateFhQS6fPlnz2XAc7sXCpg5egrh8ce8hpQWXATZq/MzBh0qbNYyJ387ZyLb82WVvLLLpASKpVe2gVM/ba1kXXDCdBtgFPC6ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Rn42gIyb; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Rn42gIyb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=7L40ECaDW6Q4fyFrh8ZIirtf7DW9k3FlJoAwdPa+8Vw=;
	t=1792137126; x=1793346726; b=Rn42gIybrljYiLru2adyIsrYcVm9hboCO9I8IJ31F307/y0
	9qA5nDVTYjNDDLmOuOqkME7xe7rH+3AWiCYluTM2woyxPzuJABNsU40/8Vrz+nkLIIlzcyXgg1n8H
	sVNh/kKnvpv1ljSPTlLVEZaT33O/Imk6I/PQcQQd0IBRie6whZNWUE/MJJPAVVGrNRqLw7UgnbrIr
	3XWgnWP5J208OcBBauENy8zvK4gz+WzedNIChThTE4PQeN2TXmTcZf1lF29E3OWEVoR3v1qctClq0
	lvkPpJbgmFQ+E40LPY9bWZdvDG8XoKyHxhF88VBO0k521+7ChhvBtR1AuTbzTvhg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xHcjN-00000005Vs7-0z4A;
	Fri, 16 Oct 2026 09:51:57 +0200
Message-ID: <d24e7f1412243b41750142009296901dd908fea1.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 1/3] iwlegacy: remove configurable
 watchdog timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: stf_xl@wp.pl, linux-wireless@vger.kernel.org
Date: Fri, 16 Oct 2026 09:51:56 +0200
In-Reply-To: <20261016074143.71057-2-stf_xl@wp.pl>
References: <20261016074143.71057-1-stf_xl@wp.pl>
	 <20261016074143.71057-2-stf_xl@wp.pl>
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

You missed the wifi: prefix :)

Given that it's too late for this cycle anyway, and the merge windows is
going to open on Sunday, maybe wait a while for other comments and then
please resend later, I'll probably have a ton of patches waiting once
the merge window is over...

johannes
