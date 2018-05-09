Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41566 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933879AbeEIJhF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 05:37:05 -0400
Message-ID: <1525858618.6910.9.camel@sipsolutions.net> (sfid-20180509_113709_277359_1EC29927)
Subject: Re: [mac80211-next:master 12/14]
 drivers/net//wireless/ath/wil6210/debugfs.c:1245:1: warning: the frame size
 of 1600 bytes is larger than 1024 bytes
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        linux-wireless@vger.kernel.org, Maya Erez <merez@codeaurora.org>
Date: Wed, 09 May 2018 11:36:58 +0200
In-Reply-To: <87efil41d4.fsf@toke.dk>
References: <201805090154.h4Cokbx2%fengguang.wu@intel.com>
         <87efil2p2o.fsf@purkki.adurom.net>
         <1525855900.6910.5.camel@sipsolutions.net>
         <87tvrhw6kj.fsf@kamboji.qca.qualcomm.com>
         <1525856418.6910.6.camel@sipsolutions.net> <87efil41d4.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-05-09 at 11:36 +0200, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Wed, 2018-05-09 at 11:56 +0300, Kalle Valo wrote:
> > > Johannes Berg <johannes@sipsolutions.net> writes:
> > > 
> > > > On Wed, 2018-05-09 at 11:47 +0300, Kalle Valo wrote:
> > > > > 
> > > > > I guess these warnings come because Toke's patch increased size of
> > > > > struct cfg80211_tid_stats (which is included in struct station_info) and
> > > > > both wil6210 and qtnfmac allocate a struct station_info from stack? 
> > > > 
> > > > Yes.
> > > > 
> > > > > Can
> > > > > someone send a fix for the drivers?
> > > > 
> > > > I guess Toke/I should do that through my tree.
> > > 
> > > IMHO the fix could go through my tree as well, less risk of conflicts in
> > > drivers. AFAICS the fix (allocating station_info dynamically?) would not
> > > depend on Toke's patch and could be applied separately.
> > 
> > That's true, if you prefer that it's fine with me.
> 
> I'll send a patch.
> 
> What's the right tag to put in the commit for this?
> Fixes-but-is-independent-from: ? ;)

Heh. You can still put Fixes: I think.

johannes
