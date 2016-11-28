Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:44285 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751307AbcK1A6T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Nov 2016 19:58:19 -0500
Date: Mon, 28 Nov 2016 11:58:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: linux-next: build warning after merge of the wireless-drivers-next
 tree
Message-ID: <20161128115814.2cabf139@canb.auug.org.au> (sfid-20161128_015841_559177_9760A3F3)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

After merging the wireless-drivers-next tree, today's linux-next build
(x86_64 allmodconfig) produced this warning:

In file included from include/linux/usb/ch9.h:35:0,
                 from include/linux/usb.h:5,
                 from drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:32:
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function 'rtl8xxxu_fill_txdesc_v2':
include/linux/device.h:1214:36: warning: 'rate' may be used uninitialized in this function [-Wmaybe-uninitialized]
 #define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
                                    ^
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4841:6: note: 'rate' was declared here
  u32 rate;
      ^

Introduced by commit

  b4c3d9cfb607 ("rtl8xxxu: Pass tx_info to fill_txdesc in order to have access to retry count")

This is a correct diagnosis.

-- 
Cheers,
Stephen Rothwell
