Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1DAT7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 15:59:20 -0400
Subject: Re: [PATCH v3 1/2] cfg80211: fix regulatory restore upon user hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, gregoryx.alagnou@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1301686955-9402-1-git-send-email-lrodriguez@atheros.com>
References: <1301686955-9402-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 21:59:08 +0200
Message-ID: <1301687948.3842.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-01 at 12:42 -0700, Luis R. Rodriguez wrote:
> When we restore regulatory settings its possible CRDA
> will not reply because of a bogus user entry. In this
> case the bogus entry will prevent any further processing
> on cfg80211 for regulatory domains even if we restore
> regulatory settings.
> 
> To prevent this we suck out all pending requests when
> restoring regulatory settings and add them back into the
> queue after we have queued up the reset work.

What if CRDA replies in order, i.e. replies to the user requested one
first instead of the disassoc requested one?

Why do we even require crda to reply to the first in list, rather than
any one?

johannes

