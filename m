Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3KEKO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 05:14:56 -0500
Message-ID: <1383646492.4444.0.camel@jlt4.sipsolutions.net> (sfid-20131105_111509_808038_C44E8A74)
Subject: Re: [PATCH v2 1/3] mac80211_hwsim: use debugfs_remove_recursive
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 Nov 2013 11:14:52 +0100
In-Reply-To: <1383574454.14295.13.camel@jlt4.sipsolutions.net> (sfid-20131104_151435_462544_36095D1B)
References: <1383334560-10672-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131101_203628_172788_3DC6CA5D) <1383574454.14295.13.camel@jlt4.sipsolutions.net>
	 (sfid-20131104_151435_462544_36095D1B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-04 at 15:14 +0100, Johannes Berg wrote:
> On Fri, 2013-11-01 at 20:35 +0100, Janusz Dziedzic wrote:
> > Use debugfs_remove_recursive. That avoids the need
> > for the new dentry pointers and extra debugfs_remove
> > calls.
> 
> All applied, thanks.

Actually, I dropped patches 2 and 3 again - they're causing issues with
channels>1 since DFS isn't allowed then. That in turn exposes a bug in
hwsim with registration failures causing warnings or even crashes
(depending on the kernel version).

johannes

