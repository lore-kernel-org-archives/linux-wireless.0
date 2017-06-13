Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:33899 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbdFMLjB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 07:39:01 -0400
Received: by mail-lf0-f48.google.com with SMTP id v20so68720284lfa.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 04:39:00 -0700 (PDT)
Subject: Re: [for-4.12] brcmfmac: fix brcmf_fws_add_interface() for USB
 devices
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
References: <1497268595-4836-1-git-send-email-arend.vanspriel@broadcom.com>
 <20170613061312.8B39C607C4@smtp.codeaurora.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <611a8144-0adb-87d2-a5c0-8cc88bc5f1c6@broadcom.com> (sfid-20170613_133904_728498_06CD8C3B)
Date: Tue, 13 Jun 2017 13:38:58 +0200
MIME-Version: 1.0
In-Reply-To: <20170613061312.8B39C607C4@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 13-06-17 08:13, Kalle Valo wrote:
> Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> 
>> USB devices rely on queuing functionality provided by the fwsignal
>> module regardless the mode fwsignal is operating in. For this some
>> data structure needs to be reserved which is tied to the interface,
>> which is done by brcmf_fws_add_interface(). However, it checks the
>> mode. Replace that by checking result from brcmf_fws_queue_skbs().

Ok. Please add:
"""
Otherwise the driver will crash in a null pointer dereference when data
is transmitted on the interface.
"""

Regards,
Arend

>> Fixes: fc0471e3e884 ("brcmfmac: ignore interfaces when fwsignal is disabled")
>> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> Same here, a short description of the bug would be nice.
> 
