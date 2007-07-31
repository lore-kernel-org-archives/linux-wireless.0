Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44035
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbXGaJkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 05:40:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Date: Tue, 31 Jul 2007 11:39:54 +0200
Cc: Ulrich Kunitz <kune@deine-taler.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	Jiri Benc <jbenc@suse.cz>
References: <20070730023128.99E927B409F@zog.reactivated.net> <200707310105.55863.mb@bu3sch.de> <200707302223.04696.flamingice@sourmilk.net>
In-Reply-To: <200707302223.04696.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707311139.54521.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 July 2007, Michael Wu wrote:
> On Monday 30 July 2007 16:05, Michael Buesch wrote:
> > I suggest you look at bcm43xx-mac80211.
> > You will need to introduce refcounting for your monitor interfaces
> > and I _really_ suggest to get rid of the zd_op_open() and zd_op_close()
> > functions. Just include that in add/remove interface. You need
> > to refcount your interfaces anyway.
> >
> Requiring refcounting for monitor interfaces is fairly dumb since mac80211 
> does the exact same refcounting. I haven't bothered to do it in any driver 
> ports yet for this reason. This part of the mac80211 driver api needs to be 
> fixed.

I'm talking about _current_ API. And with current API you need refcounting.
If you want to change that, that's fine. But that doesn't matter here.

