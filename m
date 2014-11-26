Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:61537 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaKZLNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 06:13:37 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so3361902wgg.35
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 03:13:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416754941-4439-2-git-send-email-arik@wizery.com>
References: <1416754941-4439-1-git-send-email-arik@wizery.com> <1416754941-4439-2-git-send-email-arik@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Nov 2014 13:13:20 +0200
Message-ID: <CA+XVXfdAmxXvgZbhS1gWaM8XZ59PdC-WA-33kv=8MdVKUwOREw@mail.gmail.com> (sfid-20141126_121343_012241_F2738213)
Subject: Re: [PATCH v3 2/3] cfg80211: allow wiphy specific regdomain management
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 23, 2014 at 5:02 PM, Arik Nemtsov <arik@wizery.com> wrote:

> +int regulatory_set_wiphy_regd_rtnl(struct wiphy *wiphy,
> +                                  struct ieee80211_regdomain *rd)
> +{

You gave us Reviewed-by, and it's appreciated, but unfortunately we
have to change the API a bit.

It appears we can't take the RTNL from within a driver safely - on
driver unload, we might have a work-item that needs the RTNL pending,
and the driver unload itself already acquires RTNL.
So we'll modify the code a bit to set a wiphy->requested_regd and do
the actual work inside reg_todo.

We'll resubmit shortly.

Arik
