Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail44.messagelabs.com ([216.82.249.179]:3209 "HELO
	mail44.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754713Ab2AKTbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 14:31:20 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 1/2] wireless: Save original maximum regulatory transmission power for the calucation of the local maximum transmit power
Date: Wed, 11 Jan 2012 21:31:09 +0200
Message-ID: <5EFF534737810441B0F97C2792E49C2DD20381@ILMAIL01.dspg.com> (sfid-20120111_203127_553290_15DF0876)
In-Reply-To: <1326308385.3417.11.camel@jlt3.sipsolutions.net>
References: <5EFF534737810441B0F97C2792E49C2DD20371@ILMAIL01.dspg.com> <1326308385.3417.11.camel@jlt3.sipsolutions.net>
From: "Hong Wu" <Hong.Wu@dspg.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The local maximum transmit power is the maximum power a wireless device
allowed to transmit. If Power Constraint is presented, the local maximum
power equals to the maximum allowed power defined in regulatory domain
minus power constraint.

The maximum transmit power is maximum power a wireless device capable of
transmitting, and should be used in Power Capability element (7.3.2.16
IEEE802.11 2007).

The transmit power from a wireless device should not greater than the
local maximum transmit power.

The maximum transmit power was not calculated correctly in the current
Linux wireless/mac80211 when Power Constraint is presented.

Hong   

-----Original Message-----
From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: Wednesday, January 11, 2012 11:00 AM
To: Hong Wu
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] wireless: Save original maximum regulatory
transmission power for the calucation of the local maximum transmit
power

On Wed, 2012-01-11 at 20:33 +0200, Hong Wu wrote:
> The local maximum transmit power for a channel is defined as the
maximum
> regulatory transmission power minus the local power constraint
specified
> for the channel in the Power Constraint element. (7.3.2.15 IEEE80211
2007)

I have a feeling that looking at the code I understand what you're
trying to fix, but please explain it better.

johannes


______________________________________________________________________
DSP Group, Inc. automatically scans all emails and attachments using
MessageLabs Email Security System.
_____________________________________________________________________

______________________________________________________________________
DSP Group, Inc. automatically scans all emails and attachments using MessageLabs Email Security System.
_____________________________________________________________________
