Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbZKPOYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 09:24:38 -0500
Message-Id: <20091116142134.288122270@sipsolutions.net>
Date: Mon, 16 Nov 2009 15:21:34 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
Subject: [RFC 0/3] fix the aMPDU reorder placement
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Our code has a comment about where the reordering
should happen, and why it doesn't hurt being where
it currently is.

However, this code needs to use sta_info_get()
without knowing which virtual interface is the one
we're processing the frames for, which is getting
in my way.

Rather than trying to find the virtual interface
by the DA, I decided to put the reorder code at the
right place instead because then the station pointer
is already known (so we even save a lookup).

Please test! Especially against APs that are prone
to hitting the timeout.

johannes
