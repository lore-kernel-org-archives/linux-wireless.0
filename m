Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46126 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbeAVNXX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 08:23:23 -0500
Message-ID: <1516627401.2508.30.camel@sipsolutions.net> (sfid-20180122_142326_421633_B572A40B)
Subject: Re: [PATCH v3 4/5] mac80211_hwsim: add permanent mac address option
 for new radios
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Jan 2018 14:23:21 +0100
In-Reply-To: <3dd7a66e-1b55-0300-b04e-489ed1163b96@uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
         <6596c1d9-da4f-4d83-bd5e-5e276391a0c9@MAIL2.uni-rostock.de>
         <1516018472.410.16.camel@sipsolutions.net>
         <3dd7a66e-1b55-0300-b04e-489ed1163b96@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-01-15 at 15:48 +0100, Benjamin Beichler wrote:

> > > +		if (get_hwsim_data_ref_from_addr(
> > > +				nla_data(info->attrs[HWSIM_ATTR_PERM_ADDR]))) {
> > > +			pr_debug("mac80211_hwsim: perm MAC already in use\n");
> > > +			return -EINVAL;
> > > +		}
> > 
> > This is racy afaict - remove it and return a clash later when you fail
> > to insert the new radio.
> 
> Ehm yes, actually exactly this test is already in the rhashtable patch.
> But maybe I should also change there the error print to a NL_ERR_MSG() ?

Oh, really? I just sent that out, but whatever, we have enough time to
fix it :-)

And yes, using netlink extended ack messages here as well would be
good.

johannes
