Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab2E3N4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 09:56:15 -0400
Message-ID: <1338385800.4511.21.camel@jlt3.sipsolutions.net> (sfid-20120530_163648_961390_798FF887)
Subject: Re: [PATCH 3.5] mac80211: flush off-channel work when interface
 goes down
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nirav Shah <nirav.j2.shah@intel.com>
Date: Wed, 30 May 2012 15:50:00 +0200
In-Reply-To: <CAB3XZEdmWRn-2O65AnfnF-jya_FNXK8gc21EBBoDisNoZGDeRQ@mail.gmail.com> (sfid-20120530_154439_644267_D275C758)
References: <1338383762.4511.16.camel@jlt3.sipsolutions.net>
	 <CAB3XZEdmWRn-2O65AnfnF-jya_FNXK8gc21EBBoDisNoZGDeRQ@mail.gmail.com>
	 (sfid-20120530_154439_644267_D275C758)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 16:44 +0300, Eliad Peller wrote:
> On Wed, May 30, 2012 at 4:16 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > When any interface goes down, it could be the one that
> > we were doing off-channel with. Thus, we need to flush
> > the offchannel start/stop work so they can't run when
> > the interface has already been removed from the driver
> > or even been destroyed. It's OK to flush them even if
> > they were for another interface, that just means that
> > we potentially delay the interface down a little bit.
> >
> can't we check hw_roc_dev?

We could, but it didn't seem worthwhile. Think I should do that instead?

johannes

