Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:50977 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYH1MJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 08:09:16 -0400
Subject: Re: [PATCH 08/11] iwlwifi: call apm stop on exit
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>
In-Reply-To: <1ba2fa240808280358u6523bc8ga758c0acf4f2ec4c@mail.gmail.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-9-git-send-email-yi.zhu@intel.com>
	 <1219927149.6064.25.camel@californication>
	 <1219920741.25321.4.camel@johannes.berg>
	 <1219928195.6064.43.camel@californication>
	 <1ba2fa240808280358u6523bc8ga758c0acf4f2ec4c@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 16:09:11 +0200
Message-Id: <1219932551.6064.65.camel@californication> (sfid-20080828_140919_398583_E3462E68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

> >> > > This patch calls apm stop on exit and suspend and sets STATUS_EXIT_PENDING
> >> > > accordingly. Without this patch hardware consumes power even after driver
> >> > > is removed or suspended.
> >> >
> >> > is this a regression to 2.6.26? That is always the important question
> >> > here since that will determine if the patch should go in. If the 2.6.26
> >> > version did this better (even if not prefect), then this patch should go
> >> > on, otherwise it could wait until next merge window.
> >>
> >> AFAIR people have been complaining about this behaviour _forever_, so
> >> it's hardly a regression.
> >
> > I think so too. However the question is still if 2.6.26 maybe did better
> > and we are now doing worse because of other patches. This needs to be in
> > the commit message. Otherwise this falls for me in the next merge window
> > category.
> >
> Regression or not, this is an important bug fix.  With millions of
> laptops sold this is significant contribution to global worming.

I fully agree with you here (no questions asked), but that is besides
the point.

The whole idea is to speed up the release cycle and every fix that is
not a regression fix might have impacts. Also if it is not a regression,
I can wait until the next merge window. I think that Linus made it
pretty clear.

So while I personally would vote for including this patch, it doesn't
really fit the criteria for being submitted after -rc4. In the end this
is up to Dave if he feels it is worth to explain this to Linus. There is
a gray area.

If you wanna play the "being green" card, then include numbers on how
much power this would save :)

Regards

Marcel


