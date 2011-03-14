Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1CNNGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 09:06:01 -0400
Subject: Re: iwl3945: microcode SW error log decode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>
In-Reply-To: <1300083494.6654.1.camel@dcbw.foobar.com>
References: <1300083494.6654.1.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Mar 2011 14:05:58 +0100
Message-ID: <1300107958.3802.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-14 at 01:18 -0500, Dan Williams wrote:

> that has this error log in it.  Is that enough to figure out where
> things have gone wrong in the firmware?
> 
> [ 1286.750258] iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
> [ 1286.750268] iwl3945 0000:03:00.0: Loaded firmware version: 15.32.2.9
> [ 1286.750304] iwl3945 0000:03:00.0: Start IWL Error Log Dump:
> [ 1286.750309] iwl3945 0000:03:00.0: Status: 0x0002A2E4, count: 1
> [ 1286.750314] iwl3945 0000:03:00.0: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
> [ 1286.750543] iwl3945 0000:03:00.0: SYSASSERT     (0x5) 0001680217 0x008B6 0x13756 0x00320 0x00000 764

IIRC, it's quite hard for 3945. But I might be wrong. What's the kernel
version here?

> It appears like the configuration that gets sent to wpa_supplicant is
> TKIP + WPA2 which seems kinda wrong, doesn't WPA2/RSN require CCMP?

That seems fine. WPA2 certification requires the ability to do CCMP I
think, but RSN can also be set up to use TKIP, say if you set up
WPA/WPA2 on the network. WPA is just a pre-RSN (WPA2) method of
advertising pretty much the same thing.

johannes

