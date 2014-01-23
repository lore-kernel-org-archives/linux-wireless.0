Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39787 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaAWAFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 19:05:09 -0500
Message-ID: <52E05CB1.80308@candelatech.com> (sfid-20140123_010513_296643_4ECA5C9A)
Date: Wed, 22 Jan 2014 16:05:05 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Support tx-hw-crypt with rx-sw-crypt.
References: <1390431296-20568-1-git-send-email-greearb@candelatech.com>  <1390431296-20568-2-git-send-email-greearb@candelatech.com>  (sfid-20140122_235550_068991_E5B7233B) <1390432245.20070.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1390432245.20070.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/22/2014 03:10 PM, Johannes Berg wrote:
> On Wed, 2014-01-22 at 14:54 -0800, greearb@candelatech.com wrote:
> 
>> + * @IEEE80211_KEY_FLAG_SW_RX_CRYPT: This flag indicates hardware will not
>> + *	do any decrypt for received packets, though it may have uploaded
>> + *	the hardware key to be used for encrypting transmitted frames.
> 
> This isn't needed, all you need to do is return 0 from the set_key
> callback in the driver, without programming the key into the device. And
> then ignore tkip key updates for such a key.

I want and need to program the key into the device so that it can do the
encryption for transmit.  But, I need software to do full decryption on
receive.

That is the only way I could get ath10k to do any sort of software crypt,
and in fact, that is the most efficient way to get the features I need
so I might try getting ath9k to support the same mode some day...

I'll be posting ath10k patches to use this soon, but the dark magic
is down in the firmware in this case.

Thanks,
Ben

> 
> johannes
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

