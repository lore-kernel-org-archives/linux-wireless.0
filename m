Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33976 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbdBDQ6k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Feb 2017 11:58:40 -0500
Subject: Re: rtlwifi: rtl8192c_common: "BUG: KASAN: slab-out-of-bounds"
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
References: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <f5682c5a-6c2c-8a35-61b6-1d7a30d2c1f6@gmail.com> (sfid-20170204_175907_614047_B8E36C4C)
Date: Sat, 4 Feb 2017 19:58:37 +0300
MIME-Version: 1.0
In-Reply-To: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seems the problem is caused by rtl92c_dm_*() casting .priv to "struct
rtl_pci_priv", while it is "struct rtl_usb_priv".


-- 
Dmitry
