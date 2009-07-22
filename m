Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:53690 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZGVOop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 10:44:45 -0400
Received: by fxm18 with SMTP id 18so233093fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 07:44:44 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: reinette.chatre@intel.com,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: wireless-testing regression: iwl3945 scan fails
References: <87k521s2wa.fsf@litku.valot.fi>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Jul 2009 17:44:40 +0300
In-Reply-To: <87k521s2wa.fsf@litku.valot.fi> (Kalle Valo's message of "Wed\, 22 Jul 2009 08\:27\:49 +0300")
Message-ID: <87fxcosron.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> Good morning,
>
> I just upgraded to rc3-wl (commit 225b6807) and my iwl3945 doesn't work
> anymore, even scan fails. I don't have time to investigate this right
> now, but I'll try to find some time during the evening.

I have looked at this now a bit and I don't think this is an iwl3945
problem. Scanning seems to stall in some situations and iwl3945 doesn't
even receive the scan command. 

Here's an example what's happening with wpa_supplicant from debian
unstable:

$ sudo ifup wlan0

[  104.468073] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
[  104.533234] iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
[  104.612049] phy0: device now idle
[  104.613091] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  106.968392] phy0: device no longer idle - scanning
[  109.561397] phy0: device now idle
[  109.563737] wlan0: deauthenticating by local choice (reason=3)
[  109.563743] phy0: device no longer idle - in use

[waited a while] 

$ sudo iwlist wlan0 scan
wlan0     Interface doesn't support scanning : Device or resource busy

$ sudo iwlist wlan0 scan
wlan0     Interface doesn't support scanning : Device or resource busy

$ sudo wpa_action wlan0 stop

[  191.649653] wlan0: deauthenticating by local choice (reason=3)
[  191.697619] phy0: device now idle

Also I have been able to reproduce the problem once with iw. For some
strange reason I have had to reboot my laptop to reproduce this,
unloading all wireless related modules (expect rfkill which I can't
unload due to dependencies) is not enough.

-- 
Kalle Valo
