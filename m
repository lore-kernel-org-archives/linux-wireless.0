Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:50093 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028Ab3BOMkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 07:40:52 -0500
Received: by mail-ie0-f178.google.com with SMTP id c13so4582862ieb.23
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2013 04:40:51 -0800 (PST)
Date: Fri, 15 Feb 2013 07:40:46 -0500
From: Bob Copeland <me@bobcopeland.com>
To: devel@lists.open80211s.org
Cc: Marco Porsch <marco@cozybit.com>, vthiagar@qca.qualcomm.com,
	jouni@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	senthilb@qca.qualcomm.com
Subject: Re: [PATCH 1/3] mac80211: move mesh sync beacon handler into
 neighbour_update
Message-ID: <20130215124046.GA3493@localhost> (sfid-20130215_134055_908224_BAF7A78F)
References: <1360928446-543-1-git-send-email-marco@cozybit.com>
 <1360930499.15040.7.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360930499.15040.7.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2013 at 01:14:59PM +0100, Johannes Berg wrote:
> On Fri, 2013-02-15 at 12:40 +0100, Marco Porsch wrote:
> 
> > -	/* The current tsf is a first approximation for the timestamp
> > -	 * for the received beacon.  Further down we try to get a
> > -	 * better value from the rx_status->mactime field if
> > -	 * available. Also we have to call drv_get_tsf() before
> > -	 * entering the rcu-read section.*/
> 
> I don't think you should drop this comment; also why not just address
> it? There's a timestamp in rx_status that should be the correct one for
> ath9k (which is pretty much all this seems to work on anyway :) )

The comment is just moved?  Mesh already uses rx_status->mactime, if
the driver supplies it, which the comment says :)

-- 
Bob Copeland %% www.bobcopeland.com
