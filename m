Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:30512 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752334AbXFTQdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 12:33:10 -0400
Message-ID: <46796FCB.9090300@linux.intel.com>
Date: Wed, 20 Jun 2007 11:19:55 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Hong Liu <hong.liu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [patch]mac80211: add support for iwlist channel
References: <1182156425.15928.7.camel@napa-sdv1.sh.intel.com>	<20070619105024.3c6c68e3@griffin.suse.cz>	<1182305425.19178.12.camel@napa-sdv1.sh.intel.com>	<20070620115559.301e10eb@griffin.suse.cz>	<4679672D.4060503@linux.intel.com> <20070620182558.47871535@griffin.suse.cz>
In-Reply-To: <20070620182558.47871535@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Wed, 20 Jun 2007 10:43:09 -0700, James Ketrenos wrote:
>> [...]
>> /**
>>  * enum ieee80211_channel_flags - Channel flag bit values
>>  * @IEEE80211_CHAN_W_TUNE: Hardware can tune to this channel
>>  * @IEEE80211_CHAN_W_ACTIVE: Channel can be used for active scanning
>>  * @IEEE80211_CHAN_W_IBSS: Hardware can act as IBSS Master
>>  * @IEEE80211_CHAN_W_RADAR: Radar spectrum enforcement applies
>>  * @IEEE80211_CHAN_W_TX_ALLOWED: Tx is allowed
> 
> Looks good, except...
> 
>> [...]
>>  * A channel without the TX_ALLOWED bit set *can not* be used
>>  * for any type of transmission and can only be used for passive
>>  * listening.  This is useful for performing network audits.
> 
> I don't find this useful. The stack isn't aware of anything like this.
> Do you plan to add a support for this flag? Also, cfg80211/nl80211
> would need to be taught of it.

If its not useful for anyone else, we can have it just in iwlwifi.  
I don't know if any other hardware supports tuning to channels they 
can't transmit on.

I have personally found it very useful here when using my laptop to 
troubleshoot other wireless issues in geographies where I can't 
transmit -- but I can sniff the packets to tell people what to fix.

For now, since nothing else in the stack can do anything with it,
I'd just assume yank it.  I don't have the time to implement it all
in right now.

Is there any mechanism for documenting where we would like things
to eventually go?  A "future" tag we can stick on things (in the
documentation, etc.)?

James

> 
> Thanks,
> 
>  Jiri
> 
