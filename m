Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41263 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0KVGtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 01:49:17 -0500
Received: by wyb28 with SMTP id 28so6659106wyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 21 Nov 2010 22:49:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CE734D9.90103@openwrt.org>
References: <1290203740-57124-1-git-send-email-nbd@openwrt.org>
	<1290203740-57124-2-git-send-email-nbd@openwrt.org>
	<1290203740-57124-3-git-send-email-nbd@openwrt.org>
	<1290203740-57124-4-git-send-email-nbd@openwrt.org>
	<4CE734D9.90103@openwrt.org>
Date: Mon, 22 Nov 2010 12:19:10 +0530
Message-ID: <AANLkTikCn2GjLxfQZLw9Tj8cyH_bgGpEDiGpKVg0faht@mail.gmail.com>
Subject: Re: [PATCH 4/4] mac80211: reduce the probe response timeout after
 beacon loss
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 20, 2010 at 8:09 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-11-19 10:55 PM, Felix Fietkau wrote:
>> Waiting for 500 ms after sending a probe request seems a bit excessive,
>> especially when doing 5 attempts. If the connection is bad enough to make
>> multiple requests time out, then user space should try to quickly find a
>> new AP.
This might improve fail over roaming to a small extent but  as per the
commit id d1c5091f23fed5195271e2849f89017d3a126521 it was mentioned
this might affect robustness against 'slow AP's'

> Hmm, don't merge this patch yet, it can cause background scans to
> trigger reconnects.
>
I am not sure  how this affects background scan.bgscan will be enabled
even before the beacon loss and it is based on RSSI(please correct me
if I am wrong).
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
