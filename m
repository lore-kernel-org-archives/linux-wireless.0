Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:65269 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab2KTMEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 07:04:36 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so5805414oag.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 04:04:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfcXYbqgOaX43_X4b1+CL4Pchr_cR2_4Y1YyycF4dk6_Hg@mail.gmail.com>
References: <1353410411-18833-1-git-send-email-eliad@wizery.com>
	<1353410411-18833-6-git-send-email-eliad@wizery.com>
	<CA+XVXfcXYbqgOaX43_X4b1+CL4Pchr_cR2_4Y1YyycF4dk6_Hg@mail.gmail.com>
Date: Tue, 20 Nov 2012 14:04:35 +0200
Message-ID: <CAB3XZEdLVeow_0RHSYyU-HeuaiddNYA=yxWNbUik8HWm=rD+8Q@mail.gmail.com> (sfid-20121120_130439_057703_560C5862)
Subject: Re: [PATCH v2 05/11] wlcore: add chanctx implementation
From: Eliad Peller <eliad@wizery.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2012 at 1:45 PM, Arik Nemtsov <arik@wizery.com> wrote:
> On Tue, Nov 20, 2012 at 1:20 PM, Eliad Peller <eliad@wizery.com> wrote:
>> Add some basic chanctx implementation - debug prints,
>> and save the vif's channel/band/type.
>>
>> After that, we no longer need to handle channel change
>> notifications on op_config.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>> +       /* update default rates according to the band */
>> +       wl1271_set_band_rate(wl, wlvif);
>
> set_band_rate should be fixed to also set wl->basic_rate. but this can
> be a separate patch..
> previously we had some manual code to set the basic_rate, which you removed.

as i mentioned before, there is a huge mess in the rates handling.
for sta - we set wlvif->basic_rate anyway on CHANGED_BSSID
for ap - we don't use it at all, but use wl1271_tx_min_rate_get(wl,
wlvif->basic_rate_set)

so it's not really an issue.
i think we should handle all this in a separate patch.

Eliad.
