Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6887042C519
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785507742; cv=pass; b=nHucTMxzbHHdJ3g+Ich4nB5aO5yy/FW8W99VCV1d9CzU4s2T3lBZ9ky2tiRhW8puLN6ccI/jLu2miIC7qofarA4jdGKM2CRLxPLFtX0rTr+ue0A5YTSbHMgB5Gfo1K63oGzuxGwx3/XO9oIgcqoDyQphz0W6KPRp+rnnGhnKzqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785507742; c=relaxed/simple;
	bh=caVOG86mVQcXP1p5KjgAHg4uqnUj9cMB97cE63QGOiM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=O8eZYMBDjGG+usbDv2htb8EpFblrXS3Ko+ue7bNOaaZcQcRAHwHfCQKGr3yiO5n9P7CnaQmPJzMCRK4MeTylLpibCKa44WBPBU+xhXnOp/b5oQc26GzAcRXJ5/DQeUsOoHk4MHJSwJDkmYUdPFO59jM8h+HfMKi45K5ZWDa/Qb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LhtD/1+2; arc=pass smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LhtD/1+2"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b013084dc2so892945e87.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 07:22:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785507739; cv=none;
        d=google.com; s=arc-20260327;
        b=UywxYbmfN3jzmoUUs/zK4O60xjOa6zG9XyGWWYaZcv1TcslMMDQ+u8oPcNSfhzshJm
         f4Rf88lRYtUenRtRbwQrr4AyFkAiZk/Srh+xAnpwByWSlqWXH4bb98XLIwOBOb5xzG6F
         /TeNzucB8ApI8AUs983XwvyEQKy9IoTnrprp6GcIUD7JgSeZelglKIfmf2jxtWXQSWYZ
         u54ewgsJKP35drQDIyxz/9Qa+p6+Nc5VsOZkmbW+D1OXhvuy53/56zRJxrHHLOwMB+8s
         uGnSsN9JgvM/kPT0Bf6enMp4rqE79hJ230wPtjHUvqNJILFuOnvHoxL5+Me5R+1wiqib
         nLZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=caVOG86mVQcXP1p5KjgAHg4uqnUj9cMB97cE63QGOiM=;
        fh=qW0phhq3fb3oiohK/Mu9j1KY1zyRNiiioKFc5anvatM=;
        b=fKjMMqC823mXzNLwsT4FkGIjR7kbDN2EOLc/rwAaPluHuebEmQxhwnyk2TyPzXqxCC
         5mteN9hxGnD9rMDHhk05xTlM48Q3fp8sv/1VvU0qmdY6ihRdIR9UKZUzr42J+cVjPdcd
         X7AKUpOl6pwvhT2H2AleYE+GOEoWE9YdhW8OKQtIfn9Jyy9jikmc6Ymi6fKuyk9IhZVs
         QYwYcDuqMyQFnYvkdfLBci8WrIWcq3SQaasICuWuUnDZBaP5XEdIdT+YbAM14FUPVQlw
         c/PCwm26BjPLWqHLkev8g5MMdCJog7r9CAKV4nA6dtdv7WkWreBaoso/RIO+es7mZwnv
         XYiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785507739; x=1786112539; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=caVOG86mVQcXP1p5KjgAHg4uqnUj9cMB97cE63QGOiM=;
        b=LhtD/1+2cRF8XliDSOK4wD0r9F93F4XUUPAYEaDoOebo4D5sVs3G2r+l4PrVGuWMTE
         LUh/oDN6vKT1n+2ERPoOjtQO/Ip3SzD3DRsTzVeQpNhZDOLq9S/ZE5fFwBHC32HRNy4y
         kaSSEj139QxzgYkLrfaXk777Z+x9VFmm/hgTnGVY5YDV5le1ciLddoHEE+uitU1LHK0W
         gHMojvAjweski/DG+WlKVFxKCUopNJdWoLT6qVZsRAIaA3Ziunxfy42TzXHFZ93oLgr/
         3jzdRF0mVCnNGU45W815Nvs0nOacx8vWAxIxt4+wUpaZA2jZ1WCYKet9y6xa8zepzMLT
         1VSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785507739; x=1786112539;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=caVOG86mVQcXP1p5KjgAHg4uqnUj9cMB97cE63QGOiM=;
        b=FUkj4B2d2SPMH2xSAnHyJAfVw7DovMXenNX72EpuF8kliLBabpWszHlTJDJguy9GNC
         0uzZcMyk9NmQTfE+B9s53sCaB7aE3T8WnnKMdtFmENx2DxL/57yYBhu8Ct9fxMRdF8ce
         TmvpQ9+QZA/Pu3eEXUVGD1l/Dlsi9h8Usg/44Xg2uZ5wgGx+29nt8YngO5v2SRRKo1r0
         ohc/5WRK1j33TJuhYCKe6WFEIHrP7pXFDDaLkcN2NWUbraTHNT5X77GZMjfupbFK4iyd
         fatWeRHeRn8YpnIdW39X4rroIm3oadO2rON3sPW1PsDGgWjPANVF6JTbvoMgwkVogSYN
         raVg==
