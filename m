Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1AWJL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 04:11:28 -0500
Subject: Re: [RFC/WIP 00/33] ath9k_htc AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <19770.20402.711305.279934@gargle.gargle.HOWL>
References: <19768.62903.947245.576431@gargle.gargle.HOWL>
	 <201101212226.40435.chunkeey@googlemail.com>
	 <19770.18241.787715.680555@gargle.gargle.HOWL>
	 <19770.18332.859418.283909@gargle.gargle.HOWL>
	 <19770.20402.711305.279934@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 10:11:24 +0100
Message-ID: <1295773884.3639.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-01-22 at 09:02 +0530, Sujith wrote:

> It does make it a bit neat to have such a mechanism. And for AP mode, I would think
> that it's kinda essential unless someone comes with an ingenious way of solving
> the PS race for drivers that don't set IEEE80211_HW_REPORTS_TX_ACK_STATUS. :-)

Well, you can handle the PS stuff in the device completely -- or do it
like iwlwifi does, where it doesn't rely on the ACK to detect the race,
but the firmware will reject TX frames to sleeping stations until the
driver tells it the station woke up.

How it works is like this:

STA AWAKE -> ASLEEP transition:
  - firmware marks station as asleep
  - firmware rejects TX frames for this station that are in queue
  - driver keeps track of # of such frames, and uses
    ieee80211_sta_block_awake() to block this station while it has
    frames in the queue
  - rejected frames are rejected to mac80211 and queued up

ASLEEP -> AWAKE:
  - due to ieee80211_sta_block_awake() wakeup is blocked until the
    queue has drained as well (if station very quick wakes up), then
    when both conditions are met,
  - driver tells device that this station woke up
  - mac80211 re-transmits all those frames
  - driver queues up all those frames

johannes

