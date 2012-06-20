Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2FTJJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 05:09:06 -0400
Message-ID: <1340183344.4655.53.camel@jlt3.sipsolutions.net> (sfid-20120620_110910_143389_A59EF082)
Subject: Re: [RFCv2 03/13] cfg80211: add channel tracking for AP and mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 20 Jun 2012 11:09:04 +0200
In-Reply-To: <4FE191E1.2020000@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
	  <1340172859-18146-4-git-send-email-michal.kazior@tieto.com>
	 <1340180293.4655.24.camel@jlt3.sipsolutions.net>
	 <4FE191E1.2020000@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 11:03 +0200, Michal Kazior wrote:
> Johannes Berg wrote:
> > On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:
> >> We need to know which channel is used by a running
> >> AP and mesh for channel context accounting and
> >> finding matching/active interface combination.
> >
> > I think there's the AP channel change function now that full-MAC drivers
> > can call -- need to update there?
> 
> I'm not aware of that. I thought it's impossible to change a channel 
> while AP is running now. Am I missing something?

Yeah ... I think the ath6kl driver (only user?) disassociates all
stations or something ... I don't really remember what they told me
about how it worked, but it should be on the list somewhere in the
discussion(s) about the patches that added the feature, see

commit 5314526b1743e8e8614293db7d86e480b4fe9824
Author: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Date:   Fri Apr 6 13:35:47 2012 -0700

    cfg80211: add channel switch notify event


johannes

