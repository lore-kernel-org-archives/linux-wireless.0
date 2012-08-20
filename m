Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab2HTLXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 07:23:03 -0400
Message-ID: <1345461777.4459.13.camel@jlt3.sipsolutions.net> (sfid-20120820_132307_256163_9E9696EB)
Subject: Re: [PATCH] mac80211: do not reply to AUTH frame if sta allocation
 fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 20 Aug 2012 13:22:57 +0200
In-Reply-To: <1344454452-19480-1-git-send-email-ordex@autistici.org>
References: <1344454452-19480-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-08 at 21:34 +0200, Antonio Quartulli wrote:
> Whenever we get an AUTH frame we first allocate a new station and then we reply
> with another AUTH frame. However, if sta allocations fails we have to do not
> reply so that the other hand do not think we have correctly set everything up

Maybe we should send a negative auth reply instead since there's no
guarantee that any station will ever send a reply at all?

johannes

