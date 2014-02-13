Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaBMRYI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 12:24:08 -0500
Message-ID: <1392310868.18472.11.camel@dcbw.local> (sfid-20140213_182412_214271_D79D7F7F)
Subject: Re: libertas: probe responses with zero length SSID cause scan
 result loss
From: Dan Williams <dcbw@redhat.com>
To: James Cameron <quozl@laptop.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Feb 2014 11:01:08 -0600
In-Reply-To: <20140211063329.GO5487@us.netrek.org>
References: <20140211063329.GO5487@us.netrek.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-11 at 17:33 +1100, James Cameron wrote:
> G'day,
> 
> I'd appreciate a sanity check, as I'm not sure what I am doing.
> 
> We saw for years that scan results for an OLPC XO-1 laptop would be
> unreliable in large groups.  APs would not be easily found.  We
> presumed other causes until recently.
> 
> Using monitor mode on another computer, and "iwlist eth0 scan" on the
> XO-1, I found probe responses from an AP, and ACKs from the host to
> the AP, but the output omitted the AP.
> 
> Further, the AP would be missing if there was a probe response from
> another XO-1 running mesh, and an ACK from the host to that XO-1.
> 
> Enabling debugging, lbs_ret_scan was reporting "scan response: invalid
> IE fmt" because the probe response had a zero length SSID IE.
> 
> Is a zero length SSID IE valid?  (We can't change the wireless firmware
> at this stage.)

I think technically a zero-length IE would be valid, but I'm not sure
about a zero-length *SSID* IE.  Is that zero length SSID IE coming from
an AP, or from an XO?

If the scan was a passive scan, then a zero-length SSID IE *would* be
valid, since the passive scans usually just listen for beacons, and
hidden APs wouldn't report a real SSID.  So perhaps what's happening
here is if there is a hidden AP, the firmware sometimes gets the beacon
from the AP before the AP responds to the XO's probe request?

In any case, I think the patch is OK.

Dan

> Background data and dmesg fragments:
> http://dev.laptop.org/ticket/12757
> 
> Patch being tested (lacks signoff and any review):
> http://dev.laptop.org/git/olpc-kernel/commit/?h=x86-3.3&id=e98f01abce522fb70a3852b23b62205244ef69b8
> 


