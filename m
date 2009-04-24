Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62343 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZDXFhx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 01:37:53 -0400
Received: by fxm2 with SMTP id 2so915096fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 22:37:51 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: add driver ops wrappers
References: <1240505572.30082.233.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 24 Apr 2009 08:37:49 +0300
In-Reply-To: <1240505572.30082.233.camel@johannes.local> (Johannes Berg's message of "Thu\, 23 Apr 2009 18\:52\:52 +0200")
Message-ID: <87y6tqd32q.fsf@litku.valot.fi> (sfid-20090424_073757_077345_ADEDB910)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> In order to later add tracing or verifications to the driver
> calls mac80211 makes, this patch adds static inline wrappers
> for all operations.
>
> All calls are now written as
>
> 	drv_<op>(local, ...);
>
> instead of
>
> 	local->ops-><op>(&local->hw, ...);
>
> Where necessary, the wrappers also do existence checking and
> return default values as appropriate.

Also grepping is easier this way. I think this is a good change to have,
especially I'm interested of tracing driver calls. Until now I have
added debug messages to all drivers I maintain.

But I'm just concerned about the drv prefix, with very bad luck it might
create conflicts with some other component. What about using
ieee80211_drv, for example?

-- 
Kalle Valo
