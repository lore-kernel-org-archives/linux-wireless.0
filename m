Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52018 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbZBIUGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 15:06:39 -0500
Date: Mon, 9 Feb 2009 22:06:27 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: reject extra IEs for probe resp when hw_scan
Message-ID: <20090209200627.GA17463@jm.kir.nu> (sfid-20090209_210643_232243_0A34E9D8)
References: <1234209631.4175.242.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1234209631.4175.242.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 09, 2009 at 09:00:31PM +0100, Johannes Berg wrote:
> We cannot currently hand off extra IEs to hw_scan, so reject
> configuring extra IEs for probe response frames when hw_scan
> is set.

Assuming this was for probe request.. I'm actually planning on adding
support to pass the extra IEs into hw_scan handler, so that would need
to revert this type of patch for probe req should one make in. Anyway,
that will also make it more difficult to figure out whether the IEs can
actually be added since the driver would need to somehow indicate
whether it supports this or not.

-- 
Jouni Malinen                                            PGP id EFC895FA
