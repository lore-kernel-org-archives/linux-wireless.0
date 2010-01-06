Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:45899 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab0AFSQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 13:16:58 -0500
Received: by yxe26 with SMTP id 26so16884340yxe.4
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 10:16:56 -0800 (PST)
Message-ID: <4B44D396.3050106@lwfinger.net>
Date: Wed, 06 Jan 2010 12:16:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
References: <1262710858.28653.5.camel@johannes.local>	 <4B442008.2040207@lwfinger.net> <1262775946.9268.109.camel@johannes.local>
In-Reply-To: <1262775946.9268.109.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2010 05:05 AM, Johannes Berg wrote:
> On Tue, 2010-01-05 at 23:30 -0600, Larry Finger wrote:
> 
>> Reauthentication fails with a pop-up to reenter the WPA2 secret as I'm
>> using NetworkManager. I can only reconnect if b43 (and mac80211) are
>> unloaded and reloaded. I pulled the patch and confirmed that proper
>> behavior is returned.
> 
> Ouch.
> 
> I can't seem to reproduce this with hwsim, but it never touches the
> queues.
> 
> I think it may be because I forgot about
> 53623f1a09c7a7d23b74f0f7d93dba0ebde1006b ...
> 
> The patch below is certainly needed, but I'm not entirely sure it'll fix
> your issue, can you give it a try please?
> 
> johannes
> 

This patch seems to fix the problem. I've been running for 5 hours with it, and
no interruption.

Thanks,

Larry

