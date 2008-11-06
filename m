Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30162 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbYKFHgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 02:36:14 -0500
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Thoughts about mac80211 client PS implementation
References: <87k5bhkjf1.fsf@nokia.com>
	<1225917235.3619.180.camel@johannes.berg> <87fxm5ki6s.fsf@nokia.com>
	<1225919146.3619.190.camel@johannes.berg> <877i7hkgpn.fsf@nokia.com>
	<1ba2fa240811051355y4a38c5f1jc6433ac4eeb9dd1f@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 06 Nov 2008 09:35:19 +0200
In-Reply-To: <1ba2fa240811051355y4a38c5f1jc6433ac4eeb9dd1f@mail.gmail.com> (ext Tomas Winkler's message of "Wed\, 5 Nov 2008 23\:55\:31 +0200")
Message-ID: <874p2l71e0.fsf@nokia.com> (sfid-20081106_083624_907894_D4BC6F9D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

> What I wonder in this whole conversation is how the power is saved
> here. How and what do you shut down physically in the NIC.

In stlc45xx it works such that the driver controls firmware's Power
Save Mode with LM_OID_PSM command. When the driver enables PSM, the
firmware sleeps as much as possible and it will wakeup only for
beacons (interval is configurable). If the driver sends a frame, the
firmware sets PSM bit in frames's frame control and goes to sleep
immeaditely after receiving an ack for the frame.

If the driver disables the PSM in firmware, the firmware is awake all
the time.

> I'm not sure how much u save if u're just not receiving frames bur
> you are still busy with scheduling timers.

With this scheme we will have significant power savings because the
radios can be turned off for long idle periods, but it doesn't
sacrifice the latency that much.

> In iwlwifi all the gory timing issues are handled in the firmware
> and driver just may option to configure some parameters according
> battery life, user preferences and current throughput plus firmware
> is able to close different part of the HW as well. I'm have strong
> hunch that also other vendors handle this in low level as this is
> kind of real time to be in sync with DITIMs and listen intervals
> etc.

In stlc45xx the firmware takes care of waking up for beacons (of
course, linux is not a real time OS). It's just that in stlc45xx
firmware's PS implementation isn't as advanced as yours is and we have
to something in host as well.

> One other think is that PS can be enabled also in non associated state
> from the HW perspective only during association and scanning it's
> disabled but that not connected to the spec.

I don't see how Power Save Mode can be useful when disassociated. PSM
is about AP buffering frames for us, but what does it buffer when the
client is disassociated? Sure, turning off radios when not associated
is very wise to do but we can control that already with op_start() and
op_stop(). No need to use Power Save features here.

> Currently we have all what you describing here enabled onfiguring
> through iwconfig power and it's already working so I'm trying to
> figure out how our strange HW :) will fit into this new stuff.

I haven't investigated how PS works in your hw, yet. But if any
problems appear, I'll add a HW flag for the driver to disable dynamic
PS, or something like that.

-- 
Kalle Valo
