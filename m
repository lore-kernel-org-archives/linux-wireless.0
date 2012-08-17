Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab2HQOHP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2012 10:07:15 -0400
Date: Fri, 17 Aug 2012 16:06:58 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
Message-ID: <20120817140657.GA1645@redhat.com> (sfid-20120817_160720_374165_1ABF9220)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCDD559@mbx022-e1-nj-10.exch022.domain.local>
 <20120816102211.GD17659@redhat.com>
 <502CF2D5.6020704@posedge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <502CF2D5.6020704@posedge.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 16, 2012 at 06:47:09PM +0530, Mahesh Palivela wrote:
> On 8/16/2012 3:52 PM, Stanislaw Gruszka wrote:
> >On Tue, Aug 14, 2012 at 03:55:26PM +0000, Mahesh Palivela wrote:
> >>Handling of 80 MHz, 160 MHz channel bandwidths for VHT (11ac) Regulatory
> >>and setting channel flags for allowed bandwidths.
> >>
> >>Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
> >>---
> >>
> >>Sending patch second time as Stanislaw Gruszka complained its malformed.
> >
> >And now complaining that patch is ugly. There is really on other,
> >simpler way to handle that?
> >
> >Stanislaw
> >
> oh, you mean my implementation is ugly? Not a problem. Give me some
> clue, I will work on it.

We can not extend channel, if regulatory disallow to use some
nearby channels or disallow HT at all.

So it's not possible that for particular channel that we can extend it
to let say -160|0+ and -0|160+, but can not extend it to -40|120+. So
we do not need zilion flags, but just specify left and right borders,
inside which we can extend channel.

For example: channel 36 (5180 MHz) is prohibited and all channels
above are allowed. For channel 52 (5260 MHz) left border will be
-60 and right border +160 (max). That will allow to support
VHT160: -60|100+, -40|120+, -20|140+, -0|160+ ;
VHT80: -60|20+, -40|40+, -20|60+, -0|80+ ;
HT40 :-40|0+, -0|40+

Stanislaw
