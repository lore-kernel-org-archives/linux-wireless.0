Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52693 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1KCIFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 04:05:35 -0400
Received: by qabj40 with SMTP id j40so810158qab.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 01:05:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1320306440.3950.0.camel@jlt3.sipsolutions.net>
References: <CAFED-jkVtVFBJfDc-18a+RogAFoTVudS9_POjZHFZ=AtBu1p0g@mail.gmail.com>
	<1320306440.3950.0.camel@jlt3.sipsolutions.net>
Date: Thu, 3 Nov 2011 09:05:34 +0100
Message-ID: <CAFED-j=sP7PSD8yv1U4RA9-NGnjJ9CE5C6qWOQxZ=rzGMdt+2w@mail.gmail.com> (sfid-20111103_090605_846804_630C167D)
Subject: Re: mac80211: UAPSD - EOSP bit seems to be not set when send qos null frame
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/11/3 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2011-11-03 at 08:36 +0100, Janusz Dziedzic wrote:
>> Hello,
>>
>> I have a question connected with UAPSD implementation.
>> Seems, mac80211 always clear EOSP bit in ieee80211_set_qos_hdr() fuction.
>> Is that a problem in mac80211 or this should be handled in different place/way?
>
> It should be set:
>
>        if (qos) {
>                nullfunc->qos_ctrl = cpu_to_le16(tid);
>
>                if (reason == IEEE80211_FRAME_RELEASE_UAPSD)
>                        nullfunc->qos_ctrl |=
>                                cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
>        }
>

Yes, I see this is set correctly before we call ieee80211_set_qos_hdr().
Next ieee80211_set_qos_hdr() fuction seems not care about EOSP bit and
we have this bit cleared before ieee80211_tx() call.


BR
Janusz
