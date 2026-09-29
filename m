Received: from mta1.migadu.com (out-234.mta1.migadu.com [95.215.58.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7071D3F1070
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 10:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676831; cv=none; b=aL8yL2nUq9oQ5u/5hGUXTEq8NKv7DufwNQVWtJSR9hH6MWEs0QVZm61Ma3e/lnHwgLCIt92xGPZfE05urBuCgKm8r63VDGLljlZBHjHcp7ET4ydzgv9Ix8uP/cvPBaJVmuGyPyyv6afNAdpw6VPYnpO31XQwgbSS3qpG/q2/jK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676831; c=relaxed/simple;
	bh=FVlzfY3mMI+cjE7IoFuxnOjWAGKF39Gc3wStknwBDcU=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=XV5xYzOREZj8mfsy/wPPH/qq9L5HZpiUIFrEZx6WR7Il92z/Yd2R9iOm9enW0jghwZ8hA3lHLS3qcuXVM46Iuhe6rc3GQ1h8rbWjrzhjkMj1w2MkV4PKZQdeFY031KNr+Za38vq2QoJPYKLuor0sv4wdsoYyHA9QFVOco8x0ndA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=prRS00vI; arc=none smtp.client-ip=95.215.58.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="prRS00vI"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FVlzfY3mMI+cjE7IoFuxnOjWAGKF39Gc3wStknwBDcU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790676823; v=1; x=1791281623;
 b=prRS00vITx6NwuWr8tP1pu1EpRYXxXOcxUPRSeMaEZGT+9yu49V+wChBK7uvJty0qqVab0IU
 NHts4U9n0ufuSivpPK/WSlp2gGLhmf8H/wN4529f49oBwwwgbnmPhJt8Vxmnt7AmPQf1RajX2LU
 EO9skOlFWf1C8qok2owPpiCA=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 08322818c73fa8ab;
	Tue, 29 Sep 2026 10:13:43 +0000
X-Mizu-Trace-ID: 08322818c73fa8ab
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 29 Sep 2026 10:13:43 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <70785221599240049a8747750b6cf0369f8368d5@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v4 3/6] wifi: rtw88: 8723b: add the RTL8723B chip driver
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, luka.gejak@linux.dev
In-Reply-To: <a978a803-a641-4af4-b38b-f3c9b423ef63@gmail.com>
References: <20260923213557.186205-1-luka.gejak@linux.dev>
 <20260923213557.186205-4-luka.gejak@linux.dev>
 <6ad11268-9f09-4618-8b44-ab0744cf0a52@gmail.com>
 <a978a803-a641-4af4-b38b-f3c9b423ef63@gmail.com>

September 27, 2026 at 19:29, "Bitterblue Smith" <rtl8821cerfe2@gmail.com =
mailto:rtl8821cerfe2@gmail.com?to=3D%22Bitterblue%20Smith%22%20%3Crtl8821=
cerfe2%40gmail.com%3E > wrote:


>=20
>=20On 27/09/2026 18:21, Bitterblue Smith wrote:
>=20
>>=20
>> On 24/09/2026 00:35, Luka Gejak wrote:
>>=20

>>>=20+	if (rtw_hci_type(rtwdev) =3D=3D RTW_HCI_TYPE_SDIO) {
>>> +		rtw_write16_set(rtwdev, REG_PWR_DATA,
>>> +				BIT_EEPRPAD_RFE_CTRL_EN);
>>> +
>>> +		/*
>>> +		 * rtw_mac_power_on() sets PAD mux bits this chip must not have;
>>> +		 * restore the SDIO PAD mux before RF and coex setup.
>>> +		 */

> By the way, rtw_mac_power_on() doesn't touch REG_PAD_CTRL1
> for this chip.

It does, through rtw_mac_pre_system_cfg(), which rtw_mac_power_on() calls
at mac.c:382. At mac.c:111 that function reads REG_PAD_CTRL1, ORs in
BIT_PAPE_WLBT_SEL and BIT_LNAON_WLBT_SEL and writes it back, for every
HCI type including SDIO. So the bits are set during power on and the SDIO
PAD mux has to have them cleared, which is what rtw8723b_sdio_restore_pad=
_ctrl()
does. The comment in rtw8723b_post_enable_flow() names that function and =
the
two bits now.

Best regards,
Luka Gejak
