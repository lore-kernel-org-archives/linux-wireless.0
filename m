Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab1FCVjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 17:39:12 -0400
Subject: Re: [PATCH 2/6] NFC: add nfc generic netlink interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Aloisio Almeida <aloisio.almeida@openbossa.org>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcio.macedo@openbossa.org,
	sameo@linux.intel.com, Waldemar.Rymarkiewicz@tieto.com
In-Reply-To: <BANLkTim_d839pWW4DPeH+6o03wN8HbgBxQ@mail.gmail.com> (sfid-20110603_233628_817025_AE08F45E)
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
	 <1307051170-17374-3-git-send-email-lauro.venancio@openbossa.org>
	 <1307108661.3800.6.camel@jlt3.sipsolutions.net>
	 <BANLkTikS+cssYccjg_SfOhR15N=M9erw6Q@mail.gmail.com>
	 <1307133509.3800.10.camel@jlt3.sipsolutions.net>
	 <BANLkTim_d839pWW4DPeH+6o03wN8HbgBxQ@mail.gmail.com>
	 (sfid-20110603_233628_817025_AE08F45E)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 23:39:08 +0200
Message-ID: <1307137148.3800.13.camel@jlt3.sipsolutions.net> (sfid-20110603_233915_483089_7CD35A72)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-03 at 18:35 -0300, Aloisio Almeida wrote:
> On Fri, Jun 3, 2011 at 5:38 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2011-06-03 at 17:18 -0300, Lauro Ramos Venancio wrote:
> >> We don't need a generation counter here because we have the events
> >> NFC_EVENT_DEVICE_ADDED and NFC_EVENT_DEVICE_REMOVED. So, it is
> >> possible to keep the device list consistency listening for these
> >> events.
> >
> > That may be true, but it complicates coding in userspace. Much easier to
> > check a generation counter (in both cases) to see if data is consistent
> > than to listen to multiple events concurrently with receiving a dump.
> 
> The userspace must listen to these events anyway. In addition, the
> application needs to get the list of devices only once (on its
> initialization).
> 
> In the target list case, the userspace application would have to
> orderly call start_poll before receive the dump in order to create the
> "invalid list" situation.

I think you're considering only the current applications, and new ones
might be developed, but whatever, I'll let it rest since I don't
particularly care anyway.

johannes

