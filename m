Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:59782 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYGWQvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 12:51:32 -0400
Message-ID: <48876190.7020502@monom.org> (sfid-20080723_185135_620720_6CB22764)
Date: Wed, 23 Jul 2008 18:51:28 +0200
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rt2x00mac: In error case stop netdev queue, free skb
 and return NETDEV_TX_OK
References: <1216805279-19149-1-git-send-email-wagi@monom.org> <200807231822.04895.IvDoorn@gmail.com> <48875EE5.3060303@monom.org> <200807231902.47026.IvDoorn@gmail.com>
In-Reply-To: <200807231902.47026.IvDoorn@gmail.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> On Wednesday 23 July 2008, Daniel Wagner wrote:
>> Ivo van Doorn wrote:
>>> On Wednesday 23 July 2008, Daniel Wagner wrote:
>>>> It is not allowed to use NETDEV_TX_BUSY in tx path anymore.
>>> If not, then why is mac80211 checking and handling the return value
>>> and is tx() still a function returning an int. mac80211 is actually requeueing
>>> the frame when the hardware fails to send it, so why should that be completely blocked?
>> Well, I might be completely wrong here. I got this idea from following mail on netdev:
>> http://marc.info/?l=linux-wireless&m=121025252321824&w=2
> 
> Hmm, well Johannes just indicated that the code I mentioned earlier will be removed,
> in that case I am fine with a patch like this, however with a few adjustments. ;)

Sure :)

> Please make it a decent -E... error code then. Looks far less obscure then -1.

No problemo.

> Also could you make the exit code with
> 
> 	ieee80211_stop_queue(rt2x00dev->hw, qid);
> 	dev_kfree_skb_any(skb);
> 	return NETDEV_TX_OK;
> 
> and exit_fail goto?

yes

daniel

