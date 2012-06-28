Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60397 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2F1LZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 07:25:22 -0400
Received: by pbbrp8 with SMTP id rp8so2884202pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 04:25:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FEC3B0E.3040001@broadcom.com>
References: <1340813387-18407-1-git-send-email-coelho@ti.com>
	<4FEC3B0E.3040001@broadcom.com>
Date: Thu, 28 Jun 2012 14:25:22 +0300
Message-ID: <CAB3XZEeJrX4AoFqMtSOF3BFEV-s5WOhAXHnVwb6_5O5bNXWkUQ@mail.gmail.com> (sfid-20120628_132526_174517_9FDCF5D1)
Subject: Re: [PATCH] wlcore: implement .flush callback
From: Eliad Peller <eliad@wizery.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	arik@wizery.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 28, 2012 at 2:07 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 06/27/2012 06:09 PM, Luciano Coelho wrote:
>> From: Eliad Peller <eliad@wizery.com>
>>
>> implement the .flush() callback by simply calling wl1271_tx_flush().
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> Signed-off-by: Luciano Coelho <coelho@ti.com>
>> ---
>>  drivers/net/wireless/ti/wlcore/main.c |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
>> +static void wlcore_op_flush(struct ieee80211_hw *hw, bool drop)
>> +{
>> +     struct wl1271 *wl = hw->priv;
>> +
>> +     wl1271_tx_flush(wl);
>> +}
>> +
>
> So not taking the drop flag into account? Any plan to change that?
>
yeah, good point...
i guess we'll want to add support for the drop flag as well.

Luca - you can either drop this patch, or apply it for now and i'll
send another patch later on.

thanks,
Eliad.
