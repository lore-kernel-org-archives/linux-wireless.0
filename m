Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab2CHOEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 09:04:07 -0500
Subject: Re: [PATCH RESEND 34/35] iwlwifi: correct status bit refactoring
 errors
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>
In-Reply-To: <20120308135529.GA14445@redhat.com> (sfid-20120308_145545_354863_21A18601)
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1331142764-5750-35-git-send-email-wey-yi.w.guy@intel.com>
	 <20120308135529.GA14445@redhat.com> (sfid-20120308_145545_354863_21A18601)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Mar 2012 15:04:00 +0100
Message-ID: <1331215440.3446.5.camel@jlt3.sipsolutions.net> (sfid-20120308_150412_021536_A88D8427)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-08 at 14:55 +0100, Stanislaw Gruszka wrote:

> > +	priv->shrd->status &=
> > +			test_bit(STATUS_FW_ERROR, &priv->shrd->status) <<
> > +				STATUS_FW_ERROR;
> 
> So we have now priv->shrd->status & priv->status, how do you prevent to
> confuse them? Also I still do not understand at all what for this ->shrd stuff
> is needed.

Yeah, hard to not confuse them ... we're removing ->shrd completely, I
have another 25 or so patches and then it'll be gone :-)

johannes

