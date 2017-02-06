Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38198 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751691AbdBFK3r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 05:29:47 -0500
Message-ID: <1486376979.14226.9.camel@sipsolutions.net> (sfid-20170206_113036_542161_06581776)
Subject: Re: rtlwifi: rtl8192c_common: "BUG: KASAN: slab-out-of-bounds"
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Dmitry Osipenko <digetx@gmail.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 06 Feb 2017 11:29:39 +0100
In-Reply-To: <edbcbe3f-9b5d-cead-5885-27bc55ef550b@lwfinger.net> (sfid-20170204_194158_652576_51C325FF)
References: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com>
         <f5682c5a-6c2c-8a35-61b6-1d7a30d2c1f6@gmail.com>
         <edbcbe3f-9b5d-cead-5885-27bc55ef550b@lwfinger.net>
         (sfid-20170204_194158_652576_51C325FF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-02-04 at 12:41 -0600, Larry Finger wrote:
> On 02/04/2017 10:58 AM, Dmitry Osipenko wrote:
> > Seems the problem is caused by rtl92c_dm_*() casting .priv to
> > "struct
> > rtl_pci_priv", while it is "struct rtl_usb_priv".
> 
> Those routines are shared by rtl8192ce and rtl8192cu, thus we need to
> make that 
> difference in cast to be immaterial. I think we need to move "struct 
> bt_coexist_info" to the beginning of both rtlpci_priv and
> rtl_usb_priv. Then it 
> should not matter.

I think you really should consider putting a struct rtl_common into
that or something, and getting rid of all the casting that causes this
problem to start with?

johannes
