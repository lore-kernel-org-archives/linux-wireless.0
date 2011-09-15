Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47294 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1IOJdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 05:33:52 -0400
Received: by iaqq3 with SMTP id q3so1006716iaq.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 02:33:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316078452.3992.6.camel@jlt3.sipsolutions.net>
References: <1316077625-20014-1-git-send-email-eliad@wizery.com>
	<1316078452.3992.6.camel@jlt3.sipsolutions.net>
Date: Thu, 15 Sep 2011 12:33:51 +0300
Message-ID: <CAB3XZEfjRHzFebyQU5y4qY=6q9ObDS2WQKXnJGwjDKmv3rNr7g@mail.gmail.com> (sfid-20110915_113355_252865_563FFB95)
Subject: Re: [PATCH 1/2] wl12xx: remove TIM ie from probe response
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 15, 2011 at 12:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-09-15 at 12:07 +0300, Eliad Peller wrote:
>> wl12xx uses the beacon as the probe response template.
>> However, the beacon includes a TIM ie, which shouldn't
>> exist in the probe response.
>>
>> Delete it from the skb before configuring the probe
>> response template.
>
> Are you sure all this is a good thing instead of getting the right info
> from hostapd/wpa_s like for ath6kl? (Yeah, I know that's still
> different, but ...)
>
you're right.
but i guess we can start with easily fixing the current flow, and
later on also doing it right :)

thanks,
Eliad.
