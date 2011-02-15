Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46183 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab1BOMLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 07:11:32 -0500
Subject: Re: [PATCH 1/5] iwlwifi: Simplify tx queue management
From: Johannes Berg <johannes@sipsolutions.net>
To: Nathaniel Smith <njs@pobox.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
In-Reply-To: <AANLkTinA0yoF_dU+2B6+rHcE_DvS7yjqu+TqYzhprvZj@mail.gmail.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	 <1297619803-2832-2-git-send-email-njs@pobox.com>
	 <1297677453.3785.4.camel@jlt3.sipsolutions.net>
	 <AANLkTinA0yoF_dU+2B6+rHcE_DvS7yjqu+TqYzhprvZj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 13:11:28 +0100
Message-ID: <1297771888.3935.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-14 at 14:17 -0800, Nathaniel Smith wrote:

> > I'm pretty sure the devices (but maybe not 3945) implement interrupt
> > mitigation at least in some cases. How did you arrive at the conclusion
> > that "the driver doesn't actually do any interrupt mitigation"?
> 
> Two reasons:
>   -- I searched the code and couldn't find any evidence for it
>   -- If I'm wrong then the quickest way to find out is to make loud
> and confident claims in front of people who know better ;-)
> I might be wrong.

Well, I think you are -- at least for some cases. The driver doesn't
need to do anything to implement mitigation, if anything the ucode will
do this by itself -- I imagine it'll do this especially for aggregation
queues (which I realise aren't relevant in this patch, but still).

johannes

