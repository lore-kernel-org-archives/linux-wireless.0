Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 63.mail-out.ovh.net ([91.121.185.56]:53906 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752357Ab0EMHJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 03:09:39 -0400
Message-ID: <4BEBA5AF.6070909@free.fr>
Date: Thu, 13 May 2010 09:09:35 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: Add HT IE to IBSS beacons and probe responses.
References: <1273098986-19330-1-git-send-email-benoit.papillault@free.fr> <1273574892.3669.54.camel@jlt3.sipsolutions.net> <4BEB175F.7000001@free.fr> <201005130947.07577.br1@einfach.org>
In-Reply-To: <201005130947.07577.br1@einfach.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 13/05/2010 02:47, Bruno Randolf a écrit :
> On Thursday 13 May 2010 06:02:23 Benoit Papillault wrote:
>>> Also I just noticed that there's a TODO item in rx.c when we receive an
>>> HT frame from a peer we don't know about yet. Not sure what to do there,
>>> but you'll need to look at it.
>>
>> I did some patch in this area in my tree. Basically, the peer STA is
>> created only on beacon/probe response since only those frames contains
>> peer capabilities. Any frames received before is simply ignored.
>
> i think the same applies to non-HT. when we receive a frame from a STA we
> haven't seen a beacon from yet, we just mark the rate at which we received the
> frame and can use that for a reply. later, when we receive a beacon, the rate-
> set is updated. i guess the same can be done for HT and i'd argue that it
> should be done like this in order to be able to communicate even though we
> have not received a beacon from that particular STA yet - there are some
> reasons why the beacon might not have reached us:
>
>   * the STA might have deferred beacon sending for a few intervals as part of
> the normal beacon backoff
>
>   * the beacon might have been lost due to interference
>
>   * or the other STA might be a buggy implementation which doesn't send IBSS
> beacons for a while, like some madwifi versions.
>
> in any case the ability to communicate is more important than a complete rate-
> set...
>
> bruno
>

Hi Bruno,

I understand your concern. It's a bit of chicken egg problem since to 
communicate properly we don't to know the rateset. Requiring beacons 
would have push some pressure on people to fix them, but anyway, I 
understand your concern.

Currently, the HT rateset (MCS) does not seem to be properly populated 
in IBSS (the rate control only mentioned 1 - 54 Mbits rates...). I think 
we need to define a "basic profile" that will be used up to the point we 
receive a beacon from this STA.

I will check that soon.

Regards,
Benoit

