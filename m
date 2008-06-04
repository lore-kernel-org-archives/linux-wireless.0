Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52572
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753897AbYFDWse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 18:48:34 -0400
Date: Wed, 04 Jun 2008 15:48:34 -0700 (PDT)
Message-Id: <20080604.154834.80521372.davem@davemloft.net> (sfid-20080605_004838_435607_38145799)
To: mokuno@sm.sony.co.jp
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/12]: Proper compat WEXT support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080604184955.B033.40F06B3A@sm.sony.co.jp>
References: <20080603.132755.262737024.davem@davemloft.net>
	<20080604184955.B033.40F06B3A@sm.sony.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Date: Wed, 04 Jun 2008 19:09:06 +0900

> I'm testing these patches on my PS3.  I've found a problem.
> 
> With 32-bit wireless-tools v28, the bitrates from the scan result were
> wrong (with gelic/rt2x00 driver):

Thanks, I'll look into this when I get a chance.

I want to redesign the interfaces so that the callers give
enough information to the helper routines such that the
compat stuff can be handled completely inside of the
helpers.

It is unpleasant (and error prone) to put this compat handling
at all of the call sites.
