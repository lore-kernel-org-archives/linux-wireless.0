Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18]:61832 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYLATKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 14:10:11 -0500
Received: by gxk11 with SMTP id 11so69367gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 11:10:09 -0800 (PST)
Message-ID: <43e72e890812011110o4aeb8334k6702f64a1867e1f7@mail.gmail.com> (sfid-20081201_201015_818215_6A014B1B)
Date: Mon, 1 Dec 2008 11:10:05 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: [RFC v3 2/4] mac80211: implement dynamic power save
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227901784-5325-3-git-send-email-kalle.valo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	 <1227901784-5325-3-git-send-email-kalle.valo@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 28, 2008 at 11:49 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> This patch implements dynamic power save for mac80211. Basically it
> means enabling power save mode after an idle period. Implementing it
> dynamically gives a good compromise of low power consumption and low
> latency. Some hardware have support for this in firmware, but some
> require the host to do it.
>
> The dynamic power save is implemented by adding an timeout to
> ieee80211_subif_start_xmit(). The timeout can be enabled from user space
> with Wireless Extensions. For example, the command below enables the
> dynamic power save and sets the time timeout to 500 ms:
>
> iwconfig wlan0 power timeout 500m
>
> Thanks to Johannes Berg for the help with the design.

Might be worth noting that when dynamic power save is enabled for
mac80211 that this will only work right now for devices which handle
power save in firmware as power save is not yet implemented in
mac80211.

Also that by default this is left disabled and the heuristics of how
and exactly how to enable this will be left to userspace.

  Luis
