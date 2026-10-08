Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4432C235E
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 01:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.193.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791421378; cv=none; b=ptf2dbbKpXO+6tmjXYDM2se5uRNb/LJ1+E175gGgGYwCGH0z8q84JfQA1/VCUYGQRl36i8iCyqF0D4CqJOBIuC8D9uIcZkNtHYunu/0vIKqWa4x+gNHjUwOqVMlGipyUzpngwo6kzKV4hzoV0iqiOmwx7UrjMtYNXg9KFQzV4ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791421378; c=relaxed/simple;
	bh=uYJqgRQMNqjO9fDlybvOX/wW4tELzzggjrclOgU1PCg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:From:To:
	 References:In-Reply-To; b=P1cba7NICUuIBxyhevmX5Ue/tbdmqz3KQn0WMdrBq8OK57ohvDOKPreQnwv3HJ5IFq47V/r6CgYCVVMv/+PnZ1sK1aTE4V4B68/BMH3IXb05yJL6xUD/W07ftvmGMMZTOWqnYesCr8qRO0fJFOVyg/bHHpxmPNqSTglrsxAVdTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rcpassos.me; spf=pass smtp.mailfrom=rcpassos.me; dkim=pass (2048-bit key) header.d=rcpassos.me header.i=@rcpassos.me header.b=lZDqTYzU; dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b=Guva4A3n; arc=none smtp.client-ip=34.202.193.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rcpassos.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rcpassos.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rcpassos.me header.i=@rcpassos.me header.b="lZDqTYzU";
	dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b="Guva4A3n"
DKIM-Signature: a=rsa-sha256; b=lZDqTYzUDXcZM+5CvFD/0vDiVLjvVCiyj++h7LxnWRLCrSLY+ci8O0SXPFhqhJZH2pubKL+fT0JL40lcPRYuiw9b5P3q417NPHf6WSXL1geqwoYnC7SwFICOzJcS/KM/I/VVUdziHd0UuWpXwoA3fG+KELyTQ9m71D2lNk2pLbkEiuyeGLfssBrHrDnthaEUjcj0e1fDzxf2UYr/S+m4p4aE/33Fs3HNt4IKy9AJqocGo9FrDTqpuU2PvnfN7KjMtkArVdAML99t8Mfr09EGcG1NcWYSik2nJ0DllM3My4H9yJ2vQg9OS1K4ndyj2o24+N63RQlglUBm2OtJ4NUrfA==; s=purelymail2; d=rcpassos.me; v=1; bh=uYJqgRQMNqjO9fDlybvOX/wW4tELzzggjrclOgU1PCg=; h=Received:Date:Subject:From:To;
DKIM-Signature: a=rsa-sha256; b=Guva4A3nrgkppc37/i9m+24/WqBV7hTEnm+W8dk7qCGw7dGYFZYcz57LBjqN2l7cZWNlp7XNwTHAQvGj+tKtFYlX9WzlzYd5uwOdYmiFxf66s6KCjOX5twmK1A2SYIvBA6jrtlUpM6KP5hjw2V/nqZQf+nBz0iNi+fMYTCHDpVUH6Afg1VvGTnWIRBcenROox9iU44O0I5+EDXLCHVGeSWUxaQ7Xo2qUlJYOJ8i5pG5LjOItz4f3QUOHCLdsNpOx1ZUdb/PP5ZBkGVfAwMLyi4Xoy09eSkTaOK03bwzBmP9hgxILnDHTX3LNN+JM5hzQuXiu0GbNJd+3sQdFmztcjw==; s=purelymail2; d=purelymail.com; v=1; bh=uYJqgRQMNqjO9fDlybvOX/wW4tELzzggjrclOgU1PCg=; h=Feedback-ID:Received:Date:Subject:From:To;
Feedback-ID: 45355:7809:null:purelymail
X-Pm-Original-To: linux-wireless@vger.kernel.org
Authentication-Results: purelymail.com; auth=pass
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id 1860935098;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Thu, 08 Oct 2026 01:02:40 +0000 (UTC)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 Oct 2026 22:02:59 -0300
Message-Id: <DLZ1VOR6LJVU.Y08CXZ0T39KM@rcpassos.me>
Subject: Re: [PATCH wireless v3 0/4] wifi: iwlwifi: recover the BE200 after
 D3cold removes its power
