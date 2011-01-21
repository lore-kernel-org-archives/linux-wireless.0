Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52490 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab1AUSBQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 13:01:16 -0500
Received: by ywe10 with SMTP id 10so229345ywe.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 10:01:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295556734.3693.53.camel@jlt3.sipsolutions.net>
References: <1295555306-20005-1-git-send-email-arik@wizery.com> <1295556734.3693.53.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 21 Jan 2011 20:01:00 +0200
Message-ID: <AANLkTinZwZbnzbT2UvOg7PgUsCRAR-+Hx+Je0zgoRYHd@mail.gmail.com>
Subject: Re: [PATCH 1/3] nl80211: allow passing SSID in nl80211_set_bss
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 20, 2011 at 22:52, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> As I also just commented on the corresponding hostapd patch, I'm not
> sure this is sufficient. If this is necessary for probe response
> offloading, I'm tempted to say that we should be honest about it and let
> userspace determine the entire probe response (which will contain the
> correct SSID) since it can be different from the beacon which presumably
> you're now using to generate probe responses.
>

Well the SSID is still needed in its pure form (i.e. not bundled up
inside some skb). The FW needs it in order to decide which probe
requests it will respond to in hidden-SSID mode.
You're talking about adding another set_probe_resp() callback from
hostapd. That makes sense. I'll look into it.

In the meanwhile are there any comments for this portion?

Regards,
Arik
