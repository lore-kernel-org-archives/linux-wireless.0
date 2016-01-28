Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43234 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbcA1Mau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 07:30:50 -0500
Date: Thu, 28 Jan 2016 15:30:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Chris Bainbridge <chris.bainbridge@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	aryabinin@virtuozzo.com, Julia Lawall <Julia.Lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] net/mac80211/agg-rx.c: fix use of uninitialised values
Message-ID: <20160128123022.GB13219@mwanda> (sfid-20160128_133131_757251_09ED0150)
References: <20160126111730.GA6765@localhost>
 <20160127154618.GA5717@localhost>
 <CAGRGNgXkvNfzM9Q1RO5kFwUWpFZbQ3mNQi3aVHcPTCw0A9fyFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGRGNgXkvNfzM9Q1RO5kFwUWpFZbQ3mNQi3aVHcPTCw0A9fyFA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not the return where we should trigger the warning it's at the

	rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], tid_agg_rx);

line.  That's for correctness, but also it should be slightly easier.
Or it should cut down on false positives if we ignored returns and only
looked global scope type assignements.

regards,
dan carpenter

