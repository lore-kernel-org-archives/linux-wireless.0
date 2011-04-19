Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54223 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab1DSVyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 17:54:40 -0400
Received: by iyb14 with SMTP id 14so98457iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 14:54:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303216566.3603.6.camel@jlt3.sipsolutions.net>
References: <1303125749-31967-1-git-send-email-arik@wizery.com>
 <1303129610.3588.7.camel@jlt3.sipsolutions.net> <BANLkTikc9wrZ__8URZ3ASQ6F=rUHix2iGA@mail.gmail.com>
 <1303216566.3603.6.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 20 Apr 2011 00:54:25 +0300
Message-ID: <BANLkTik81g3NOwHcQk2eqOcMjaubCLdk+w@mail.gmail.com>
Subject: Re: [PATCH 1/2] mac80211: allow low level drivers to report packet loss
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 19, 2011 at 15:36, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2011-04-18 at 23:44 +0300, Arik Nemtsov wrote:
>
>> Well in a wl12xx chip we just configure some thresholds to the FW and
>> it triggers the event for us. Using TX status doesn't really make
>> sense since the FW has automatic rate control (so 50 tries are more
>> like 50 * 8).
>
> Yeah same for the mac80211 approach, since we take packets, not retries.
>
>> > Also, are you sure? Do you really not get _any_ TX status?
>>
>> Currently we do get TX status, but there are plans to remove it later on.
>
> That's your choice, but I wouldn't do it. You'll have to support TX
> status when requested, otherwise AP operation won't work, so you need
> the code anyway.

Can you elaborate why?

I'm assuming you mean the removal of
IEEE80211_HW_REPORTS_TX_ACK_STATUS (in the second patch of this
series). Note that it was only added recently, and AP/STA modes seemed
to work fine without it.
>From a look in the code it seems this flag helps with connection
monitoring in STA mode. The other use is determining the current PS
mode when IEEE80211_HW_PS_NULLFUNC_STACK is enabled. These two are
done by HW in wl12xx cards.

Regards,
Arik
