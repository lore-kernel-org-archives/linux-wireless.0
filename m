Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2JFOrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2012 10:47:21 -0400
Message-ID: <1349534867.10251.0.camel@jlt4.sipsolutions.net> (sfid-20121006_164725_009082_589D26B4)
Subject: Re: [PATCH 3.7 1/2] cfg80211: fix antenna gain handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com
Date: Sat, 06 Oct 2012 16:47:47 +0200
In-Reply-To: <50702371.40508@openwrt.org>
References: <1349286707-64433-1-git-send-email-nbd@openwrt.org>
	 <20121005202220.GA1929@tuxdriver.com> <506F4AFE.2090301@broadcom.com>
	 <506F69FF.5090701@openwrt.org> <506FE541.3090706@broadcom.com>
	 <50702371.40508@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-10-06 at 14:26 +0200, Felix Fietkau wrote:

> > I was not understanding the usage scenario here. Your patch will ignore 
> > any driver initialized max antenna gain, which does not sound right to 
> > me. What if chan->orig_mag is a sensible (non-zero) value, which is 
> > lower than the value in regulatory power rule? Just seems that the patch 
> > changes more than the commit message it saying.
> I did take another close look at the code and it seems you're right. I
> will change the code so that it initializes chan->orig_mag to INT_MAX in
> wiphy_register, and I will make the patch description a bit more verbose
> as well.
> That way the chan->max_antenna_gain value supplied by the driver gets
> ignored, which is a good thing, considering that only one driver
> actually uses max_antenna_gain, and no driver initializes it to
> something useful.

I know we need the "limit to driver value" behaviour for TX power for
sure (otherwise the firmware would assert if it goes over)

johannes

