Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:51005
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbXC1VJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 17:09:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
Date: Wed, 28 Mar 2007 23:08:43 +0200
Cc: mohamed <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com> <1175106180.5151.76.camel@johannes.berg>
In-Reply-To: <1175106180.5151.76.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703282308.43274.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 March 2007 20:23, Johannes Berg wrote:
> > +	while ((u8*)eth < skb->data + skb->len) {
> 
> I don't understand this cast of eth to u8*. That seems wrong given that
> there's an ethhdr there where the first byte isn't a length byte.

We're not comparing the data eth points to here, but the eth pointer
itself. It's pretty weird code. Maybe this can be solved in a
more clear way. But it might be correct as-is.

-- 
Greetings Michael.
