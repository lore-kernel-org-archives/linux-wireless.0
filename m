Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaAWIT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 03:19:56 -0500
Message-ID: <1390465191.4142.2.camel@jlt4.sipsolutions.net> (sfid-20140123_091959_888693_9A1F987C)
Subject: Re: [PATCH 2/2] mac80211: Support tx-hw-crypt with rx-sw-crypt.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 23 Jan 2014 09:19:51 +0100
In-Reply-To: <52E05CB1.80308@candelatech.com>
References: <1390431296-20568-1-git-send-email-greearb@candelatech.com>
	  <1390431296-20568-2-git-send-email-greearb@candelatech.com>
	  (sfid-20140122_235550_068991_E5B7233B) <1390432245.20070.0.camel@jlt4.sipsolutions.net>
	 <52E05CB1.80308@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 16:05 -0800, Ben Greear wrote:

> >> + * @IEEE80211_KEY_FLAG_SW_RX_CRYPT: This flag indicates hardware will not
> >> + *	do any decrypt for received packets, though it may have uploaded
> >> + *	the hardware key to be used for encrypting transmitted frames.
> > 
> > This isn't needed, all you need to do is return 0 from the set_key
> > callback in the driver, without programming the key into the device. And
> > then ignore tkip key updates for such a key.
> 
> I want and need to program the key into the device so that it can do the
> encryption for transmit.  But, I need software to do full decryption on
> receive.

Ok so the "without programming the key into the device" part was iwlwifi
specific (on TX the key is given explicitly with that device.) However,
the same still applies - just replace that by "without enabling it for
RX" or so.

> That is the only way I could get ath10k to do any sort of software crypt,
> and in fact, that is the most efficient way to get the features I need
> so I might try getting ath9k to support the same mode some day...
> 
> I'll be posting ath10k patches to use this soon, but the dark magic
> is down in the firmware in this case.

Ok, whatever, what I'm saying is that mac80211 doesn't care about
whether you enabled the key for RX or not if you return 0 from
set_key(). All it cares about it that if you return 0 the key must be
available for TX. You therefore don't need to make any mac80211 changes.

johannes

