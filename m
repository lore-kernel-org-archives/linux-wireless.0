Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41748 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYH1L4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:56:22 -0400
Subject: Re: [PATCH 03/11] iwlwifi: fix hidden ssid discovery in passive
	channels
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Cahill Ben <ben.m.cahill@intel.com>
In-Reply-To: <1ba2fa240808280438o7c5c9b38y7b2572fbe222ed5f@mail.gmail.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219926558.6064.11.camel@californication>
	 <1ba2fa240808280340o216da98dwbf84541aa7bfd2e6@mail.gmail.com>
	 <1219927771.6064.39.camel@californication>
	 <1ba2fa240808280438o7c5c9b38y7b2572fbe222ed5f@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 15:56:19 +0200
Message-Id: <1219931779.6064.48.camel@californication> (sfid-20080828_135625_421203_725C5566)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> >> This patch gives the HW the possibility to send direct probes in passive
> >> >> channels (as long as traffic was detected in that channel) if such ssid
> >> >> was requested, so hidden ssid can be found now in those channels as well.
> >> >
> >> > this also doesn't sound like a regression to me. Nice to have for sure,
> >> > but not acceptable according to the merge window rules.
> >>
> >> If you cannot scan your AP you also not able to connect to it, drawing
> >> your card useless.
> >>
> >> > Question here is was the driver supporting this before and we broke it
> >> > in the 2.6.27 phase or not.
> >>
> >> Irrelevant, this is fixing show stopper bug.
> >
> > it is relevant. So I read this commit message as, that now we can also
> > find hidden SSIDs in passive channels. Question that you should ask then
> > is if that was supported before. Yes or no. If yes, then it is a
> > regression, no then it is a feature. And regression fixes go in features
> > wait for the next merge window.
> >
> > The term show stopper bug is irrelevant when it comes to merge window
> > rules.
> >
> I don't know if it worked before or not I didn't check. This is new code.

is this new code for new hardware or did we also use it in the 4965
case? And yes, we need to check 2.6.26 here. And then state this clearly
in the commit message.

Please also see this from the point of people that actually have to or
wanna backport patches. The better the commit message, the easier their
job to make good decisions on which patches to take.

Regards

Marcel


