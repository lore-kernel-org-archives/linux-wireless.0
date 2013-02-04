Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:64010 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab3BDRnw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:43:52 -0500
Received: by mail-ob0-f182.google.com with SMTP id va7so6564563obc.27
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2013 09:43:51 -0800 (PST)
Message-ID: <510FF354.7000208@lwfinger.net> (sfid-20130204_184355_720994_66E0B51A)
Date: Mon, 04 Feb 2013 11:43:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: mcgrof@do-not-panic.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Memory leak in cfg80211
References: <510D9E71.2080300@lwfinger.net>  (sfid-20130203_001709_849515_E1CDB041) <1359998652.17993.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359998652.17993.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/04/2013 11:24 AM, Johannes Berg wrote:

Johannes,

>
> Yeah. The more interesting part (I think) is reg_todo(), which seems it
> really is the __regulatory_hint() function, which gets inlined.
>
> Were you able to reproduce this? I don't think I can since my devices
> (Intel) don't use wiphy->regd. If you can, maybe you could try to
> dump_stack() with the pointer every time wiphy->regd gets assigned, and
> also print the old value.

Yes, it is reproducible. I get one for every load of ath9k_htc. Other drivers 
may also fail - that happens to be the device I'm using now.

> To me, this looks like wiphy->regd gets overwritten without freeing the
> old value, but I don't see what recent (since 3.7) change should have
> caused this to change behaviour. Luis?

I'll set that up and report back.

Larry


