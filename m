Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54465 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab1AGSHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 13:07:14 -0500
Message-ID: <4D27564E.1030008@candelatech.com>
Date: Fri, 07 Jan 2011 10:07:10 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Chaoxing Lin <CLin@3eti.com>
CC: "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>
Subject: Re: hostapd hangs on quit, multi-BSSID scenario
References: <BD54DDEB2546894FAB0731EA7B0EDF8D05715D85@RockMX01.rock.corp> <4D275236.4040202@candelatech.com> <BD54DDEB2546894FAB0731EA7B0EDF8D05715D9E@RockMX01.rock.corp>
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D05715D9E@RockMX01.rock.corp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2011 09:58 AM, Chaoxing Lin wrote:
> 1. I don't know how to use GDB. Consider me entry level developer.

You need to learn how to use gdb..it will be well worth your time
if you plan to ever move beyond entry-level-developer.

Something as simple as:

gdb [hostapd-binary] [pid-of-hostapd-process]

Then inside of gdb:

bt

You might also try 'strace'.

> 2. It should not be related the change I made on ath9k. The reasons are
> 	a. My change is simple, linux/drivers/net/wireless/ath/ath9k/ath9k.h: change ATH_BCBUF from 4 to 12
> 	b. Without my change, driver accepts up to 3 extra BSSID. But hostapd still hangs on quit. Hostapd quits well if there only one extra BSSID.
>
> This problem is 100% reproducible. I guess it would be quite easy for the original hostapd developer to fix it.

Heh, maybe so..but if you want it fixed fast, you might need to put in some
extra debugging effort.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
