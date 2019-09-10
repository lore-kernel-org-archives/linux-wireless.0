Return-Path: <SRS0=RZjE=XF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940C8C49ED7
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Sep 2019 19:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7289221479
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Sep 2019 19:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbfIJTLS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Sep 2019 15:11:18 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:25645 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbfIJTLS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Sep 2019 15:11:18 -0400
X-IronPort-AV: E=Sophos;i="5.64,490,1559512800"; 
   d="scan'208";a="401135346"
Received: from abo-12-105-68.mrs.modulonet.fr (HELO hadrien) ([85.68.105.12])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 21:11:16 +0200
Date:   Tue, 10 Sep 2019 21:11:16 +0200 (CEST)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To:     amitkarwar@gmail.com, siva8118@gmail.com
cc:     syzkaller-bugs@googlegroups.com, kvalo@codeaurora.org,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: syzbot report in rsi_91x_usb.c
Message-ID: <alpine.DEB.2.21.1909102049130.2551@hadrien>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

I spent some time looking at:

https://syzkaller.appspot.com/bug?id=c1b6aa968706d9380dcdb98a9f2c338071cc938c

which does not yet report that it has been fixed.

The problem seems to be in rsi_probe in
drivers/net/wireless/rsi/rsi_91x_usb.c.  This ends with the following
code:

        status = rsi_rx_urb_submit(adapter, WLAN_EP);
        if (status)
                goto err1;

        if (adapter->priv->coex_mode > 1) {
                status = rsi_rx_urb_submit(adapter, BT_EP);
                if (status)
                        goto err1;
        }

        return 0;
err1:
        rsi_deinit_usb_interface(adapter);
err:
        rsi_91x_deinit(adapter);


The problem seems to be that the first call to rsi_rx_urb_submit succeeds,
submitting an urb, and then theh second one fails.  Both share adapter,
which is used in rsi_rx_done_handler, invoked later as the callback
provided with usb_submit_urb.  But adapter, and in particular its rsi_dev
field, are freed by the rsi_91x_deinit call due to the failure of the
second call to rsi_rx_urb_submit.

How should this be fixed?

thanks,
julia
