Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55245 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab0DLOhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 10:37:13 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 07:37:13 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19395.12264.285777.224012@gargle.gargle.HOWL>
Date: Mon, 12 Apr 2010 20:06:24 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sneha Aggarwal <snehaatpec@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Frame aggregation size configuration in 802.11n
In-Reply-To: <1271075716.23799.2.camel@jlt3.sipsolutions.net>
References: <loom.20100412T140919-620@post.gmane.org>
	<1271075716.23799.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> > and where all I have to change this parameter to get the desired output?
> 
> That depends on your driver. In iwlwifi, you have to tell the microcode
> what to do -- I'm not sure off hand how to (I know there is a parameter
> that controls the number of frames in an aggregate, I'm not sure about
> the max size but I would think it exists)
> 
> In ath9k you should be able to change it in the driver but I have no
> idea how to.
> 

If you do decide to fiddle with ath9k, you can change the aggregate size
and the max. no of subframes in an aggregate.

See ath_tx_form_aggr() in xmit.c

(ATH_AMPDU_SUBFRAME_DEFAULT, nframes, aggr_limit, etc ...)

Sujith

