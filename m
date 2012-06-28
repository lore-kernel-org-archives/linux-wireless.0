Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2534 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545Ab2F1SoZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 14:44:25 -0400
Message-ID: <4FECA5FB.30902@broadcom.com> (sfid-20120628_204429_916701_C37F3CC7)
Date: Thu, 28 Jun 2012 20:44:11 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Arik Nemtsov" <arik@wizery.com>
cc: "Eliad Peller" <eliad@wizery.com>,
	"Luciano Coelho" <coelho@ti.com>, linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] wlcore: implement .flush callback
References: <1340813387-18407-1-git-send-email-coelho@ti.com>
 <4FEC3B0E.3040001@broadcom.com>
 <CAB3XZEeJrX4AoFqMtSOF3BFEV-s5WOhAXHnVwb6_5O5bNXWkUQ@mail.gmail.com>
 <CA+XVXfeqQFd+raZeBEB+ct5mHLJfEPst1Bop0RUui6gN9=9jow@mail.gmail.com>
In-Reply-To: <CA+XVXfeqQFd+raZeBEB+ct5mHLJfEPst1Bop0RUui6gN9=9jow@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2012 01:31 PM, Arik Nemtsov wrote:
> On Thu, Jun 28, 2012 at 2:25 PM, Eliad Peller <eliad@wizery.com> wrote:
>> On Thu, Jun 28, 2012 at 2:07 PM, Arend van Spriel <arend@broadcom.com> wrote:
>>> On 06/27/2012 06:09 PM, Luciano Coelho wrote:
>>>> From: Eliad Peller <eliad@wizery.com>
>>>>
>>>> implement the .flush() callback by simply calling wl1271_tx_flush().
>>>>
>>>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>>>> Signed-off-by: Luciano Coelho <coelho@ti.com>
>>>> ---
>>>>  drivers/net/wireless/ti/wlcore/main.c |    8 ++++++++
>>>>  1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
>>>> +static void wlcore_op_flush(struct ieee80211_hw *hw, bool drop)
>>>> +{
>>>> +     struct wl1271 *wl = hw->priv;
>>>> +
>>>> +     wl1271_tx_flush(wl);
>>>> +}
>>>> +
>>>
>>> So not taking the drop flag into account? Any plan to change that?
>>>
>> yeah, good point...
>> i guess we'll want to add support for the drop flag as well.
>>
>> Luca - you can either drop this patch, or apply it for now and i'll
>> send another patch later on.
> 
> Currently we drop all the packets if we can't flush them within a
> reasonable time. We always do this right now. I think that's good
> enough?
> 

Hard to say as I am working mostly on your side of this API. However,
the drop flag is part of the API so there is probably a reason for
having it. Johannes?

Gr. AvS

