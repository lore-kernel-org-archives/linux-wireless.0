Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56348 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751255AbdEHIrX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 May 2017 04:47:23 -0400
Message-ID: <1494233238.14233.172.camel@coelho.fi> (sfid-20170508_104728_031139_F2C6F51C)
From: Luca Coelho <luca@coelho.fi>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 08 May 2017 11:47:18 +0300
In-Reply-To: <CAFED-jmhSQ2AVT36EgBpt+brvaT-HA=MKvpJUMmzwPtF44b00w@mail.gmail.com>
References: <CAFED-jmhSQ2AVT36EgBpt+brvaT-HA=MKvpJUMmzwPtF44b00w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi 8260 crash (4.11rc6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, 2017-05-06 at 08:39 +0200, Janusz Dziedzic wrote:
> 4.11.0-rc6-next-20170413+
> 04:00.0 Network controller: Intel Corporation Wireless 8260 (rev 3a)
> iwlwifi 0000:04:00.0: loaded firmware version 21.302800.0 op_mode iwlmvm
> 
> Scenario:
> - iwlwifi configured in monitor mode - up
> - suspend my laptop
> - crash

[...]


> [42287.379104] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
> [42287.379107] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
> [42287.379109] iwlwifi 0000:04:00.0: Loaded firmware version: 21.302800.0
> [42287.379112] iwlwifi 0000:04:00.0: 0x00002B00 | ADVANCED_SYSASSERT

Interesting that you found a good way to reproduce this.  Does it happen
everytime you suspend while monitor mode is enabled?

We have seen a similar case here:

https://bugzilla.kernel.org/show_bug.cgi?id=192691

To use monitor mode you need to use amsdu_size=3 in iwlwifi module
parameters.  Check my comment #15 there.

Can you try this and add your results in that bug report so we can track
the progress?


--
Cheers,
Luca.
