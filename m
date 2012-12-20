Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2LTRDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 12:03:33 -0500
Message-ID: <1356023031.10029.19.camel@jlt4.sipsolutions.net> (sfid-20121220_180336_749558_9F2730AD)
Subject: Re: [PATCH] wireless: remove WARN_ON in __cfg80211_mlme_disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 20 Dec 2012 18:03:51 +0100
In-Reply-To: <1356020450-9915-1-git-send-email-linville@tuxdriver.com>
References: <1356020450-9915-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-20 at 11:20 -0500, John W. Linville wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> 
> It seems like all this WARN_ON does is generate useless bug reports...?

Well the warning isn't really spurious, and it really shouldn't happen
(and Stanislaw just pointed to the bugfix on the bugreport), but I agree
the warning is a bit useless because it doesn't tell us why it actually
happened. I'd still prefer to keep it though because it points to this
inconsistency in reporting state to userspace.

johannes

