Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53140 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbbAEJWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 04:22:07 -0500
Message-ID: <1420449724.1898.1.camel@sipsolutions.net> (sfid-20150105_102218_871541_D6B3C429)
Subject: Re: [PATCH net-next] Allow to set net namespace for wireless device
 via RTM_LINK
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Kochan <vadim4j@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 05 Jan 2015 10:22:04 +0100
In-Reply-To: <CAMw6YJKLWQmT-fqg1QLDHbCxnpxWyJUSX+wvOB_pFyE=8HfSfQ@mail.gmail.com> (sfid-20141224_104849_030943_677BDE3C)
References: <1410467723-2550-1-git-send-email-vadim4j@gmail.com>
	 <1411075535.2034.5.camel@jlt4.sipsolutions.net>
	 <20141014121627.GA5115@angus-think.lan>
	 <1413798437.10246.12.camel@jlt4.sipsolutions.net>
	 <128188DF-5A9B-47A5-8A89-974CF7CF9064@holtmann.org>
	 <1413802344.10246.20.camel@jlt4.sipsolutions.net>
	 <CAMw6YJKLWQmT-fqg1QLDHbCxnpxWyJUSX+wvOB_pFyE=8HfSfQ@mail.gmail.com>
	 (sfid-20141224_104849_030943_677BDE3C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-24 at 11:48 +0200, Vadim Kochan wrote:

>     1) Set NETIF_F_NETNS_LOCAL for phy wireless device only if there
> is at least one virtual interface which was created on it

You mean at least two? I'd think the behaviour becomes hard to predict,
but I guess ultimately that'd be somewhat reasonable.

>     2) What about to inherit netns for newer created interfaces from
> the phy device ?

Hmm? This already happens - a given phy is only in a single netns and
all interfaces must be created in the same netns.

johannes

