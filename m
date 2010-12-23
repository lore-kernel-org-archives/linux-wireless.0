Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44662 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab0LWIL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 03:11:59 -0500
Received: by gyb11 with SMTP id 11so2429026gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Dec 2010 00:11:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293053782.14423.51.camel@powerslave>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
 <1293028057-6212-9-git-send-email-arik@wizery.com> <1293053782.14423.51.camel@powerslave>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 23 Dec 2010 10:05:42 +0200
Message-ID: <AANLkTi=M0i+7-sYV3Y8z7cFFZbtpejZh8sH_QyeCNWq6@mail.gmail.com>
Subject: Re: [PATCH v2 08/18] wl1271: Add AP related definitions to HOST-FW interface
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 23:36, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
>> Change structures in a non-destructive manner. This means no
>> changes in size or location of existing members used by STA.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
>> index 3abb26f..19fd591 100644
>> --- a/drivers/net/wireless/wl12xx/rx.h
>> +++ b/drivers/net/wireless/wl12xx/rx.h
>> @@ -86,10 +86,11 @@
>>  /*
>>   * RX Descriptor status
>>   *
>> - * Bits 0-2 - status
>> - * Bits 3-7 - reserved
>> + * Bits 0-2 - error code
>> + * Bits 3-5 - process_id tag (AP mode FW)
>> + * Bits 6-7 - reserved
>>   */
>> -#define WL1271_RX_DESC_STATUS_MASK      0x07
>> +#define WL1271_RX_DESC_STATUS_MASK      0x03
>
> What happened with bit 2?

You're right. Actually ported over a bug from the original TI driver.
Since only errors 1-3 are defined this still works. But its a bug
anyway. Will revert.

Regards,
Arik
