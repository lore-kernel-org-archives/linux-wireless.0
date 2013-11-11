Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab3KKPql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 10:46:41 -0500
Message-ID: <1384184796.14334.33.camel@jlt4.sipsolutions.net> (sfid-20131111_164650_224189_B295E0B8)
Subject: Re: [PATCH v2] mac80211: minstrel_ht: do not sample unsupported
 rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Mon, 11 Nov 2013 16:46:36 +0100
In-Reply-To: <1384171849-21058-1-git-send-email-karl.beldan@gmail.com> (sfid-20131111_131211_769040_CB80FCBE)
References: <527D14B7.3090204@openwrt.org>
	 <1384171849-21058-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20131111_131211_769040_CB80FCBE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-11 at 13:10 +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> ATM minstrel_ht does not check whether a sampling rate is supported.
> Unsupported rates attempts can trigger when there are holes in bitfields
> of supported MCSes belonging to the same group (e.g many devices are
> MCS32 capable without MCS33->39 capable, also we systematically have a
> hole for CCK rates).
> I originally replaced an unsupported sample index with the fls of the
> bitfield of supported indexes of the sta current sample group, instead,
> this change simply drops the sample attempt, as suggested by Felix.

That paragraph doesn't really belong here - you should describe what
this change is doing (now). There may be some value in describing how
you arrived at the solution, but this particular description seems
unnecessary?

johannes

