Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40319 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932665AbbLHP6a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 10:58:30 -0500
Message-ID: <1449590307.4154.13.camel@sipsolutions.net> (sfid-20151208_165833_150804_CE905690)
Subject: Re: [PATCH 6/9] mac80211: handle width changes from opmode
 notification IE in beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>
Date: Tue, 08 Dec 2015 16:58:27 +0100
In-Reply-To: <CABPxzYL7h8ToceTfx8cV5VUtrr13Y1QZiPphWzznh2pitt457w@mail.gmail.com> (sfid-20151208_165600_461714_E8299054)
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1449583479-26658-7-git-send-email-emmanuel.grumbach@intel.com>
	 <CABPxzYK=RdZo0WB7Tt4PO19n23+9rgAypj=OEDZE8GJ6cV_gXw@mail.gmail.com>
	 <1449589374.4154.11.camel@sipsolutions.net>
	 <CABPxzYJd+9kq8w9zz549F1EEHhWgKhCsDeRUR1MzZ=LbizMJbw@mail.gmail.com>
	 <1449590039.4154.12.camel@sipsolutions.net>
	 <CABPxzYL7h8ToceTfx8cV5VUtrr13Y1QZiPphWzznh2pitt457w@mail.gmail.com>
	 (sfid-20151208_165600_461714_E8299054)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-12-08 at 21:25 +0530, Krishna Chaitanya wrote:
> On Tue, Dec 8, 2015 at 9:23 PM, Johannes Berg <johannes@sipsolutions.
> net> wrote:
> > On Tue, 2015-12-08 at 21:17 +0530, Krishna Chaitanya wrote:
> > > 
> > > > If the rate control algorithm doesn't look at sta->sta.rx_nss
> > > > then
> > > > that's their bug.
> > > 
> > > Yes, it looks like it. Only BW is handled, not the NSS change,
> > > and
> > > without this patch OP MODE IE in beacon updates neither NSS nor
> > > BW.
> > > 
> > > For Action frame OP MODE IE, NSS will be updated.
> Typo BW will be updated.

Ok.

> > I don't see how that would happen - they end up in exactly the same
> > code path.
> 
> As nss_only is false, BW will be update in case of action frame.

Well, this patch removes that since the whole concept of nss_only was
wrong.

So basically you're just saying that minstrel should be fixed to look
at rx_nss (and the relevant change bit, perhaps)...

johannes
