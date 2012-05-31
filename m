Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2EaHlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 03:41:37 -0400
Message-ID: <1338450085.4531.4.camel@jlt3.sipsolutions.net> (sfid-20120531_094147_917387_5F7794E0)
Subject: Re: [PATCH 3.5] mac80211: flush off-channel work when interface
 goes down
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nirav Shah <nirav.j2.shah@intel.com>
Date: Thu, 31 May 2012 09:41:25 +0200
In-Reply-To: <CAB3XZEdKbR2bozuXDdPsE09Nj_yq3UFpmuL2wgokX=8UGwptBQ@mail.gmail.com> (sfid-20120531_080801_125303_8EF72956)
References: <1338383762.4511.16.camel@jlt3.sipsolutions.net>
	 <CAB3XZEdmWRn-2O65AnfnF-jya_FNXK8gc21EBBoDisNoZGDeRQ@mail.gmail.com>
	 <1338385800.4511.21.camel@jlt3.sipsolutions.net>
	 <CAB3XZEdHgjgN=0kUXngzFaEY0Q=pz8k0UaRFXLMEhjPsLdN8NQ@mail.gmail.com>
	 <CAB3XZEdKbR2bozuXDdPsE09Nj_yq3UFpmuL2wgokX=8UGwptBQ@mail.gmail.com>
	 (sfid-20120531_080801_125303_8EF72956)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-31 at 09:07 +0300, Eliad Peller wrote:
> On Wed, May 30, 2012 at 4:57 PM, Eliad Peller <eliad@wizery.com> wrote:
> > On Wed, May 30, 2012 at 4:50 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >> On Wed, 2012-05-30 at 16:44 +0300, Eliad Peller wrote:
> >>> On Wed, May 30, 2012 at 4:16 PM, Johannes Berg
> >>> <johannes@sipsolutions.net> wrote:
> >>> > When any interface goes down, it could be the one that
> >>> > we were doing off-channel with. Thus, we need to flush
> >>> > the offchannel start/stop work so they can't run when
> >>> > the interface has already been removed from the driver
> >>> > or even been destroyed. It's OK to flush them even if
> >>> > they were for another interface, that just means that
> >>> > we potentially delay the interface down a little bit.
> >>> >
> >>> can't we check hw_roc_dev?
> >>
> >> We could, but it didn't seem worthwhile. Think I should do that instead?
> >>
> > hmm... i guess it doesn't really matter :)
> >
> just gave it a second thought - the driver might have not even called
> ieee80211_ready_on_channel() yet, so i think it's still racy.

Hmmm. Good point. For some reason I thought that wouldn't happen, but I
guess you're right.

I'll need to think more about how we can fix that though. Maybe cfg80211
could request a cancel when the corresponding interface goes down?

johannes

