Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:39387 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbeACSkf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jan 2018 13:40:35 -0500
Received: by mail-it0-f44.google.com with SMTP id 68so2857491ite.4
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jan 2018 10:40:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5a4d1327681fb1.97988235@wp.pl>
References: <5a4d1327681fb1.97988235@wp.pl>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Wed, 3 Jan 2018 20:40:34 +0200
Message-ID: <CANUX_P3Ymyhqpyd8Yf0qMeM6=TOTnCXo0PE9KVsknvddCBPeYQ@mail.gmail.com> (sfid-20180103_194039_876109_50060E25)
Subject: Re: iwlwifi: mvm: rx ops with kernel >= 4.14
To: Dawid Stawiarski <neeo@xl.wp.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>
> hi,
>
> after updating to kernel >= 4.14 (from 4.13.X) my wifi stops working every couple hours with the following stacktrace (I've already updated firmware to latest version):
>
> jan 03 13:28:17 tmi kernel: iwlwifi 0000:3b:00.0: loaded firmware version 17.608620.0 op_mode iwlmvm
> jan 03 13:28:17 tmi kernel: iwlwifi 0000:3b:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
> jan 03 13:28:17 tmi kernel: iwlwifi 0000:3b:00.0: base HW address: d8:fc:93:14:cc:15
> jan 03 13:28:17 tmi kernel: ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
> [...]
> jan 03 16:14:05 tmi kernel: iwlwifi 0000:3b:00.0: iwl_pcie_cmdq_reclaim: Read index for DMA queue txq id (0), index 0 is out of range [0-256] 70 70.
> jan 03 16:14:05 tmi kernel: iwlwifi 0000:3b:00.0: HCMD_ACTIVE already clear for command LQ_CMD
> jan 03 16:14:05 tmi kernel: frame on invalid queue - is on 0 and indicates 1
> jan 03 16:14:05 tmi kernel: ------------[ cut here ]------------

Can you please check if the patch in
https://bugzilla.kernel.org/show_bug.cgi?id=198265 helps?
