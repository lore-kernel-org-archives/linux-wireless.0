Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:2770 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYAMXE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 18:04:29 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2028601fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 15:04:28 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: Antenna software diversity
Date: Mon, 14 Jan 2008 00:04:21 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801140004.21251.IvDoorn@gmail.com> (sfid-20080113_230434_465886_74A40A41)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In rt2x00 I have made an implementation for antenna software diversity
since not all Ralink hardware supports hardware diversity (aka, almost
all Ralink hardware which set the default antenna to diversity imply
software diversity).

However I would like to know if this is something should remain inside
the driver, or if it should be moved into mac80211. Possibly integrated
into the rate selection module, or otherwise as a seperate module which
could allow the user to select a prefered antenna selection method similar
as to how he can select the prefered rate algorithm.

The current implementation in rt2x00 looks a bit like this:

Once per second the link tuner will run.
The link tuner checks if software diversity is active for either TX or RX
or both antennas.
Determine the current average rssi, and the rssi from the previous period.
If the difference between the old and new average rssi is greater than 5
configure device to swap antenna. And raise the rssi sample flag.
After another link tuning period, evaluate sample results and determine
if the antennas should be swapped or not.

The actions don't really sound hardware dependant, based on the rssi
mac80211 should be able to determine if the antenna's should be swapped
or not. All that is required is the driver indicating to mac80211 that it should
perform software diversity when required...

In mac80211 this would mean that the antenna_sel should probably become
an enum looking like this:

enum antenna_sel {
	ANTENNA_SEL_DEFAULT,
	ANTENNA_SEL_A,
	ANTENNA_SEL_B,
	ANTENNA_SEL_DIVERSITY,
};

I am not really a fan of the ANTENNA_SEL_DEFAULT, but this is already present
in the current mac80211 implementation. So to remove that, we could use some
method for the driver to let the default antenna known to mac80211, probably
through an extra field in ieee80211_hw perhaps.

The ANTENNA_SEL_DIVERSITY would in this case be hardware diversity unless
the driver has indicated that software diversity is in action, through a flag in
ieee80211_hw.

Ivo
