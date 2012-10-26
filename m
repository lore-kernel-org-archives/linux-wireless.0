Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2JZKz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 06:55:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TRhZz-0007Va-JL
	for linux-wireless@vger.kernel.org; Fri, 26 Oct 2012 12:55:55 +0200
Message-ID: <1351248992.10813.11.camel@jlt4.sipsolutions.net> (sfid-20121026_125604_955875_E895B9DC)
Subject: Re: [PATCH v3 0/2] mac80211 AP cleanup & explicit operations
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 26 Oct 2012 12:56:32 +0200
In-Reply-To: <1351184821-23315-1-git-send-email-johannes@sipsolutions.net> (sfid-20121025_190633_942281_FC425E1D)
References: <1351184821-23315-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121025_190633_942281_FC425E1D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-25 at 19:06 +0200, Johannes Berg wrote:
> Ok so I inserted the cleanup I promised Eliad in the other
> thread before my explicit operations patch, hence resending
> that one as well.
> 
> Haven't really tested this yet though.

Ok I tested it, found that it crashes because kfree_rcu() can't deal
with a NULL pointer. I fixed that and applied the fixed version.

johannes

