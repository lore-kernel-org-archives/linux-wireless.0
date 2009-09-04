Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53593 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535AbZIDDNy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 23:13:54 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2009 20:13:57 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19104.34984.11623.519326@gargle.gargle.HOWL>
Date: Fri, 4 Sep 2009 08:55:28 +0530
To: Pavel Roskin <proski@gnu.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Fix channelFlags for 2GHZ
In-Reply-To: <1251991187.6521.22.camel@mj>
References: <19103.25725.707217.596352@gargle.gargle.HOWL>
	<1251991187.6521.22.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> My impression is that's a workaround for a bug that lies elsewhere.  I
> don't think we should apply such patches.

The internal channelFlags/related macros are extremely messy.
The ugliness arose from the requirement for differentiating between
modes (11a, 11g, 11ng etc..) and legacy cruft.  mac80211 has no concept of modes,
it has bands instead. I do understand your concern though. But fixing
this cleanly would mean that we rewrite the entire channel handling
mechanism, any band-aid can only be a hack at best.

But yes, maybe we can hold this until everything is cleaned up.
And this has been in the ath9k TODO page for quite some time. :)

Sujith
