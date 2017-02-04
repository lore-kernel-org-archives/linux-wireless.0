Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35785 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdBDTdD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Feb 2017 14:33:03 -0500
Subject: Re: rtlwifi: rtl8192c_common: "BUG: KASAN: slab-out-of-bounds"
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
References: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com>
 <f5682c5a-6c2c-8a35-61b6-1d7a30d2c1f6@gmail.com>
 <edbcbe3f-9b5d-cead-5885-27bc55ef550b@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <b100135b-97c4-b2bc-4f19-2574e573878b@gmail.com> (sfid-20170204_203332_024008_52FBEE01)
Date: Sat, 4 Feb 2017 22:32:59 +0300
MIME-Version: 1.0
In-Reply-To: <edbcbe3f-9b5d-cead-5885-27bc55ef550b@lwfinger.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04.02.2017 21:41, Larry Finger wrote:
> On 02/04/2017 10:58 AM, Dmitry Osipenko wrote:
>> Seems the problem is caused by rtl92c_dm_*() casting .priv to "struct
>> rtl_pci_priv", while it is "struct rtl_usb_priv".
> 
> Those routines are shared by rtl8192ce and rtl8192cu, thus we need to make that
> difference in cast to be immaterial. I think we need to move "struct
> bt_coexist_info" to the beginning of both rtlpci_priv and rtl_usb_priv. Then it
> should not matter.
> 
> I do not have a gcc version new enough to turn KASAN testing on, thus the
> attached patch is only compile tested. Does it fix the problem?

Thank you for the patch, it indeed fixes the bug.

I noticed that struct rtl_priv contains .btcoexist, isn't it duplicated in the
struct rtl_pci_priv?

-- 
Dmitry
