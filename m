Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57336 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2KTNeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 08:34:22 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so8521297iea.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 05:34:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEdLVeow_0RHSYyU-HeuaiddNYA=yxWNbUik8HWm=rD+8Q@mail.gmail.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
 <1353410411-18833-6-git-send-email-eliad@wizery.com> <CA+XVXfcXYbqgOaX43_X4b1+CL4Pchr_cR2_4Y1YyycF4dk6_Hg@mail.gmail.com>
 <CAB3XZEdLVeow_0RHSYyU-HeuaiddNYA=yxWNbUik8HWm=rD+8Q@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 20 Nov 2012 15:34:02 +0200
Message-ID: <CA+XVXfdAjog=Y+ptd-uH8Di2Ae1p3TP7UxTmAvVw0cQ8Sn=aTQ@mail.gmail.com> (sfid-20121120_143435_607099_FF46A409)
Subject: Re: [PATCH v2 05/11] wlcore: add chanctx implementation
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2012 at 2:04 PM, Eliad Peller <eliad@wizery.com> wrote:
> On Tue, Nov 20, 2012 at 1:45 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> On Tue, Nov 20, 2012 at 1:20 PM, Eliad Peller <eliad@wizery.com> wrote:
>>> Add some basic chanctx implementation - debug prints,
>>> and save the vif's channel/band/type.
>>>
>>> After that, we no longer need to handle channel change
>>> notifications on op_config.
>>>
>>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>>> ---
>>> +       /* update default rates according to the band */
>>> +       wl1271_set_band_rate(wl, wlvif);
>>
>> set_band_rate should be fixed to also set wl->basic_rate. but this can
>> be a separate patch..
>> previously we had some manual code to set the basic_rate, which you removed.
>
> as i mentioned before, there is a huge mess in the rates handling.
> for sta - we set wlvif->basic_rate anyway on CHANGED_BSSID
> for ap - we don't use it at all, but use wl1271_tx_min_rate_get(wl,
> wlvif->basic_rate_set)
>
> so it's not really an issue.
> i think we should handle all this in a separate patch.

I agree. I'm not even sure the per-band rates are used right now, I
think we're just reverting to some default rates.
