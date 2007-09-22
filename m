Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:21691 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbXIVQdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Sep 2007 12:33:42 -0400
Received: by py-out-1112.google.com with SMTP id u77so2106476pyb
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2007 09:33:41 -0700 (PDT)
Message-ID: <43e72e890709220933i5eea5b85kf365ec5a5038da7f@mail.gmail.com>
Date: Sat, 22 Sep 2007 12:33:41 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: API to regulatory control (2)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1190457155.18521.230.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1190456574.18521.220.camel@johannes.berg>
	 <1190457155.18521.230.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/22/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> So in the first part I covered how information on channel restrictions
> is communicated between the central regulatory control agent and drivers
> and/or mac80211.
>
> This second part is rather short, but important.
>
> Devices that are capable of operating in a wide range of regulatory
> restrictions usually also have country information encoded in their
> EEPROM. I understand that Intel devices will need to make this EEPROM
> information part of their channels list because the firmware rejects
> tuning to other channels, but most devices fully enforce these
> restrictions in software.
>
> Hence, it is necessary that drivers are able to set the regulatory
> domain they think they are operating in. It would probably be possible
> to override by the user, but when the user has just booted it would be
> good to be able to read the EEPROM of a wireless card to set the initial
> operating domain.
>
> For this, we need two exported functions:
>
> void cfg80211_regulatory_set_alpha2(const char *alpha2);
> void cfg80211_regulatory_set_domain(int ieee80211_domain);
>
> These functions, when called, internally look up the value and, if
> found, update each registered wiphy's channels list for the new
> restrictions. They also set the internal domain to the value given
> (well, I suppose the _set_domain function internally looks up an alpha2
> value and calls the other one). Also, it will call the notifier chain I
> talked about earlier so drivers can be notified of the change if
> necessary.
>
> Similarly, userspace can set the alpha2 value through some
> nl80211/configfs API which will also cause the the same updates and
> notifier chain calls.
>
> I think this covers all the public API to regulatory control. Did I miss
> anything? Everything else should be internal.

That's the plan ;) For now I only have support to change regdomain
through configfs though, I have to add support for the driver changing
the regdomain though, which I think should just consists of a loop
over al wiphys and updating their channel/power info. The rare
exception we'd have to deal with is when the user is on a channel
already which is going to be disabled but like we spoke about this --
we can just disable it, I still think we should notify the user but
whatever, this is a pretty rare thing to deal with, we'll figure it
out.

  Luis
