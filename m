Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63709 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1JUVfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 17:35:33 -0400
Received: by bkbzt19 with SMTP id zt19so5298834bkb.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 14:35:32 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-2?Q?Patryk_=AF=F3=B3towski?=
	<patryk.zoltowski@gmail.com>
Date: Fri, 21 Oct 2011 23:35:12 +0200
Message-ID: <CAJ5hJZSm4P5Vpzmi6yfF3vy2XAMKH9kE-Kv=FfDLVX9DwQC4Aw@mail.gmail.com> (sfid-20111021_233537_446543_323407AA)
Subject: Setting negative value in dBm for power output (txpower)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm doing a research and I'm wondering if it's possible to hack
wireless drivers to allow setting  txpower to smaller value than 1mW
(e.g. 0.1mW = -10dBM, or even 0.01mW). I've checked source code and in
net/mac80211/cfg.c there is the following check:

  if (mbm < 0 || (mbm % 100))
                     return -EOPNOTSUPP;

and in  e.g. in drivers/net/wireless/iwlwifi/iwl-4965.h  also the min
power output is limited by this define:

 IWL_TX_POWER_TARGET_POWER_MIN       (0)

Is it possible to modify source to allow negative power output in dBm
that would work? Or is it physical limitation from the hardware? I'm
doing just a research using Intel Corporation PRO/Wireless 4965 AG
card  and right now I don't require to support other hardware. Is
there any way to check minimum power output capability by given
wireless card? I'm not proficient with driver hacking so any hint
where to start (which file to look up, references) would be helpful.

Thanks,
Patryk
