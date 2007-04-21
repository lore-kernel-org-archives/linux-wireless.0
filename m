Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:60851 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030866AbXDUNm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 09:42:56 -0400
Date: Sat, 21 Apr 2007 15:42:10 +0200
From: Joerg Mayer <jmayer@loplof.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] ieee80211: Output frequency rather than channel in scan results
Message-ID: <20070421134210.GA15350@thot.informatik.uni-kl.de>
References: <46299244.Q+HmhPpbYVGidoy1%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46299244.Q+HmhPpbYVGidoy1%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 20, 2007 at 11:25:40PM -0500, Larry Finger wrote:
> +	if (network->channel < 15)
> +		iwe.u.freq.m = 2407 + 5 * network->channel;
> +	else
> +		iwe.u.freq.m = 5000 + 5 * network->channel;
> +	if (network->channel == 14)
> +		iwe.u.freq.m = 2484;    /* special case for Japan */

As you are taking japanese channels into account: How about handling the
 >= 4.9 GHz case for Japan as well?
See 802.11j-2004.pdf 17.3.8.3.2, 17.3.8.3.3 and table J.3 for details.

 ciao
    Joerg
-- 
Joerg Mayer                                           <jmayer@loplof.de>
We are stuck with technology when what we really want is just stuff that
works. Some say that should read Microsoft instead of technology.
