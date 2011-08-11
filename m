Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58826 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1HKEjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 00:39:35 -0400
Received: by iye16 with SMTP id 16so530042iye.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 21:39:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313008248.2407.747.camel@cumari>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
 <1312881233-9366-31-git-send-email-eliad@wizery.com> <1313008248.2407.747.camel@cumari>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Thu, 11 Aug 2011 07:39:20 +0300
Message-ID: <CA+XVXfehboFG+zfULgo1LVYH0e7wwN5QcaeDYeBTxDo+E+1Ckw@mail.gmail.com> (sfid-20110811_063939_780198_E329866E)
Subject: Re: [PATCH 30/40] wl12xx: AP-mode - configure HT rate support to the FW
To: Luciano Coelho <coelho@ti.com>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 10, 2011 at 23:30, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote:
>> From: Arik Nemtsov <arik@wizery.com>
>>
>> Unconditionally configure HT rate support to the FW on all ACs
>> when starting the AP.
>>
>> When 11n support is disabled by usermode (hostapd), each STA joining
>> the AP will appear as a non-HT STA. This will stop us from accidentally
>> transmitting using MCS rates.
>
> Can we really trust this? I'd rather make sure we don't do anything
> wrong in the driver itself.

It doesn't hurt anything. The HT related IEs are advertised by
usermode. Nobody knows that the driver supports MCS rates.

>
> Or is all this actually handled in userspace? I'm not very familiar with
> how AP works, but is there any risk that someone tells us not to use 11n
> but still don't change the STAs so that they appear as non-HT?

Yes. The HT capabilities of the the STA are set to 0 when 11n is not
supported by usermode. This means we have sta->ht_cap.ht_supported ==
0 for any sta added by the sta_add() callback.
We use this information to correctly set the STA supported rates.

This is required anyway, as even when 11n is supported, some
connecting stations might be BG only.

Arik
