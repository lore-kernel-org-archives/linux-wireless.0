Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65454 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3KKToD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 14:44:03 -0500
Received: by mail-wi0-f172.google.com with SMTP id ez12so2677580wid.17
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 11:44:02 -0800 (PST)
Date: Mon, 11 Nov 2013 20:43:41 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH 1/2] mac80211: minstrels: spare numerous useless calls to
 get_random_bytes
Message-ID: <20131111194341.GA1684@magnum.frso.rivierawaves.com> (sfid-20131111_204409_265764_FE433DCB)
References: <1383928473-798-1-git-send-email-karl.beldan@gmail.com>
 <1384184745.14334.32.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1384184745.14334.32.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 11, 2013 at 04:45:45PM +0100, Johannes Berg wrote:
> On Fri, 2013-11-08 at 17:34 +0100, Karl Beldan wrote:
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > These are called to init the sample tables.
> > This occurs once in minstrel_ht upon its registration (since it uses one
> > single common sample table for all STAs), and once per sta addition in
> > minstrel.
> 
> This commit log is suboptimal, it doesn't even seem to describe a change
> but rather the behaviour after (or before?) the change?
> 
Other than replacing:
"These are called to init the sample tables.\nThis occurs once in"
with:
"These are called to init the sample tables, which occurs once in",
plus this ridiculously small diff in a non convoluted localized code
path .. 

FYI, this lowers the prng bytes demands from about 10*12*8bytes to
10*8bytes per non-ht sta addition and at minstrel_ht init. This is to
relate to the email posted just after I posted this change:
http://marc.info/?l=linux-wireless&m=138393239432434&w=2
 
Karl
