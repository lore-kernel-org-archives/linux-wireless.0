Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55146 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2DMSHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 14:07:09 -0400
Received: by wibhj6 with SMTP id hj6so6765866wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Apr 2012 11:07:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Harshal Chhaya <harshal@gmail.com>
Subject: Re: carl9170: Lots of 'device restart'
Date: Fri, 13 Apr 2012 20:07:02 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <CAJ8GFOgGbZs=Zkomuf3q65vfQJnR47p894AjOeuXKy58NA0tKQ@mail.gmail.com>
In-Reply-To: <CAJ8GFOgGbZs=Zkomuf3q65vfQJnR47p894AjOeuXKy58NA0tKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201204132007.02678.chunkeey@googlemail.com> (sfid-20120413_200715_214414_D4C38967)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 13 April 2012 18:36:10 Harshal Chhaya wrote:
> Here is the console log from an instance when my carl9170-based AP
> was stuck in a bad state. The "Dhcp:" messages are from my user-level
> application and are merely informative.
> 
> Any ideas on what could have caused so many "device restarts"? The AP
> was unusable for ~10 min and fixed itself after that. Is the failed
> channel change an indication?
---
"usb 1-1: restart device (4)"

4 = CARL9170_RR_STUCK_TX
[No frames are going out - even though we tried really hard]
---
channel change: 2437 -> 2437 failed (2).

2 = Noisefoor calibration failed
[This is an QCA term, I think it just means that the NF never dropped
to a sensible "normal" background levels... so according to the PHY,
the medium is busy]
---
phy1: invalid plcp cck rate (0).

this is usually the fallout from a non-wifi devices on the same channel.
---

The driver/device was unable to send any frames over the air for 5.5
seconds and it decided it was "enough". The source of this error is
not always the driver/device, sometimes it is a "busy medium", which
it probably was in your case.

Especially since as you said "it fixed itself after 10 min". It's possible
that something was jamming the channel for the time and the device got
blamed. Now, if this was/is the case, then you probably want a portable
signal analyzer to track the jammer. But this is not always possible and
another part of the problem is probably the "fixed" channel. You see,
carl9170 [and other drivers] can monitor the "medium busy time" in real-time.
So, theoretically an AP could automatically migrate to another channel
[maybe even in advance!]. Unfortuantely:
<http://linuxwireless.org/en/users/Documentation/acs> is not that far yet.

Note: This "error" is mostly aquivalent to ath9k's
"ath: Failed to stop TX DMA!" error [which is by far the most observed
one, so changes are that other hardware is affected in the same way]
 
