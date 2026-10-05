Received: from mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC45379CD
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 17:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791221784; cv=none; b=UJwWnE0b4CWp7A5NZFVemcwKHpyq5XwRGSV2harDa/7iwjKF9n21pNiclw7QFvWFh1ed1CX+2w0EdGkAHuo7vSXw5tk4+IETHMcgOmL/flkou1DwKeionFiDLiX9CS/LEXOtVdE/GwHJ22GZjHUb8EulQh4bsLKCjfDCbq7t5Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791221784; c=relaxed/simple;
	bh=yP8A1byxGUfAEH7vJdKOrAmVZp+pcAUAE2t16424ffo=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=ebhVeuZ1778PS/KH06skdUSCy8ur6U96yHZbGV6PlBL/yAik4jgBPT0QvZzZQqq/vLEPaFs3FQSRik2MZQKrf47IflWRnZgAVnjQRFuPDDv7KDQdyu8d6NXQAuo9IhD1SAMUpAgM8Hybq2amd4xBKdM/OVRXp8wSYzt0SkJWzC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ajTnuqIh; arc=none smtp.client-ip=95.215.58.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ajTnuqIh"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yP8A1byxGUfAEH7vJdKOrAmVZp+pcAUAE2t16424ffo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791221780; v=1; x=1791826580;
 b=ajTnuqIh1JH3gCRka/I5ZN9FP0NRlZIQNmKB+x5Od2b8C8ZuVvK+N7W71MXDEHZODENCFQJ0
 ddIih72mE81zv5XbwFLAATuZjJHBSFhw8hnX7twmpOpls7ScHB4c81fz1wUO4bgt+UGm/M5Jawo
 yazfE8lIBbblPBd3VEk1HRHI=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cd67e994554adfbf;
	Mon, 05 Oct 2026 17:36:20 +0000
X-Mizu-Trace-ID: cd67e994554adfbf
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 05 Oct 2026 17:36:20 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <64b006322730e0a078983458932dae35255e65dc@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v3 1/2] wifi: rtw88: download the beacon the
 reserved page was built with
To: "Mehmet Fide" <mehmet.fide@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 mehmet.fide@screeningeagle.com, luka.gejak@linux.dev
In-Reply-To: <20261005143523.130287-2-mehmet.fide@gmail.com>
References: <20261005143523.130287-1-mehmet.fide@gmail.com>
 <20261005143523.130287-2-mehmet.fide@gmail.com>

October 5, 2026 at 16:35, "Mehmet Fide" <mehmet.fide@gmail.com mailto:meh=
met.fide@gmail.com?to=3D%22Mehmet%20Fide%22%20%3Cmehmet.fide%40gmail.com%=
3E > wrote:


>=20
>=20From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>=20
>=20rtw_fw_download_rsvd_page() downloads the beacon twice: once as part =
of
> the reserved page and once more on its own, so that the firmware ends u=
p
> with a TX descriptor that describes the beacon rather than the whole
> page. The second download fetched a new beacon from mac80211 instead of
> downloading the one the page already holds.
>=20
>=20Besides the extra work, every beacon fetch advances the DTIM count an=
d,
> while a channel switch is announced, the CSA countdown; doing it twice
> per update lets a countdown that starts at 2 reach 0, which mac80211
> warns about. Hand the beacon skb out of the page build and download
> that. The hw scan, which downloads the beacon without a page build,
> keeps fetching its own.
>=20
>=20Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> ---

Patch 1 looks good to me.

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
