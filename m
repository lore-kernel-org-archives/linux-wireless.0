Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f43.google.com ([209.85.212.43]:59417 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759517Ab1IJQsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Sep 2011 12:48:39 -0400
Received: by vws10 with SMTP id 10so2774180vws.2
        for <linux-wireless@vger.kernel.org>; Sat, 10 Sep 2011 09:48:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rynG8HoOZruSu1t=_GUZ+8mRcHCu46=eATjnBcDMGaO5A@mail.gmail.com>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
	<20110827143513.GN3775@shale.localdomain>
	<20110827145003.GA9405@suse.de>
	<CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
	<20110827152144.GA10126@suse.de>
	<20110830014257.GI15771@broadcom.com>
	<CACna6rynG8HoOZruSu1t=_GUZ+8mRcHCu46=eATjnBcDMGaO5A@mail.gmail.com>
Date: Sat, 10 Sep 2011 18:48:38 +0200
Message-ID: <CACna6ryYH1_ueCfDMsd+AYsprb1KTrWMmLRQnjebDQXX+M-ssQ@mail.gmail.com> (sfid-20110910_184848_487031_6C387D87)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>, Greg KH <gregkh@suse.de>
Cc: Dan Carpenter <error27@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henry, you ignored most of the questions and explanations. In this
situation I don't have anything more to add, I'll just post few
comments/updates.

W dniu 30 sierpnia 2011 08:17 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> 2011/8/30 Henry Ptasinski <henryp@broadcom.com>:
>> The b43 driver doesn't implement transmit power control for the BCM43224 or
>> BCM43225, and has various other unimplemented phy functions, e.g.:
>>
>>> void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
>>> {//TODO
>>> }
>>>
>>> static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
>>> {//TODO
>>> }
>>>
>>> static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
>>>                                                         bool ignore_tssi)
>>> {//TODO
>>>         return B43_TXPWR_RES_DONE;
>>> }
>>>
>>> ...
>>>       b43err(dev->wl, "enabling tx pwr ctrl not implemented yet\n"); ...
>>> ...
>>
>> etc.
>
> I've just checked your wlc_phy_txpower_recalc_target_nphy. It's calling:
> 1) Trivial wlc_phy_txpwr_limit_to_tbl_nphy
> 2) More advanced wlc_phy_txpwrctrl_pwr_setup_nphy we have to implement
> 3) Already-implemented-in-b43 wlapi_bmac_mctrl
> 4) 50% implemented wlc_phy_txpwrctrl_enable_nphy
>
> I can do this in 1 day.

If you watch linux-wireless ML, you could see I've started
implementing calibration for N-PHY in b43.

A progress is little slower recently because of:
1) Me having less time in few recent days
2) Problems with kernel.org servers

In any case, *I'm going to finish N-PHY calibration* in b43. I've more
stuff already, just need to test it before posting and make sure
nothing was missed due to problems with git.kernel.org.

I've also finished initialization of static tables for LCN-PHY and
implemented basic operations. Now I'm just going to rewrite other
initialization ops and that should give us working LCN support.

I'm moving to the new place in next week (that's why I've been busy
recently) and will start playing with 5 GHz support in b43.


Too bad you didn't respond to all our questions and comments :| Ppl
started commenting that [0] without seeing the real solution I wanted
to see discussed with you.

[0] http://www.h-online.com/open/features/Kernel-comment-The-obstacle-course-of-cooperation-1340020.html

-- 
Rafał
