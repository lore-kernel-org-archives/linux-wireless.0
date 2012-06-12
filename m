Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2FLTfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 15:35:11 -0400
Message-ID: <1339529708.4531.16.camel@jlt3.sipsolutions.net> (sfid-20120612_213515_620367_C55C07FC)
Subject: Re: [PATCH 3/3] [nl,cfg,mac]80211: Allow user to configure basic
 rates when joining
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Date: Tue, 12 Jun 2012 21:35:08 +0200
In-Reply-To: <CACcxo+ptw_-fgnrROmQXBkRONLw_hwwuufgqK_rzDQa6Ge7xNQ@mail.gmail.com> (sfid-20120612_213332_522627_061EF506)
References: <1339122086-23190-1-git-send-email-ashok@cozybit.com>
	 <1339122086-23190-3-git-send-email-ashok@cozybit.com>
	 <1339231815.4539.33.camel@jlt3.sipsolutions.net>
	 <CACcxo+ptw_-fgnrROmQXBkRONLw_hwwuufgqK_rzDQa6Ge7xNQ@mail.gmail.com>
	 (sfid-20120612_213332_522627_061EF506)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 12:33 -0700, Ashok Nagarajan wrote:
> Hello Johannes,
> 
> On Sat, Jun 9, 2012 at 1:50 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2012-06-07 at 19:21 -0700, Ashok Nagarajan wrote:
> >> Currently mesh uses mandatory rates as default basic rates. This patch
> >> introduces basic rates to be configured at the time of joining mesh.
> >
> >> +     if (!sdata->vif.bss_conf.basic_rates)
> >> +             sdata->vif.bss_conf.basic_rates =
> >> +                     ieee80211_mandatory_rates(sdata, band);
> >
> > I think this default should come from cfg80211 instead, there's little
> > point in imposing this calculation on all drivers that want to use mesh.
> >
> 
> This default initialization uses the mac80211 utility function which
> will not be accessible from cfg80211. 

cfg80211 has the same data though, the function only uses channel flags.

> Could you please explain what is
> the advantage/purpose of imposing this calculation up in cfg80211.

If there are ever non-mac80211 drivers using it they don't have to re-do
the same calculations.

johannes

