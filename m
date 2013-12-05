Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53070 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847Ab3LESx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 13:53:56 -0500
Message-ID: <1386269631.4182.22.camel@jlt4.sipsolutions.net> (sfid-20131205_195400_289983_9648E70B)
Subject: Re: [PATCH v8 4/5] mac80211: align ieee80211_mesh_csa_beacon() with
 ieee80211_csa_beacon()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sw@simonwunderlich.de" <sw@simonwunderlich.de>,
	"yeohchunyeow@gmail.com" <yeohchunyeow@gmail.com>,
	"yeohchunyeow@cozybit.com" <yeohchunyeow@cozybit.com>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Thu, 05 Dec 2013 19:53:51 +0100
In-Reply-To: <1386269585.3878.21.camel@porter.coelho.fi>
References: <1386257143-29840-1-git-send-email-luciano.coelho@intel.com>
	 <1386257143-29840-5-git-send-email-luciano.coelho@intel.com>
	 (sfid-20131205_162554_500402_7BA9FCA3) <1386259467.4182.13.camel@jlt4.sipsolutions.net>
	 <1386269585.3878.21.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 18:53 +0000, Coelho, Luciano wrote:
> On Thu, 2013-12-05 at 17:04 +0100, Johannes Berg wrote:
> > On Thu, 2013-12-05 at 17:25 +0200, Luciano Coelho wrote:
> > > The return value of ieee80211_mesh_csa_beacon is not aligned with the
> > > return value of ieee80211_csa_beacon() and
> > > ieee80211_ibss_csa_beacon().  For consistency and to be able to use
> > > both functions with similar code, change ieee80211_mesh_csa_beacon()
> > > not to send the bss changed notification itself, but return what has
> > > changed so the caller can send the notification instead.
> > 
> > It seems to me that the caller should be updated?
> 
> With this patch only, the caller just checks if the return value is < 0
> (ie. an error), otherwise it assumes it was okay.  With this patch, we
> still return < 0 on errors, but we return positive, saying that the
> beacon has changed.
> 
> My next patch (5/5) changes the caller so that the value is used
> properly (ie. ORing the return value to the changed variable).

But doesn't that leave this patch broken?

johannes

