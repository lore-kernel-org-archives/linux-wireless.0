Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3BFVoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 16:44:15 -0500
Message-ID: <1360187077.7910.78.camel@jlt4.sipsolutions.net> (sfid-20130206_224418_858338_26DC93BD)
Subject: Re: [PATCH 3/4] mac80211: Improve error handling for off-channel
 operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Wed, 06 Feb 2013 22:44:37 +0100
In-Reply-To: <1360162873-17240-4-git-send-email-seth.forshee@canonical.com>
References: <1360162873-17240-1-git-send-email-seth.forshee@canonical.com>
	 <1360162873-17240-4-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 09:01 -0600, Seth Forshee wrote:
> Errors in sending the nullfunc frame to set powersave at the AP for
> off-channel operation can lead to high packet loss. Add error handling
> to fail going off-channel when this happens, and return an error to
> userspace.

With the flushes in place, have you ever seen this fail? This and patch
ones seems like a lot of churn for only half of what you'd want -- what
you really want is to know if the AP ACKed the frame...

johannes

