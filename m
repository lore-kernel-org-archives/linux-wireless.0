Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60505 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0LHUaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 15:30:07 -0500
Date: Wed, 8 Dec 2010 15:27:38 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] mac80211: reduce the probe response timeout after
 beacon loss
Message-ID: <20101208202738.GG2423@tuxdriver.com>
References: <1290203740-57124-1-git-send-email-nbd@openwrt.org>
 <1290203740-57124-2-git-send-email-nbd@openwrt.org>
 <1290203740-57124-3-git-send-email-nbd@openwrt.org>
 <1290203740-57124-4-git-send-email-nbd@openwrt.org>
 <4CE734D9.90103@openwrt.org>
 <AANLkTikCn2GjLxfQZLw9Tj8cyH_bgGpEDiGpKVg0faht@mail.gmail.com>
 <4CEA8113.9070806@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CEA8113.9070806@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 22, 2010 at 03:41:23PM +0100, Felix Fietkau wrote:
> On 2010-11-22 7:49 AM, Mohammed Shafi wrote:
> > On Sat, Nov 20, 2010 at 8:09 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> >> On 2010-11-19 10:55 PM, Felix Fietkau wrote:
> >>> Waiting for 500 ms after sending a probe request seems a bit excessive,
> >>> especially when doing 5 attempts. If the connection is bad enough to make
> >>> multiple requests time out, then user space should try to quickly find a
> >>> new AP.
> > This might improve fail over roaming to a small extent but  as per the
> > commit id d1c5091f23fed5195271e2849f89017d3a126521 it was mentioned
> > this might affect robustness against 'slow AP's'
> > 
> >> Hmm, don't merge this patch yet, it can cause background scans to
> >> trigger reconnects.
> >>
> > I am not sure  how this affects background scan.bgscan will be enabled
> > even before the beacon loss and it is based on RSSI(please correct me
> > if I am wrong).
> I'm not sure either, this showed up in my tests. I'm pretty sure that
> this change is not the root cause, but I don't want to see it merged
> until the cause is figured out. My guess is that it's related to the
> issues with the nullfunc probe request patch that Paul pointed out.
> I'll do some more testing after I've fixed that one.

I'm dropping this from my queue -- please repost if you decide it
is warranted.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
