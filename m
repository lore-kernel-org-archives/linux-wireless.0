Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42995 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab2FYG53 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 02:57:29 -0400
Message-ID: <4FE80BD8.4090904@tieto.com> (sfid-20120625_085732_766325_2EF4CBA1)
Date: Mon, 25 Jun 2012 08:57:28 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFCv2 10/13] cfg80211: set initial monitor channel
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>  <1340172859-18146-11-git-send-email-michal.kazior@tieto.com> <1340290665.4489.33.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340290665.4489.33.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:
>> Implements behaviour seen in mac80211. A running
>> monitor always has a channel - even before
>> .set_channel. This way we won't break current
>> behaviour.
>
> I'm a little doubtful about this. Currently, mac80211 will keep the
> channel if you set it on say wlan0, your monitor iface gets the same
> channel. Then if you remove wlan0, you still have the same channel, but
> it seems here this is different now? I'm not sure it matters much, but
> it's worth thinking about? Or am I totally misunderstanding this now?

Right. It's not the exact same behaviour. It only guarantees a channel 
is always set in monitor mode. We could maybe set the last 
monitor-mode-channel seen when starting up monitor-mode again. Would 
that be okay?


-- 
Pozdrawiam / Best regards, Michal Kazior.
