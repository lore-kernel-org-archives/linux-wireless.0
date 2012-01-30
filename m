Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2A3Ovy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 09:51:54 -0500
Subject: Re: [PATCH] mac80211: Do not scan for IBSS merge with a fixed
 BSSID.
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4F265AB6.6010004@lri.fr>
References: <1327581394-15368-1-git-send-email-cavallar@lri.fr>
	 (sfid-20120126_133659_805161_39F32A75) <4F237C16.5050100@sipsolutions.net>
	 <4F265AB6.6010004@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jan 2012 06:51:48 -0800
Message-ID: <1327935108.3630.1.camel@jlt3.sipsolutions.net> (sfid-20120130_155157_580193_46A06131)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-30 at 09:54 +0100, Nicolas Cavallari wrote:
> On 28/01/2012 05:39, Johannes Berg wrote:
> > On 1/26/2012 4:36 AM, Nicolas Cavallari wrote:
> > 
> >> -    if (ifibss->fixed_channel)
> >> +    if (ifibss->fixed_bssid)
> >>           return;
> >>
> >>       printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for
> >> other "
> >>              "IBSS networks with same SSID (merge)\n", sdata->name);
> > 
> > Just from the looks of it, this doesn't seem right. If you're fixing the
> > BSSID, you're still asking for automatic channel selection and merging
> > with other peers using the same BSSID on different channels, so I
> > disagree with your commit message quite completely.
> 
> I didn't know that. In fact, from my understanding of the current
> source, if you fix the BSSID, you won't merge, period. And even if you
> don't fix the BSSID, if you found a BSS with the same BSSID but a
> different channel, you still won't merge.
> 
> And now, if you are alone and you fixed your channel, you won't try to
> merge with other BSS in the same channel.
> 
> If you believe that the condition should be "fixed_bssid &&
> fixed_channel", i can send another patch.


No, I don't think that makes sense either. I haven't looked at the
actual code right now (am travelling), but I think the logic should be:

fixed BSSID: try to find networks with that BSSID, if alone, on all
channels
fixed channel: merge with any network with the same SSID on the same
channel

fixed both: just stick to the current channel/BSSID (obviously)

johannes

