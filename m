Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37509 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381Ab1AMUNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 15:13:37 -0500
Message-ID: <4D2F5CEE.2000108@candelatech.com>
Date: Thu, 13 Jan 2011 12:13:34 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Question on deauth, reason 4, for hostapd.
References: <4D2F56DB.50507@candelatech.com>
In-Reply-To: <4D2F56DB.50507@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/13/2011 11:47 AM, Ben Greear wrote:
> I'm trying to figure out why my stations sometimes deauth for
> reason 4 (which I understand to mean 'inactivity').
>
> I instrumented the hostapd logs a bit, and I see this the output
> below. Basically, there appears to be no inactivity problems, and
> as far as I can tell, hostapd isn't forcing the deauth, but is rather
> dealing with it from somewhere else.

Ahh, seems the client side is giving up.

sta6: detected beacon loss from AP - sending probe request
sta7: detected beacon loss from AP - sending probe request
sta8: detected beacon loss from AP - sending probe request
ieee80211 wiphy0: sta10: No ack for nullfunc frame to AP 00:99:99:99:99:01, try 1
net_ratelimit: 200 callbacks suppressed
wlan0: detected beacon loss from AP - sending probe request
sta0: detected beacon loss from AP - sending probe request
sta1: detected beacon loss from AP - sending probe request
sta2: detected beacon loss from AP - sending probe request
sta3: detected beacon loss from AP - sending probe request
sta4: detected beacon loss from AP - sending probe request
sta5: detected beacon loss from AP - sending probe request
sta6: detected beacon loss from AP - sending probe request
sta7: detected beacon loss from AP - sending probe request
sta8: detected beacon loss from AP - sending probe request
ieee80211 wiphy0: sta10: Failed to send nullfunc to AP 00:99:99:99:99:01 after 500ms, disconnecting.
ieee80211 wiphy0: Removed STA 00:99:99:99:99:01
ieee80211 wiphy0: Destroyed STA 00:99:99:99:99:01
start_sw_scan: running-other-vifs: 0  running-station-vifs: 70, associated-stations: 69 scanning current channel: 2437 MHz
sta10: authenticate with 00:99:99:99:99:01 (try 1)
sta10: authenticated
sta10: associate with 00:99:99:99:99:01 (try 1)
sta10: RX ReassocResp from 00:99:99:99:99:01 (capab=0x411 status=0 aid=60)
sta10: associated
ieee80211 wiphy0: Allocated STA 00:99:99:99:99:01
ieee80211 wiphy0: Inserted STA 00:99:99:99:99:01
net_ratelimit: 76 callbacks suppressed
wlan0: detected beacon loss from AP - sending probe request
sta0: detected beacon loss from AP - sending probe request

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

