Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45770 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3KKTpA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 14:45:00 -0500
Received: by mail-wi0-f181.google.com with SMTP id m19so2707270wiv.2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 11:44:59 -0800 (PST)
Date: Mon, 11 Nov 2013 20:44:38 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH v2] mac80211: minstrel_ht: do not sample unsupported rates
Message-ID: <20131111194438.GB1684@magnum.frso.rivierawaves.com> (sfid-20131111_204504_815217_9AF8F806)
References: <527D14B7.3090204@openwrt.org>
 <1384171849-21058-1-git-send-email-karl.beldan@gmail.com>
 <1384184796.14334.33.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1384184796.14334.33.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 11, 2013 at 04:46:36PM +0100, Johannes Berg wrote:
> On Mon, 2013-11-11 at 13:10 +0100, Karl Beldan wrote:
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > ATM minstrel_ht does not check whether a sampling rate is supported.
> > Unsupported rates attempts can trigger when there are holes in bitfields
> > of supported MCSes belonging to the same group (e.g many devices are
> > MCS32 capable without MCS33->39 capable, also we systematically have a
> > hole for CCK rates).
> > I originally replaced an unsupported sample index with the fls of the
> > bitfield of supported indexes of the sta current sample group, instead,
> > this change simply drops the sample attempt, as suggested by Felix.
> 
> That paragraph doesn't really belong here - you should describe what
> this change is doing (now). There may be some value in describing how
> you arrived at the solution, but this particular description seems
> unnecessary?
> 
Feel free to get rid of the superfluous comments.
 
Karl
