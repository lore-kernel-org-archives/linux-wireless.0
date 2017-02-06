Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:35322 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753192AbdBFPpd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 10:45:33 -0500
Subject: Re: rtlwifi: rtl8192c_common: "BUG: KASAN: slab-out-of-bounds"
To: Johannes Berg <johannes@sipsolutions.net>,
        Dmitry Osipenko <digetx@gmail.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>
References: <beff9033-0051-fd0f-87fe-8269a0d9c8d0@gmail.com>
 <f5682c5a-6c2c-8a35-61b6-1d7a30d2c1f6@gmail.com>
 <edbcbe3f-9b5d-cead-5885-27bc55ef550b@lwfinger.net>
 <1486376979.14226.9.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <fbe5786e-54eb-b8a7-1540-64a913692361@lwfinger.net> (sfid-20170206_164556_815193_DEC98DEF)
Date: Mon, 6 Feb 2017 09:45:31 -0600
MIME-Version: 1.0
In-Reply-To: <1486376979.14226.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2017 04:29 AM, Johannes Berg wrote:
> On Sat, 2017-02-04 at 12:41 -0600, Larry Finger wrote:
>> On 02/04/2017 10:58 AM, Dmitry Osipenko wrote:
>>> Seems the problem is caused by rtl92c_dm_*() casting .priv to
>>> "struct
>>> rtl_pci_priv", while it is "struct rtl_usb_priv".
>>
>> Those routines are shared by rtl8192ce and rtl8192cu, thus we need to
>> make that
>> difference in cast to be immaterial. I think we need to move "struct
>> bt_coexist_info" to the beginning of both rtlpci_priv and
>> rtl_usb_priv. Then it
>> should not matter.
>
> I think you really should consider putting a struct rtl_common into
> that or something, and getting rid of all the casting that causes this
> problem to start with?

The fix you suggest is prepared and will be submitted soon. As it is much more 
invasive with ~150 insertions and ~160 deletions, I decided not to have it be 
the one that is pushed to all stable kernels from 4.0 onward.

Larry