> 
> [   57.355377] ieee80211 phy1: channel change: 2437 -> 2437 failed (2).
> #### hostapd started
> Dhcp: Lease count changed: 17 -> 23
> [   74.126281] usb 1-1: restart device (4)
> [   75.270019] usb 1-1: device restarted successfully.
> [   75.282958] ieee80211 phy1: Hardware restart was requested
> [   76.095520] ieee80211 phy1: channel change: 2437 -> 2437 failed (2).
> [   83.962158] usb 1-1: restart device (4)
> [   85.105957] usb 1-1: device restarted successfully.
> [   85.117248] ieee80211 phy1: Hardware restart was requested
> [   85.925445] ieee80211 phy1: channel change: 2437 -> 2437 failed (2).
> [  101.475524] ieee80211 phy1: invalid plcp cck rate (0).
> [  105.235229] ieee80211 phy1: invalid plcp cck rate (0).
> [  116.718292] ieee80211 phy1: invalid plcp cck rate (0).
> [  123.892150] usb 1-1: restart device (4)
> [  125.035339] usb 1-1: device restarted successfully.
> [  125.050964] ieee80211 phy1: Hardware restart was requested
> 
> Dhcp: Lease count changed: 23 -> 27
> 
> Dhcp: Lease count changed: 31 -> 35
> 
> [  213.108276] ieee80211 phy1: invalid plcp cck rate (0).
> [  236.235626] usb 1-1: restart device (4)
> [  237.379180] usb 1-1: device restarted successfully.
> [  237.397216] ieee80211 phy1: Hardware restart was requested
> [  245.719970] usb 1-1: restart device (4)
> [  246.863586] usb 1-1: device restarted successfully.
> [  246.882110] ieee80211 phy1: Hardware restart was requested
> [  247.692077] ieee80211 phy1: channel change: 2437 -> 2437 failed (2).
> [  260.595031] usb 1-1: restart device (4)
> [  261.738433] usb 1-1: device restarted successfully.
> [  261.752441] ieee80211 phy1: Hardware restart was requested
> [  270.933074] ieee80211 phy1: invalid plcp cck rate (0).
> [  285.126220] usb 1-1: restart device (4)
> [  286.269622] usb 1-1: device restarted successfully.
> [  286.295989] ieee80211 phy1: Hardware restart was requested
> [  297.403289] ieee80211 phy1: invalid plcp cck rate (0).
> [  362.321533] usb 1-1: restart device (4)
> [  363.465087] usb 1-1: device restarted successfully.
> [  363.478973] ieee80211 phy1: Hardware restart was requested
> [  365.365234] ieee80211 phy1: invalid plcp cck rate (0).
> [  373.162506] ieee80211 phy1: invalid plcp cck rate (0).
> [  379.313629] usb 1-1: restart device (4)
> [  380.321624] usb 1-1: kill pending tx urbs.
> [  381.465850] usb 1-1: device restarted successfully.
> [  381.503601] ieee80211 phy1: Hardware restart was requested
> [  402.352691] usb 1-1: restart device (4)
> [  403.497619] usb 1-1: device restarted successfully.
> [  403.539215] ieee80211 phy1: Hardware restart was requested
> [  419.376220] usb 1-1: restart device (4)
> [  420.519714] usb 1-1: device restarted successfully.
> [  420.541839] ieee80211 phy1: Hardware restart was requested
> [  425.160736] ieee80211 phy1: invalid plcp cck rate (0).
> [  429.087493] ieee80211 phy1: invalid plcp cck rate (0).
> [  443.876251] usb 1-1: restart device (4)
> [  445.027557] usb 1-1: device restarted successfully.
> [  445.061523] ieee80211 phy1: Hardware restart was requested
> [  453.605346] ieee80211 phy1: invalid plcp cck rate (0).
> [  460.923065] usb 1-1: restart device (4)
> [  462.066619] usb 1-1: device restarted successfully.
> [  462.079711] ieee80211 phy1: Hardware restart was requested
> [  468.083282] ieee80211 phy1: invalid plcp cck rate (0).
> [  476.703277] ieee80211 phy1: invalid plcp cck rate (0).
> [  485.423095] usb 1-1: restart device (4)
> [  486.566833] usb 1-1: device restarted successfully.
> [  486.580322] ieee80211 phy1: Hardware restart was requested
> [  494.907440] usb 1-1: restart device (4)
> [  496.051025] usb 1-1: device restarted successfully.
> [  496.064727] ieee80211 phy1: Hardware restart was requested
> [  509.407470] usb 1-1: restart device (4)
> [  510.550872] usb 1-1: device restarted successfully.
> [  510.563232] ieee80211 phy1: Hardware restart was requested
> [  511.534698] ieee80211 phy1: invalid plcp cck rate (0).
> [  602.615661] ieee80211 phy1: invalid plcp cck rate (0).
> [  616.634002] usb 1-1: restart device (4)
> [  617.777526] usb 1-1: device restarted successfully.
> [  617.816711] ieee80211 phy1: Hardware restart was requested
> 
> Dhcp: Lease count changed: 35 -> 37
> Dhcp: Lease count changed: 37 -> 42
> Dhcp: Lease count changed: 42 -> 43
> 
> [  662.467742] ieee80211 phy1: invalid plcp cck rate (0).
> 
> Dhcp: Lease count changed: 43 -> 50
> Dhcp: Lease count changed: 50 -> 54
