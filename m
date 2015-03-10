Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36726 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbbCJQxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 12:53:45 -0400
Date: Tue, 10 Mar 2015 22:23:24 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: add sysfs entry to configure quiet period
Message-ID: <20150310165323.GB11700@qca.qualcomm.com> (sfid-20150310_175348_811678_AAA2EF2C)
References: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
 <87lhj4yi0x.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87lhj4yi0x.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2015 at 05:43:58PM +0200, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > Add support to configure quiet period via sysfs entry. This will
> > be helpful to experiment different quiet period values along with
> > different duty cycle ratio.
> >
> > To configure quiet period as 30ms,
> >
> > echo 30 >/sys/class/ieee80211/phyX/device/quiet_period
> 
> What's the justification? To me this looks like an ugly driver private
> hack. Why can't you use nl80211 or something else?

As this is purely for testing purpose to play around with different
quiet period along with various throttling state, sysfs entry is used
instead of netlink testmode command. Instead of debugfs, sysfs entry is
selected to align with existing thermal interface. 

-Rajkumar
