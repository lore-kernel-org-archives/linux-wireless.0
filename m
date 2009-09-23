Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4997 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZIWMCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 08:02:38 -0400
Date: Wed, 23 Sep 2009 07:59:49 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Jouni.Malinen" <Jouni.Malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Flush TX - wireless summit topic
Message-ID: <20090923115949.GA24051@hash.localnet>
References: <43e72e890909221541u67fa291fq353327d1d55841f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890909221541u67fa291fq353327d1d55841f2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 22, 2009 at 03:41:50PM -0700, Luis R. Rodriguez wrote:
> flush prior to channel change? Well one theory discussed was that we
> would see that issue disappear if we actually did a proper TX flush
> prior to channel change since we expect we would not see further
> incoming frames from our AP if we told it we were going to PS (sending
> a null func frame).

Yeah, but due to the way ath5k defers frames, there's still a race
condition (queue some packets, flush TX to send out the nullfunc frame,
then RX tasklet runs on unprocessed packets).  I don't think TX flush
would hurt though, then we could probably drop the driver-side code
that tries to do the same.

-- 
Bob Copeland %% www.bobcopeland.com

