Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48409 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932808AbcKPP1Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 10:27:16 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "briannorris@google.com" <briannorris@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v2 5/5] mwifiex: wait firmware dump complete during card
 remove process
Date: Wed, 16 Nov 2016 15:27:11 +0000
Message-ID: <2048af37ed4240ae86fd9f547259bf7b@SC-EXCH04.marvell.com> (sfid-20161116_162720_589899_324CFA24)
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
 <1477559563-18328-5-git-send-email-akarwar@marvell.com>
 <20161027184851.GB28717@localhost>
In-Reply-To: <20161027184851.GB28717@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> > +
> >  static int
> >  mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct
> sk_buff *skb,
> >  		       size_t size, int flags)
> > @@ -249,6 +252,8 @@ static void mwifiex_pcie_remove(struct pci_dev
> *pdev)
> >  	if (!adapter || !adapter->priv_num)
> >  		return;
> >
> > +	cancel_work_sync(&pcie_work);
> 
> Hmm, actually what happens if we have !adapter? Then that means we've
> already torn down the device (e.g., unregister_dev() -- except we
> haven't quite fixed that bug, see the other patch series you sent out),
> and so we'll never reach this. But that also means we haven't
> synchronized any outstanding work.

There won't be any outstanding work in that case where init failure thread has already cleared "adapter"

Pcie/sdio Work(firmware dump + card reset) is scheduled in below two scenarios
1) Command timeout -- We have a check to skip triggering work when hw_status shows it's INITIALIZING. 
2) Tx data timeout -- Tx data is applicable only when wifi connection is alive. In above mentioned case, device itself has failed to initialize.

> 
> So this really belongs in one of the earlier mwifiex callbacks
> (unregister_dev()?), and not in the device remove() callback.
> 

Regards,
Amitkumar
