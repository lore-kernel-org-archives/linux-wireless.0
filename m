Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C0E15AD9B;
	Thu, 18 Apr 2024 09:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.132.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713431743; cv=none; b=JjuwajRt53pYRcPb62k8WU53DTCF3TWt9bs+SxjFOYOUFIVZM3MTdNUPXXWOo21x2itMVtkP4f/ur9SIk7RTBpXNReuFYQ5DGlDCFQerDXyeoAT0/OS/jWFPpOrXz1FL9cO0SrDwjOVpBim0QxeGxfj+B3G/w6GcvL5Ig/iki5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713431743; c=relaxed/simple;
	bh=JhmqGQkwfCS0Jtz0k+KhL7hJn/gDf4VLQPvd9F9d4WU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=R9m2vP25A4qaRHB6ES/I7NX0ZAea2fKBvCgqszJDsDOxTVQznNtzJWBpu+1Z6aM8FtDipYMh3aLJH68/e7r3PHZhKDqatxxOF4aj/cipY3xD8/2ypbielzAA7JpDYxCUhEKZ2vbNQcQ2cXibxq+BWkAqsul5lf5+uBEb0B9eDIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org; spf=pass smtp.mailfrom=holtmann.org; arc=none smtp.client-ip=212.227.132.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=holtmann.org
Received: from smtpclient.apple (p4fefc49c.dip0.t-ipconnect.de [79.239.196.156])
	by mail.holtmann.org (Postfix) with ESMTPSA id 89424CECC5;
	Thu, 18 Apr 2024 11:15:39 +0200 (CEST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [EXT] [PATCH v10 0/2] wifi: mwifiex: add code to support host
 mlme
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <PA4PR04MB963815B9FDA6119683A28CADD10E2@PA4PR04MB9638.eurprd04.prod.outlook.com>
Date: Thu, 18 Apr 2024 11:15:28 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 "briannorris@chromium.org" <briannorris@chromium.org>,
 Kalle Valo <kvalo@kernel.org>,
 "francesco@dolcini.it" <francesco@dolcini.it>,
 Pete Hsieh <tsung-hsien.hsieh@nxp.com>,
 "rafael.beims" <rafael.beims@toradex.com>,
 Francesco Dolcini <francesco.dolcini@toradex.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6CB59E09-F34E-4986-AA88-8EC4EE5E71DF@holtmann.org>
References: <20240418060626.431202-1-yu-hao.lin@nxp.com>
 <0ED16BAB-6E7D-487C-BBCA-E63FEF37C60D@holtmann.org>
 <PA4PR04MB963815B9FDA6119683A28CADD10E2@PA4PR04MB9638.eurprd04.prod.outlook.com>
To: David Lin <yu-hao.lin@nxp.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)

Hi David,

>>> With host mlme:
>>> Tested-by: <rafael.beims@toradex.com> #Verdin AM62 IW416 SD Without
>>> host mlme:
>>> Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com> #
>>> 88W8997-SD
>>>=20
>>> This series add host based MLME support to the mwifiex driver, this
>>> enables WPA3 support in both client and AP mode.
>>> To enable WPA3, a firmware with corresponding V2 Key API support is
>>> required.
>>> The feature is currently only enabled on NXP IW416 (SD8978), and it
>>> was internally validated by NXP QA team. Other NXP Wi-Fi chips
>>> supported in current mwifiex are not affected by this change.
>>=20
>> I am a bit confused here. If this is just for WPA3 support, then =
wasn=E2=80=99t this
>> suppose to be solved with external_auth support?
>>=20
>> Regards
>>=20
>> Marcel
>=20
> FW can't support WPA3. In order to support WPA3, driver should =
leverage MLME of wpa_supplicant and hostapd.
> This patch is used to let MLME is running by wpa_supplicant and =
hostapd instead of handling by FW.

as I said, isn=E2=80=99t external_auth exactly meant for this?

Regards

Marcel

