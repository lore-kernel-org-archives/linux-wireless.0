Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50916 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbaAWR0S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 12:26:18 -0500
Message-ID: <52E150B5.6050605@candelatech.com> (sfid-20140123_182622_435557_7740ED5D)
Date: Thu, 23 Jan 2014 09:26:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Support tx-hw-crypt with rx-sw-crypt.
References: <1390431296-20568-1-git-send-email-greearb@candelatech.com> 	  <1390431296-20568-2-git-send-email-greearb@candelatech.com> 	  (sfid-20140122_235550_068991_E5B7233B) <1390432245.20070.0.camel@jlt4.sipsolutions.net> 	 <52E05CB1.80308@candelatech.com>  <1390465191.4142.2.camel@jlt4.sipsolutions.net>  <52E12C90.3080509@candelatech.com> <1390488928.4142.17.camel@jlt4.sipsolutions.net>
In-Reply-To: <1390488928.4142.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2014 06:55 AM, Johannes Berg wrote:
> On Thu, 2014-01-23 at 06:52 -0800, Ben Greear wrote:
> 
>> The ieee80211_tkip_decrypt_data method is explicitly checking if the key is uploaded to hardware.
> 
> It is, but only for calling drv_update_tkip_key(), which you can make
> the driver ignore.
> 
>> I need it to think that it is not uploaded to hardware as far as that check
>> is concerned, otherwise packets will not decrypt properly.
> 
> I don't believe this is true. The stack was always designed so that if
> you didn't decrypt the packet, you just don't set the flags indicating
> it was decrypted and it'll be decrypted in software.

Ok, I see now.  I must have been having some other random issue when
I made that change and saw (more) success.

I disabled it from my now-working code and it continues to work.

What's more, ath10k does not even implement that method, so it was
not doing anything anyway.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

