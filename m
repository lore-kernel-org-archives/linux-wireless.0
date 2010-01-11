Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:49757 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0AKQDi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 11:03:38 -0500
Received: by iwn35 with SMTP id 35so14856093iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2010 08:03:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4ABB54.7030600@openwrt.org>
References: <4B4ABB54.7030600@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 11 Jan 2010 08:03:18 -0800
Message-ID: <43e72e891001110803x6ecd3dc4m267dd809d640a522@mail.gmail.com>
Subject: Re: mac80211: fix queue selection for data frames on monitor
	interfaces
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 10, 2010 at 9:47 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> When ieee80211_monitor_select_queue encounters data frames, it selects
> the WMM AC based on skb->priority and assumes that skb->priority
> contains a valid 802.1d tag. However this assumption is incorrect, since
> ieee80211_select_queue has not been called at this point.
> If skb->priority > 7, an array overrun occurs, which could lead to
> invalid values, resulting in crashes in the tx path.
> Fix this by setting skb->priority based on the 802.11 header for QoS
> frames and using the default AC for all non-QoS frames.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Its unclear whether or not this is a stable fix. It fixes a crash but
does this depend on a patch added recently which is not in stable yet?

  Luis
