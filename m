Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:33333 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750756Ab2DDUJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 16:09:10 -0400
Message-ID: <1333570148.23520.18.camel@joe2Laptop> (sfid-20120404_220914_088463_A9DE7FDF)
Subject: Re: [PATCH 2/2] ath6kl: handle concurrent AP-STA channel switches
From: Joe Perches <joe@perches.com>
To: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Date: Wed, 04 Apr 2012 13:09:08 -0700
In-Reply-To: <20120404200008.GA19758@pista>
References: <1333565817-18816-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 <1333565817-18816-2-git-send-email-c_tpeder@qca.qualcomm.com>
	 <1333566178.16978.29.camel@joe2Laptop> <20120404200008.GA19758@pista>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-04-04 at 13:00 -0700, Pedersen, Thomas wrote:
> > > +	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "channel switch notify nw_type %d"
> > > +		   "freq %d mode %d", vif->nw_type, channel, mode);
> > 
> > Please coalesce formats.
> > If you had, you'd've seen a problem with this format.
> > Add a newline "\n" terminator to it too.
> 
> I'm not sure what you mean by "coalesce formats". The freq / channel
> semantic mismatch? I'll change that and add a newline as well.

There's currently no space between a "%d" and "freq".
There should be one.  It'd be better and less error
prone like this:

	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
		   "channel switch notify nw_type %d freq %d mode %d\n",
vif->nw_type, channel, mode);

cheers, Joe