Cc: <johannes@sipsolutions.net>, <helgaas@kernel.org>,
 <ilpo.jarvinen@linux.intel.com>, <emmanuel.grumbach@intel.com>,
 <nika@nikableh.moe>, <mpearson-lenovo@squebb.ca>,
 <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "Rafael Passos" <rafael@rcpassos.me>
To: "Navon John Lukose" <navonjohnlukose@gmail.com>,
 <miriam.rachel.korenblit@intel.com>, <linux-wireless@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <cover.1789333511.git.navonjohnlukose@gmail.com>
In-Reply-To: <cover.1789333511.git.navonjohnlukose@gmail.com>

Hi, I've been testing this patchset for almost two days, with good results.
I applied it on top of mainline (7.3-rc6).

I was having issues with my new company laptop for a few weeks.
A Dell Pro 14 Plus PB14250, with BE200 Series Wi-Fi 7 (00:14.3)

Tested-by: Rafael Passos <rafael@rcpassos.me>


More details below:

Before, this would loop for usually long times, or until I reloaded the
driver:
```
[  349.794606] wlp0s20f3: disconnect from AP $AP_MAC for new auth to $MAC
[  349.899518] wlp0s20f3: authenticate with $MAC (local address=3D$LOCAL_MA=
C)
[  349.900258] wlp0s20f3: send auth to $MAC (try 1/3)
[  351.906522] wlp0s20f3: send auth to $MAC (try 2/3)
[  353.922497] wlp0s20f3: send auth to $MAC (try 3/3)
[  354.900727] wlp0s20f3: aborting authentication with $MAC by local choice=
 (Reason: 3=3DDEAUTH_LEAVING)
```

With the patches applied, I still got a few disconnects, but they were
imperceptible. I only know abour them because I was keeping an eye on my
logs (AKA `dmesg -w | rg 'wlp|iwl|auth|reason' `).

Example disconnection log with the patchset applied:
```
[ 341.720214] wlp0s20f3: disconnect from AP $AP_MAC for new auth to $MAC
[ 341.802793] wlp0s20f3: authenticate with $MAC (local address=3D$LOCAL_MAC=
)
[ 341.803277] wlp0s20f3: send auth to $MAC (try 1/3)
[ 343.820077] wlp0s20f3: send auth to $MAC (try 2/3)
[ 345.832125] wlp0s20f3: send auth to $MAC (try 3/3)
[ 346.803865] wlp0s20f3: aborting authentication with $MAC by local choice =
(Reason: 3=3DDEAUTH_LEAVING)
[ 350.389895] wlp0s20f3: authenticate with $AP_MAC (local address=3D$LOCAL_=
MAC)
[ 350.390412] wlp0s20f3: send auth to $AP_MAC (try 1/3)
[ 350.396872] wlp0s20f3: authenticated
[ 350.400017] wlp0s20f3: associate with $AP_MAC (try 1/3)
[ 350.413168] wlp0s20f3: RX AssocResp from $AP_MAC (capab=3D0x1111 status=
=3D0 aid=3D5)
[ 350.414412] wlp0s20f3: associated
[ 350.441020] wlp0s20f3: Limiting TX power to 36 (36 - 0) dBm as advertised=
 by $AP_MAC
```

Before finding this patchset, I also tried a few options from forums:
Running plain mainline 7.3.0-rc6,

disabling d3cold with udev rules,
# disabling WiFi 7
options iwlwifi disable_11be=3D1
# Disabling Power Saving on BE200 wifi
options iwlmld power_scheme=3D1
options iwlwifi power_save=3D0 uapsd_disable=3D1

Also tried connecting to a WiFi 2 only ssid (with "IOT friendly" options).

Thanks,
Rafael Passos
