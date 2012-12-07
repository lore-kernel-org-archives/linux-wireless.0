Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59776 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423664Ab2LGSNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 13:13:31 -0500
Received: by mail-qa0-f46.google.com with SMTP id r4so2166613qaq.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 10:13:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354872204.6234.92.camel@cumari.coelho.fi>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
 <1354095769-8724-12-git-send-email-arik@wizery.com> <1354872204.6234.92.camel@cumari.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 7 Dec 2012 20:13:15 +0200
Message-ID: <CA+XVXfdQfKtfoVvfmiv2m=Qk5nNB+_O+Z-SLbk3_kam8b=RLWQ@mail.gmail.com> (sfid-20121207_191346_520196_86F32B0B)
Subject: Re: [PATCH 11/20] wlcore/wl18xx: change priority calculations for links
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 7, 2012 at 11:23 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
>> Update the 18xx FW status private part to include Tx related link
>> priorities. Introduce new HW ops to determine link priority per chip
>> family.
>>
>> For 18xx the changes are:
>> - Suspended links are at most low priority and Tx for them is stopped
>>   beyond the suspend threshold.
>> - Active links now get their thresholds directly from FW
>> - There's a new "stop" threshold for active links, at which point a link
>>   stops receiving new packets.
>>
>> Update the min 18xx FW version required to make sure suspended links
>> bitmap is advertised by the FW.
>
> This doesn't apply anymore, I'll remove it.

Sounds good. Thanks.

>
>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> Otherwise this patch looks good!
>
> Just to understand better, why is the firmware deciding on the
> thresholds? Does it make some internal magic itself to know the number
> of links (including multi-channel) and adjust the thresholds
> accordingly? Isn't this something we could (or should?) do in the kernel
> side?

Yes the FW decides on the thresholds based on the multi-channel state.
Basically links are suspended and resumed all the time.

The FW knows some stuff we don't know, for instance the real speed of
the link and if a BA session is ongoing. Makes it easy for them to
tweak these values.
Of course they could export all the information, but I don't think it
really matters one way or the other. It works well this way.

Arik
