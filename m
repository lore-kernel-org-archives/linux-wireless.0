Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48078 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab3I3JqK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 05:46:10 -0400
Message-ID: <52494861.8010007@openwrt.org> (sfid-20130930_114614_451264_7B5F3D87)
Date: Mon, 30 Sep 2013 11:46:09 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.12 2/2] mac80211: update sta->last_rx on acked tx frames
References: <1380483574-88667-1-git-send-email-nbd@openwrt.org>  <1380483574-88667-2-git-send-email-nbd@openwrt.org> <1380532248.14467.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1380532248.14467.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-09-30 11:10 AM, Johannes Berg wrote:
> On Sun, 2013-09-29 at 21:39 +0200, Felix Fietkau wrote:
>> When clients are idle for too long, hostapd sends nullfunc frames for
>> probing. When those are acked by the client, the idle time needs to be
>> updated.
>> 
>> To make this work (and to avoid unnecessary probing), update sta->last_rx
>> whenever an ACK was received for a tx packet. Only do this if the flag
>> IEEE80211_HW_REPORTS_TX_ACK_STATUS is set.
> 
> Why that last bit? If we got an ack status, wouldn't it be OK to do
> either way? Or are you saying drivers are lying more often than not
> otherwise?
I added that just in case, some drivers might not be fully reliable wrt.
reporting the ACK status.

- Felix
