Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4034 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbbCLNvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:51:12 -0400
Date: Thu, 12 Mar 2015 19:20:54 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: add sysfs entry to configure quiet period
Message-ID: <20150312135052.GB3305@qca.qualcomm.com> (sfid-20150312_145117_089989_6C8985D2)
References: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
 <87lhj4yi0x.fsf@kamboji.qca.qualcomm.com>
 <20150310165323.GB11700@qca.qualcomm.com>
 <874mpquza9.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <874mpquza9.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 12, 2015 at 03:21:34PM +0200, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > On Tue, Mar 10, 2015 at 05:43:58PM +0200, Kalle Valo wrote:
> >> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> >> 
> >> > Add support to configure quiet period via sysfs entry. This will
> >> > be helpful to experiment different quiet period values along with
> >> > different duty cycle ratio.
> >> >
> >> > To configure quiet period as 30ms,
> >> >
> >> > echo 30 >/sys/class/ieee80211/phyX/device/quiet_period
> >> 
> >> What's the justification? To me this looks like an ugly driver private
> >> hack. Why can't you use nl80211 or something else?
> >
> > As this is purely for testing purpose to play around with different
> > quiet period along with various throttling state, sysfs entry is used
> > instead of netlink testmode command. Instead of debugfs, sysfs entry is
> > selected to align with existing thermal interface. 
> 
> Please correct me if I'm wrong, but I consider sysfs as a stable user
> space interface. It's not meant for random testing stuff.
> 
Completely agree. Will move this change under debugfs. Does it sound
good?

-Rajkumar
