Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59075 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbcFUUmw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 16:42:52 -0400
Message-ID: <1466538049.18972.5.camel@sipsolutions.net> (sfid-20160621_224258_195563_D5AF4D21)
Subject: Re: [PATCH] mac80211: Encrypt "Group addressed privacy" action
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>, Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Jun 2016 21:40:49 +0200
In-Reply-To: <20160621170120.GA24882@w1.fi> (sfid-20160621_190131_756060_1D067478)
References: <1465969112-2814-1-git-send-email-masashi.honma@gmail.com>
 <20160618091116.GA2972@w1.fi>
 <57673E10.7070706@gmail.com>
 <20160620212529.GA19076@w1.fi>
 <5768DBB6.2060501@gmail.com>
	 <20160621170120.GA24882@w1.fi> (sfid-20160621_190131_756060_1D067478)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> We actually cover (2) for some cases by "accident" since
> ieee80211_rx_h_decrypt() assigns rx->key to rx->sta->gtk[i] if one is
> available. I'm not completely sure this is correct since it applies
> to management frame as well, but that's the way commit
> 897bed8b4320774e56f282cdc1cceb4d77442797 ('mac80211: clean up RX key
> checks') implemented it (Johannes: Could you please take a look
> whether that gtk[] case was really supposed to apply for non-Data
> frames?).
> 

Hm, yeah, that's kinda questionable.

AFAICT we still do the right thing since ieee80211_drop_unencrypted()
contains a check for ieee80211_is_data() and we return in this if
branch, so we never get to the TAINTED check or the actual decrypt.

We could try to just drop unencrypted data frames (that aren't control
port protocol) right here, but it might wreak havoc with the reorder
buffer in case it (erroneously) happens.

johannes
