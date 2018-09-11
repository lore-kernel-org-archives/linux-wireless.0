Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36518 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbeIKS6E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 14:58:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id e1-v6so17119727wrt.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2018 06:58:36 -0700 (PDT)
Date: Tue, 11 Sep 2018 15:58:32 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [linux-next:master 2211/3360]
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c:468: undefined reference to
 `mt76u_mcu_deinit'
Message-ID: <20180911135831.GA2760@localhost.localdomain> (sfid-20180911_155840_191436_537CD1F6)
References: <201809112137.2sMVZb3I%fengguang.wu@intel.com>
 <875zzcuosb.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <875zzcuosb.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> + felix, linux-wireless
> 
> kbuild test robot <lkp@intel.com> writes:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > head:   43783a8f68478e81fe183f86162d3e7ca29ba923
> > commit: 6f4796b7063e334902049b0cc41514b6c3b52876 [2211/3360] mt76x0: use mt76u_mcu_send_msg utility routine to send fw cmds
> > config: x86_64-randconfig-s5-09111320 (attached as .config)
> > compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> > reproduce:
> >         git checkout 6f4796b7063e334902049b0cc41514b6c3b52876
> >         # save the attached .config to linux build tree
> >         make ARCH=x86_64 
> >
> > All errors (new ones prefixed by >>):
> >
> >    drivers/net/wireless/mediatek/mt76/mt76x0/usb.o: In function `mt76x0_probe':
> >    drivers/net/wireless/mediatek/mt76/mt76x0/usb.c:119: undefined reference to `mt76u_init'
> >    drivers/net/wireless/mediatek/mt76/mt76x0/init.o: In function `mt76x0_init_hardware':
> >>> drivers/net/wireless/mediatek/mt76/mt76x0/init.c:468: undefined
> >>> reference to `mt76u_mcu_deinit'
> 
> kbuild bot has been sending quite a few similar warnings during the last
> day. Lorenzo, I assume you are looking at these?

All reported errors from intel kbuild test robot are due to missing
CONFIG_MT76_USB symbol. This should be fixed in latest Stanislaw's patchset:
[PATCH 37/42] mt76x0: initial split between pci and usb.

Regards,
Lorenzo

> 
> -- 
> Kalle Valo
