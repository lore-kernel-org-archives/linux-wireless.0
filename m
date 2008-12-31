Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:40536 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbYLaKYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 05:24:38 -0500
Received: by bwz14 with SMTP id 14so18274534bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 31 Dec 2008 02:24:36 -0800 (PST)
Message-ID: <1ba2fa240812310224m15c1f32brb06cc6aa1a607962@mail.gmail.com> (sfid-20081231_112455_268394_65A6B2FE)
Date: Wed, 31 Dec 2008 12:24:35 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH] mac80211: Add 802.11h CSA support
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <18779.17630.122619.462997@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18779.17630.122619.462997@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +       } else {
> +               ieee80211_stop_queues_by_reason(&sdata->local->hw,
> +                                               IEEE80211_QUEUE_STOP_REASON_CSA);
Why to stop the queues before the switching time

> +               ifsta->flags |= IEEE80211_STA_CSA_RECEIVED;
> +               exp = sw_elem->count * (1024 * bss->beacon_int / 1000 * HZ / 1000);
> +               mod_timer(&ifsta->chswitch_timer, jiffies + exp);
What about:
      mod_timer(&ifsta->chswitch_timer, jiffies +
        msecs_to_jiffies(sw_elm->count * local->hw.conf.beacon_int));

> +       }
> +}

Thanks
Tomas
