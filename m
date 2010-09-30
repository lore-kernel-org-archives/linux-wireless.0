Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab0I3HpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 03:45:08 -0400
Subject: Re: [RFC 2/2] wireless:  Report noise to /proc/net/wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1285804637-5400-2-git-send-email-greearb@candelatech.com>
References: <1285804637-5400-1-git-send-email-greearb@candelatech.com>
	 <1285804637-5400-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 09:45:38 +0200
Message-ID: <1285832738.3639.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 16:57 -0700, greearb@candelatech.com wrote:

> This adds noise reports to /proc/net/wireless again.

Same comment applies here really...

> + * @noise: noise, as obtained from dump_survey of index 0.

It's not actually obtained that way, because if it was, cfg80211 could
just handle it by itself.

Additionally, even within mac80211 there's no guarantee that the
dump_survey(0) callback will give you the correct channel's noise.

Since you can easily obtain this information from userspace (and with
the extension that Felix proposed you can figure out which noise belongs
to the operating channel without really knowing the operating channel),
I don't think we should be doing this.

johannes