X-Gm-Message-State: AOJu0Yz5TVLXb+j3PAiGonIz+6ol3DuXEzNefeifGbPnntDycfr45HH+
	nMEGkfycPomSQXLdBtLJU37bYjAWL5o5F9Jzzz2fcngKikKxCtqvnpAk5Z1ZxILa5NOFeVJi2Ml
	fg1PJQ/SwqIL0uRgrgixp3ahMd3GlD4juSG3p
X-Gm-Gg: AR+sD12L09AmnWhbkU4x4fgOCu8A1cTd+t0U2ENiBw00p35uJUiytxW91IYdajXk3DI
	nBdWF0ZrLWao8CqILV+2IBpJ0+VoWFbWBQJN3R53HGuE+mNUOedsloMZKXmUme5fV9G65ev3alS
	TodpZGhRltW+A0HDSZHmxv6J6ODNwNjS1sxlkKhFZ52s3mwMFyV1qpx1c0QXrDH8eSHrBZR7KzT
	rR9FQuZxqZPPIbScY24RhyxW3S5hAiGkXOwO3r+0DBvRinLTUQhtdUhQVOzmbKTOLQfumgDHGRa
	VHysGbTvRwWNOM7b8sj17ziqAzdZTRDEAis1CgZmJuBaRpe6hDdpdMs=
X-Received: by 2002:a05:6512:3195:b0:5b2:d7f2:90a4 with SMTP id
 2adb3069b0e04-5b2e1fc36e9mr511414e87.5.1785507739385; Fri, 31 Jul 2026
 07:22:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Peter Pan <mountainsaremedicine@gmail.com>
Date: Fri, 31 Jul 2026 10:22:08 -0400
X-Gm-Features: AUfX_mzQn_6DahO3NEahZz_EhKLwCJIw16fWCQBbiExiiMzee3wZc9UM73OQBew
Message-ID: <CAC8V4ZPpCRaD+dF4OP3Zt7eJXnrLFXNV1Fknfk+wEdyomKsHtg@mail.gmail.com>
Subject: =?UTF-8?Q?Hello=2C_I_am_reporting_a_reproducible_issue_with_the_?=
	=?UTF-8?Q?Linux_rtw88_driver_affecting_a_Realtek_RTL8821AU_USB_Wi=2DFi_a?=
	=?UTF-8?Q?dapter_during_monitor=2Dmode_channel_hopping=2E_Hardware=3A_TP=2DLin?=
	=?UTF-8?Q?k_Archer_T2U_Plus_USB_ID=3A_2357=3A0120_Chipset=3A_Realtek_RTL8821?=
	=?UTF-8?Q?AU_Software=3A_Ubuntu_Linux_Kernel=3A_7=2E0=2E0=2D28=2Dgeneric_Kismet_Ob?=
	=?UTF-8?Q?served_problem=3A_When_Kismet_performs_normal_channel_hopping=2C?=
	=?UTF-8?Q?_the_kernel_reports_warnings_involving=3A_drivers=2Fnet=2Fwireless?=
	=?UTF-8?Q?=2Frealtek=2Frtw88=2Fphy=2Ec_Function=3A_rtw=5Fget=5Fchannel=5Fgroup=28=29_Testi?=
	=?UTF-8?Q?ng_showed=3A_Kismet_locked_to_Channel_36_runs_without_triggeri?=
	=?UTF-8?Q?ng_the_warnings=2E_Enabling_channel_hopping_causes_the_warning?=
	=?UTF-8?Q?s_to_return=2E_The_issue_appears_when_the_adapter_reaches_uppe?=
	=?UTF-8?Q?r_5_GHz_UNII=2D3_channels_=28149=E2=80=93165=29=2C_especially_Channel_157=2E?=
	=?UTF-8?Q?_This_appears_to_be_a_driver_issue_involving_5_GHz_channel_g?=
	=?UTF-8?Q?rouping_logic_in_rtw88=2E_The_behavior_is_reproducible_and_app?=
	=?UTF-8?Q?ears_to_be_triggered_by_normal_monitor=2Dmode_channel_hopping=2E?=
	=?UTF-8?Q?_I_am_not_a_kernel_developer_and_I_am_not_submitting_a_patch?=
	=?UTF-8?Q?=2E_I_am_reporting_the_issu=2E?=
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

RTL8821AU rtw88 driver issue during Kismet 5 GHz channel hopping
