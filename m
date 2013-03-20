Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CTVzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 17:55:52 -0400
Message-ID: <1363816548.9284.11.camel@jlt4.sipsolutions.net> (sfid-20130320_225556_035281_FDD944CF)
Subject: Re: rcutree tree warning during P2P device support testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: David Spinadel <dvdspndl@gmail.com>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Date: Wed, 20 Mar 2013 22:55:48 +0100
In-Reply-To: <514A2E47.7080108@broadcom.com>
References: <5149CD81.40301@broadcom.com>
	 <1363792139.8224.10.camel@jlt4.sipsolutions.net>
	 <514A274F.5030303@broadcom.com>
	 <1363814947.9284.10.camel@jlt4.sipsolutions.net>
	 <514A2E47.7080108@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-20 at 22:46 +0100, Arend van Spriel wrote:

> > It looks like some rcu head list corruption ... no idea really.
> > 
> 
> I have now (I think). I did a kfree of the driver's vif structure, which
> is container of the wireless_dev and that is still on the rcu head list.

I don't really see why that would be the case though, there's no
call_rcu() or kfree_rcu(), is there?

johannes

