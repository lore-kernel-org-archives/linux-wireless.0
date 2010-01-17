Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36244 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab0AQPAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 10:00:49 -0500
Message-Id: <20100117144918.773071520@sipsolutions.net>
Date: Sun, 17 Jan 2010 15:49:18 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC/RFT 0/2] userspace station-mode action frame handling
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni, all,

These two patches now implement returning unknown
action frames and registering for certain action
frames from userspace, as well as sending as before.

A few design decisions:
 * AP mode is unchanged, hostapd is responsible for
   returning unknown action frames (cooked monitor).
 * Registration/transmission works only in station
   mode (would be easy to change in the future).
 * Registration needs to specify which frames to receive
   by providing a frame match buffer, which matches
   the first few bytes of the frame, so for instance
   the buffer [0x04] would register for all public
   action frames, and [0x7f, 0x00, 0x02, 0xb3] would
   register for certain Intel vendor action frames.
 * Action frames that are registered for are unicast
   to the socket that registered for it.
 * If userspace wants to know about returned action
   frames for ones it sent, it needs to register
   for them specifically, for my example above it
   would be [0xff, 0x00, 0x02, 0xb3].

johannes

