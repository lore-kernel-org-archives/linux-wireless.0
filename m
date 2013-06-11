Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:49196 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3FKFl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 01:41:29 -0400
Received: by mail-la0-f44.google.com with SMTP id er20so6485467lab.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jun 2013 22:41:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130611042801.GA217@FermiDesk>
References: <20130611042801.GA217@FermiDesk>
Date: Tue, 11 Jun 2013 08:41:28 +0300
Message-ID: <CANUX_P0ddkfEY+hxir8=PGH1ocS5FQRFwvrm2otj3eTUkwJ+Gw@mail.gmail.com> (sfid-20130611_074133_003190_DA7F71C6)
Subject: Re: Intel Centrino Wireless-N 2200 Tech Support
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Edward Seyler <epseyler@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> # dmesg | grep iwl
>
> [    9.868028] iwlwifi 0000:03:00.0: irq 44 for MSI/MSI-X
> [    9.942668] iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
> [   10.015848] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
> [   10.015861] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
> [   10.015866] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
> [   10.015872] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
> [   10.015877] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P enabled
> [   10.015884] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Wireless-N 2200 BGN, REV=0x104
> [   10.015912] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [   10.056013] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> [  280.878663] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
> [  280.886234] iwlwifi 0000:03:00.0: Radio type=0x2-0x0-0x0
> [  285.886692] iwlwifi 0000:03:00.0: Failed to load firmware chunk!
> [  285.886888] iwlwifi 0000:03:00.0: Could not load the [0] uCode section
> [  285.887299] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110
> [  285.887516] iwlwifi 0000:03:00.0: Unable to initialize device.
>

This is really weird...
Can you compile with CONFIG_IWLWIFI_DEBUG?
I will then need a few debug prints.
I recently changed this flow to speed up the fw loading process on
platform that can afford a bit amount of DMA, but I just tested it
(again) and it works even if there is not big DMA chunk available.
