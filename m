Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:28794 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbZDPK6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 06:58:04 -0400
Received: by fk-out-0910.google.com with SMTP id 18so149639fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 03:58:03 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/3 v2] mac80211: disable powersave if pm_qos asks for low latency
References: <20090415171046.336006351@sipsolutions.net>
	<20090415171633.489000512@sipsolutions.net>
	<1239824330.29769.5.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 13:58:01 +0300
In-Reply-To: <1239824330.29769.5.camel@johannes.local> (Johannes Berg's message of "Wed\, 15 Apr 2009 21\:38\:50 +0200")
Message-ID: <87myag987a.fsf@litku.valot.fi> (sfid-20090416_125811_123464_4D7E940D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> When an application asks for a latency lower than the beacon interval
> there's nothing we can do -- we need to stay awake and not have the
> AP buffer frames for us. Add code to automatically calculate this
> constraint in mac80211 so drivers need not concern themselves with it.

I like this! 

This is a good start, from this can start improving this. We need to
take into account for example DTIM count, U-APSD and what not. But
that's all for the future.

-- 
Kalle Valo
