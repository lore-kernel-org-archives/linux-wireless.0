Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53626 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1AaLt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:49:57 -0500
Received: by yxt3 with SMTP id 3so1921698yxt.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 03:49:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296473043.3812.10.camel@jlt3.sipsolutions.net>
References: <1296472589-26401-1-git-send-email-arik@wizery.com>
 <1296472589-26401-7-git-send-email-arik@wizery.com> <1296473043.3812.10.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 31 Jan 2011 13:49:41 +0200
Message-ID: <AANLkTin9vOQJqDJezzBMjjRyGNDYGEwOwgT_aFk2NBYD@mail.gmail.com>
Subject: Re: [PATCH v2 06/10] mac80211: add HW flag for disabling auto link-PS
 in AP mode
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 31, 2011 at 13:24, Johannes Berg <johannes@sipsolutions.net> wrote:
> It'd be nicer if you could separate out mac80211 patches, but then Luca
> needs to hold off merging until John picked up the mac80211 patch.

Yea that would complicate matters a bit. Does the ordering of the
patches bother you?

>
>> + * @IEEE80211_HW_AP_LINK_PS: When operating in AP mode the device
>> + *   autonomously manages the PS status of connected stations. When
>> + *   this flag is set mac80211 will not trigger PS mode for connected
>> + *   stations based on the PM bit of incoming frames.
>> + *   Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
>> + *   the PS mode of connected stations.
>
> You just renamed it.

Yea thanks for that.

>
> Also, come to think of it, the ieee80211_sta_block_awake will not be
> effective I think? Or will it?

Haven't noticed any adverse effects. ap_sta_ps_end() still checks if
the station is blocked before delivering queued packets.

Also is should be pretty hard to find a driver that uses both mechanisms.
If it wants to block a station from waking up, it can simply not call
ieee80211_sta_ps_transition().

Should work though.

Arik
