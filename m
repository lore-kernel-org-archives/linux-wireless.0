Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37538 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbcAWSJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2016 13:09:35 -0500
Received: by mail-wm0-f42.google.com with SMTP id n5so24854090wmn.0
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2016 10:09:35 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 23 Jan 2016 19:09:33 +0100
Message-ID: <CAOQ7t2Z2E3vn+t9gDZKfs9Ke1aPEGObgSi2RZDzD7kPVR2LJzg@mail.gmail.com> (sfid-20160123_191006_045173_603F54B2)
Subject: [BISECTED] brcmfmac issue
From: Carlo Caione <carlo@caione.org>
To: Ulf Hansson <ulf.hansson@linaro.org>, arend@broadcom.com,
	meuleman@broadcom.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I submitted [1] e10c3219 "mmc: core: Enable tuning according to the
actual timing"  to solve a problem with the BCM43340 SDIO WiFi card.
This patch works perfectly fine on top of v4.4 tag, solving the
problem with the WiFi card. With the latest master the asus x205ta
laptop fails to boot. The failure seems related to a weird interaction
between this patch and 7d34b05 "brcmfmac: Move all module parameters
to one place" (bad commit).

The bad commit was found bisecting between master and v4.4 and
applying my patch when not already present.

Here the log: https://gist.github.com/9db683a467496c942659

Any idea?

Cheers,

[1] http://www.spinics.net/lists/linux-mmc/msg34791.html

-- 
Carlo Caione
