Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbYIPHlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 03:41:46 -0400
From: Helmut Schaa <hschaa@suse.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
Date: Tue, 16 Sep 2008 09:41:41 +0200
Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Jouni Malinen" <j@w1.fi>
References: <200809151416.07552.hschaa@suse.de> <200809151845.35841.hschaa@suse.de> <43e72e890809151821h5d40e750q10c78f4d20d27c79@mail.gmail.com>
In-Reply-To: <43e72e890809151821h5d40e750q10c78f4d20d27c79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809160941.42154.hschaa@suse.de> (sfid-20080916_094150_031844_D1EB3BBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 16. September 2008 03:21:17 schrieb Luis R. Rodriguez:
> On Mon, Sep 15, 2008 at 9:45 AM, Helmut Schaa <hschaa@suse.de> wrote:
> > Ok, I'll sum that up. Moving the policy into user space is a good thing
> > if the quality values are comparable. Once mac80211 recognices a
> > noticable quality change we could use IWEVQUAL to notify user space about
> > it. Furthermore (if desired) the signal could be extended to not only
> > report a value between 0 and 100 but could also contain flags indicating
> > lost beacons, excessive retries etc.
>
> If you are going to add a new sort of notification can you please use
> nl80211? No need to keep wireless extensions on life support.

Sure. Nevertheless I'd like to use the already existing IWEVQUAL (without 
modifications) too. Hence the supplicant's wext-driver could use the plain 
quality value to decide when it is time to trigger a scan while the 
nl80211-driver could use more indicators.

Arguments for or against moving the decision to user space (by notifying the 
supplicant only about signal quality changes without rating the values)?

Thanks,
Helmut
