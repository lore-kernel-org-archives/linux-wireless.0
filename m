Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:48976 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2DLHlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 03:41:51 -0400
Message-ID: <4F868732.1030401@etit.tu-chemnitz.de> (sfid-20120412_094155_441467_D79427D6)
Date: Thu, 12 Apr 2012 09:41:38 +0200
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	javier@cozybit.com, linux-wireless@vger.kernel.org,
	henry@logout.com,
	"greenmesh@lists.osll.spb.ru" <greenmesh@lists.osll.spb.ru>
Subject: Re: [Greenmesh] [ath9k] mesh powersave hardware sleep + wakeup
References: <4F630AEA.10703@etit.tu-chemnitz.de>  <20120316204547.GG18861@tux> <4F63BA31.1080608@etit.tu-chemnitz.de>  <4F856449.3000804@etit.tu-chemnitz.de> <1334203508.3788.12.camel@jlt3.sipsolutions.net>
In-Reply-To: <1334203508.3788.12.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/12/12 06:05, Johannes Berg wrote:
> On Wed, 2012-04-11 at 13:00 +0200, Marco Porsch wrote:
>
>> Thus, I think we will need an additional/extended interface
>> mac80211<->driver here.
>>
>> I see two possibilities:
>> a) request the next wakeup time from mac80211 each time the hardware is
>> put to sleep (e.g. from ath9k_ps_restore).
>> b) give a whole list of periodic wakeup events of all vif to the driver.
>> Then the driver is supposed to sort out the closest event.
>>
>> What would be the better approach for such an interface? Or maybe a
>> completely different idea?
>
> What time units would that be in, and how could you correlate them?

I did not take an exhaustive overview over all possible drivers.
But as the current mac80211<->driver interface carries only beacon 
interval (in TU) and DTIM period, that should be a good starting point.
ath9k additionally relies on the neighbors address to check whether it 
can resume sleep after receiving an expected beacon (see setting of 
'is_mybeacon' in ath_rx_tasklet).

Concerning correlation, in mesh mode we recently have t_offset (in TSF 
increments) stored in sta_info and in client mode the drivers' 
synchronised TSF should be the reference (but I am not quite sure what 
happens when one client is associated to multiple AP).

Regards,
Marco
