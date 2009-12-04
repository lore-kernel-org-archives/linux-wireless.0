Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46887 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbZLDMm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 07:42:29 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2009 04:42:36 -0800
Date: Fri, 4 Dec 2009 18:12:21 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] mac80211: Fix bug in computing crc over dynamic IEs in
	beacon
Message-ID: <20091204124220.GC27936@vasanth-laptop>
References: <1259928694-7824-1-git-send-email-vasanth@atheros.com> <1259929798.29974.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1259929798.29974.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 04, 2009 at 05:59:58PM +0530, Johannes Berg wrote:
> > In ieee802_11_parse_elems_crc(),
> > BIT() is suppossed to get the bit value more than 31 (42 (id of ERP_INFO_IE),
> > 37 (CHANNEL_SWITCH_IE), (42), 32 (POWER_CONSTRAINT_IE), 45 (HT_CAP_IE),
> > 61 (HT_INFO_IE)). As we do not get the required bit value for the above
> > IEs, crc over these IEs are never calculated, so any dynamic change in these
> > IEs after the association is not really handled on 32-bit platforms.
> > This patch fixes this issue.
> 
> Right. Note that this function may need to be changed/extended if we
> ever need to watch for changes in even higher IEs, but so far we don't.

Yeah, currently we do only for the IEs whose ids are < 64.

Thanks,

Vasanth

