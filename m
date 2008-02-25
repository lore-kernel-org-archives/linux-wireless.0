Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:50680 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYBYVNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 16:13:38 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1127551rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 13:13:37 -0800 (PST)
Subject: Re: [PATCH 08/13 v2] o11s: other changes in mac80211 for mesh
	interface support
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>
In-Reply-To: <20080223074133.32a4609c@morte>
References: <47be7741.05d6720a.44c4.ffffd0c9@mx.google.com>
	 <20080223074133.32a4609c@morte>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 13:15:13 -0800
Message-Id: <1203974113.6929.93.camel@localhost> (sfid-20080225_211342_774013_B2D4C87A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-02-23 at 07:41 +0100, Stefano Brivio wrote:
> I'd like to have this moved, maybe right before this:
> 
>         /* Compute the controller output. */

Ok.

> 
> >  		pf <<= RC_PID_ARITH_SHIFT;
> > +		sta->fail_avg = ((pf + (spinfo->last_pf << 3)) / 9)
> > +					>> RC_PID_ARITH_SHIFT;
> >  	}
> 
> What do you need fail_avg for? Please note that we have better estimates of
> the frame failure trends (e.g., err_avg). What these magic values are?

It's supposed to be an estimation of the probability of a frame
transmission failure. The magic numbers just express the formula

fail_avg = (8 * old_fail_avg + 1 * fail_avg) / 9

a simple smoothing, there is nothing special to the exact numbers.

If you think err_avg is a good candidate (is it also 0-100?) I'd be
happy to use that instead.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


