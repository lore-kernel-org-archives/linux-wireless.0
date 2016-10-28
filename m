Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53468 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964911AbcJ1PqG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Oct 2016 11:46:06 -0400
Message-ID: <1477669560.4220.1.camel@sipsolutions.net> (sfid-20161028_174610_493371_EB86FDF4)
Subject: Re: [PATCH] mac80211: Ignore VHT IE from peer with wrong rx_mcs_map
From: Johannes Berg <johannes@sipsolutions.net>
To: Filip Matusiak <filip.matusiak@tieto.com>,
        linux-wireless@vger.kernel.org
Cc: marek.kwaczynski@tieto.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2016 17:46:00 +0200
In-Reply-To: <1477665523-8970-1-git-send-email-filip.matusiak@tieto.com> (sfid-20161028_163919_221476_0288EF78)
References: <1477665523-8970-1-git-send-email-filip.matusiak@tieto.com>
         (sfid-20161028_163919_221476_0288EF78)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-28 at 16:38 +0200, Filip Matusiak wrote:
> This is a workaround for VHT-enabled STAs which break the spec
> and have the VHT-MCS Rx map filled in with value 3 for all eight
> spacial streams.
> 
> As per spec, in section 22.1.1 Introduction to the VHT PHY
> A VHT STA shall support at least single spactial stream VHT-MCSs
> 0 to 7 (transmit and receive) in all supported channel widths.

Interesting, and also kinda dumb :)

> +	/*
> +	 * This is a workaround for VHT-enabled STAs which break the
> 

I find that it helps, in the future, if we know an example of a station
that did this, so we can test other implementations etc. Can you change
the comment accordingly?

johannes
