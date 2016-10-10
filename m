Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33998 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752589AbcJJU3B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 16:29:01 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Revert "rtlwifi: rtl818x: constify local structures"
To: Johannes Berg <johannes@sipsolutions.net>, kvalo@codeaurora.org
References: <20161010152520.9812-1-Larry.Finger@lwfinger.net>
 <1476118573.7895.13.camel@sipsolutions.net>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Stable <stable@vger.kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Message-ID: <90ea968e-dc19-5c2e-8aa4-6296a1d04381@lwfinger.net> (sfid-20161010_222905_490460_A45B2C8D)
Date: Mon, 10 Oct 2016 15:28:28 -0500
MIME-Version: 1.0
In-Reply-To: <1476118573.7895.13.camel@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/2016 11:56 AM, Johannes Berg wrote:
> On Mon, 2016-10-10 at 10:25 -0500, Larry Finger wrote:
>> This reverts commit d86e64768859fca82c78e52877ceeba04e25d27a.
>>
>> For drivers rtl8188ee, rtl8192ce, rtl8192ee, rtl8723ae, and
>> rtl8821ae,
>> the Coccinelle script missed the fact that the code changes the
>> firmware
>> name. When that happens, the kernel issues a BUG splat because
>> it is unable to overwrite the old name.
>
> Hmm. That seems somewhat problematic, for example if you have multiple
> devices that use the same driver but need different firmware?
>
> Not that I really know what's going on, but changing static variables
> based on runtime seems like it could cause issues in such cases.

I think the situation is OK, but I have created a patch that converts all the 
firmware names into local strings in the routines that initiate firmware 
loading. That way the affected structs can be constified without problem.

@Kalle: Please drop the patch with this subject.

Thanks,

Larry
