Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59141 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2F1LcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 07:32:03 -0400
Received: by pbbrp8 with SMTP id rp8so2891474pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 04:32:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEeJrX4AoFqMtSOF3BFEV-s5WOhAXHnVwb6_5O5bNXWkUQ@mail.gmail.com>
References: <1340813387-18407-1-git-send-email-coelho@ti.com>
 <4FEC3B0E.3040001@broadcom.com> <CAB3XZEeJrX4AoFqMtSOF3BFEV-s5WOhAXHnVwb6_5O5bNXWkUQ@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 28 Jun 2012 14:31:47 +0300
Message-ID: <CA+XVXfeqQFd+raZeBEB+ct5mHLJfEPst1Bop0RUui6gN9=9jow@mail.gmail.com> (sfid-20120628_133209_116596_483EF565)
Subject: Re: [PATCH] wlcore: implement .flush callback
To: Eliad Peller <eliad@wizery.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 28, 2012 at 2:25 PM, Eliad Peller <eliad@wizery.com> wrote:
> On Thu, Jun 28, 2012 at 2:07 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 06/27/2012 06:09 PM, Luciano Coelho wrote:
>>> From: Eliad Peller <eliad@wizery.com>
>>>
>>> implement the .flush() callback by simply calling wl1271_tx_flush().
>>>
>>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>>> Signed-off-by: Luciano Coelho <coelho@ti.com>
>>> ---
>>>  drivers/net/wireless/ti/wlcore/main.c |    8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
>>> +static void wlcore_op_flush(struct ieee80211_hw *hw, bool drop)
>>> +{
>>> +     struct wl1271 *wl = hw->priv;
>>> +
>>> +     wl1271_tx_flush(wl);
>>> +}
>>> +
>>
>> So not taking the drop flag into account? Any plan to change that?
>>
> yeah, good point...
> i guess we'll want to add support for the drop flag as well.
>
> Luca - you can either drop this patch, or apply it for now and i'll
> send another patch later on.

Currently we drop all the packets if we can't flush them within a
reasonable time. We always do this right now. I think that's good
enough?
