Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1AaRk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 12:40:59 -0500
Subject: Re: Why is wmm_param required for HT40- in mlme.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4D46F2E2.3090905@candelatech.com>
References: <4D44F94F.8040707@candelatech.com>
	 <1296380208.3616.0.camel@jlt3.sipsolutions.net>
	 <4D45A128.6060905@candelatech.com>
	 <1296471791.3812.7.camel@jlt3.sipsolutions.net>
	 <4D46F2E2.3090905@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 18:40:59 +0100
Message-ID: <1296495659.3812.36.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 09:35 -0800, Ben Greear wrote:

> > No, I got confused. 802.11n says an HT STA is a QoS STA (5.2.9), but in
> > practice WMM is tested/certified instead of QoS.
> 
> So maybe we can remove that check for wmm_param, but put in a printk
> to warn users that their AP is probably mis-configured?

Yes, but there are hidden assumptions that WMM is available throughout
the code that we need to hunt down first -- I'm sure there are some in
the aggregation code for example since aggregation can only work when
QoS/WMM is enabled.

johannes

