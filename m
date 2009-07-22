Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbZGVPzb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 11:55:31 -0400
Subject: Re: wireless-testing regression: iwl3945 scan fails
From: reinette chatre <reinette.chatre@intel.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <87fxcosron.fsf@litku.valot.fi>
References: <87k521s2wa.fsf@litku.valot.fi>  <87fxcosron.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 08:55:21 -0700
Message-Id: <1248278121.17896.2728.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Wed, 2009-07-22 at 07:44 -0700, Kalle Valo wrote:
> Kalle Valo <kalle.valo@iki.fi> writes:
> 
> > Good morning,
> >
> > I just upgraded to rc3-wl (commit 225b6807) and my iwl3945 doesn't work
> > anymore, even scan fails. I don't have time to investigate this right
> > now, but I'll try to find some time during the evening.
> 
> I have looked at this now a bit and I don't think this is an iwl3945
> problem. Scanning seems to stall in some situations and iwl3945 doesn't
> even receive the scan command. 

The patches we sent recently did undergo testing under various scenarios
using wpa_supplicant. We have not done this testing after the
2.6.31-rc3-wl merge (yesterday) though. I just did a quick test on my
3945 using iwconfig to associate and it was able to do so on A and G
bands. Looks like I need to do some wpa_supplicant testing.

> 
> Here's an example what's happening with wpa_supplicant from debian
> unstable:
> 
> $ sudo ifup wlan0
> 
> [  104.468073] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
> [  104.533234] iwl3945 0000:03:00.0: loaded firmware version 15.32.2.9
> [  104.612049] phy0: device now idle
> [  104.613091] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  106.968392] phy0: device no longer idle - scanning
> [  109.561397] phy0: device now idle
> [  109.563737] wlan0: deauthenticating by local choice (reason=3)
> [  109.563743] phy0: device no longer idle - in use
> 
> [waited a while] 
> 
> $ sudo iwlist wlan0 scan
> wlan0     Interface doesn't support scanning : Device or resource busy
> 
> $ sudo iwlist wlan0 scan
> wlan0     Interface doesn't support scanning : Device or resource busy
> 
> $ sudo wpa_action wlan0 stop
> 
> [  191.649653] wlan0: deauthenticating by local choice (reason=3)
> [  191.697619] phy0: device now idle
> 
> Also I have been able to reproduce the problem once with iw. For some
> strange reason I have had to reboot my laptop to reproduce this,
> unloading all wireless related modules (expect rfkill which I can't
> unload due to dependencies) is not enough.

Are you saying that this problem occurs always with wpa_supplicant and
sometimes with iw?

Reinette


