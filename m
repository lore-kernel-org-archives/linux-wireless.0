Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:34836 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbCMCgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 22:36:51 -0400
MIME-Version: 1.0
In-Reply-To: <5501CCFB.3040203@lwfinger.net>
References: <1426160036-1542-1-git-send-email-hamo.by@gmail.com> <5501CCFB.3040203@lwfinger.net>
From: Yang Bai <hamo.by@gmail.com>
Date: Fri, 13 Mar 2015 10:36:29 +0800
Message-ID: <CAO_0yfMgV7Sh8uJebE5VN4U3EkjCciYh659_OY5ZwJvjOgM7LA@mail.gmail.com> (sfid-20150313_033701_809061_9B04BE78)
Subject: Re: [PATCH] rtlwifi: get buffer_desc before trying to alloc new skb
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 13, 2015 at 1:29 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 03/12/2015 06:33 AM, Yang Bai wrote:
>>
>> if rtlpriv->use_new_trx_flow == true and we run out of memory
>> to alloc a new skb, we will directly jump to no_new tag with
>> buffer_desc == NULL. Then we will dereference this NULL pointer
>> in function _rtl_pci_init_one_rxdesc.
>>
>> Signed-off-by: Yang Bai <hamo.by@gmail.com>
>
>
> Is the attached patch OK? I have tested it, but it is unlikely that I have
> hit any memory failures, thus that part needs to be checked by eye.

Looks good to me. Thanks very much for your review.

Yang
>
> Larry
>
>
