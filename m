Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaATKxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 05:53:41 -0500
Message-ID: <1390215217.4335.9.camel@jlt4.sipsolutions.net> (sfid-20140120_115344_091086_318E68C8)
Subject: Re: [PATCH 3/5] cfg80211: fix maximum bandwidth calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Mon, 20 Jan 2014 11:53:37 +0100
In-Reply-To: <1389947524-6102-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140117_093218_121841_6231699D)
References: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1389947524-6102-4-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140117_093218_121841_6231699D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-17 at 09:32 +0100, Janusz Dziedzic wrote:
> Calculate maximum bandwidth base on all contiguous
> regulatory rules, instead of single rule.
> Base on this calculation mark channel BW flags
> correctly.

I can't consider this a "fix". In absence of other information, this is
a userspace API change. It might be possible that I'll let you get away
with it if we assume that everybody mostly just uses the official db.txt
and you can show that it doesn't lead to different interpretation of the
rules, but there's no way I'll apply this patch as a "fix" with just
four lines of commit log.

johannes

