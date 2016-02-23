Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:60373 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755279AbcBWVI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 16:08:26 -0500
Date: Tue, 23 Feb 2016 23:08:21 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Let VHT work on 2.4Ghz
Message-ID: <20160223210821.GA8062@w1.fi> (sfid-20160223_220829_299722_3AD4AA12)
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com>
 <1456236627.9910.10.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456236627.9910.10.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2016 at 03:10:27PM +0100, Johannes Berg wrote:
> What you really "want" is to use VHT modulations, mostly for the
> dubious purpose of marketing benchmarks to reach 256-QAM modulations.
> 
> I think the de-facto standard for this would be to use IEs similar to
> VHT ones, encapsulated in some (Broadcom?) vendor IE. We may have to
> work with that, but that's not what this patch does. Jouni had some
> better idea how this worked, I think.

hostapd has code to negotiate this using the vendor specific element. I
think we ended up getting this working with AP side (i.e., ath10k on the
AP) and if I've understood correctly, this does not need any additional
changes on top of what is available in upstream kernel and hostapd.

Station mode is something that may have been left open since this issue
of what and how to advertise as capabilities came up and there was not
strong enough push at the time to get more than AP side functional..

-- 
Jouni Malinen                                            PGP id EFC895FA
