Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54506 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2JZKU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 06:20:58 -0400
Message-ID: <1351246894.10813.10.camel@jlt4.sipsolutions.net> (sfid-20121026_122101_906334_4299C848)
Subject: Re: [PATCH 2/3] mac80211: verify that skb data is present
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 26 Oct 2012 12:21:34 +0200
In-Reply-To: <1351246782.10813.9.camel@jlt4.sipsolutions.net> (sfid-20121026_121912_401528_AD9E4EDC)
References: <1351205200-18094-1-git-send-email-johannes@sipsolutions.net>
	 <1351205200-18094-3-git-send-email-johannes@sipsolutions.net>
	 <20121025230505.GD20609@shredder> <20121025235816.GE20609@shredder>
	 <20121026005748.GA30982@shredder>
	 (sfid-20121026_025756_120637_43AD3510) <1351246782.10813.9.camel@jlt4.sipsolutions.net>
	 (sfid-20121026_121912_401528_AD9E4EDC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-26 at 12:19 +0200, Johannes Berg wrote:

> Ohh, ok, no I see, I'm not doing that. What we really need to do is
> something entirely different:
> 
>                 if (is_multicast_ether_addr(hdr->addr1)) {
>                         mpp_addr = hdr->addr3;
>                         proxied_addr = mesh_hdr->eaddr1;

where this part is fine because the entire code is inside the AE check
already, so the eaddr1 must exist.

johannes

