Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab2BAPdh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 10:33:37 -0500
Date: Wed, 1 Feb 2012 16:33:29 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Luigi Tarenga <luigi.tarenga@gmail.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3.2.2 1/1] rt2800lib: fix wrong -128dBm when signal is
 stronger than -12dBm
Message-ID: <20120201153249.GA16461@redhat.com> (sfid-20120201_163341_030459_59600229)
References: <CAKkO-EhQJfKZKTPVZH5-RvPDa8BSrbktEBYPuAHHPvQfhYZzog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKkO-EhQJfKZKTPVZH5-RvPDa8BSrbktEBYPuAHHPvQfhYZzog@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 06:51:23PM +0100, Luigi Tarenga wrote:
> This patch correct the type of variables containing the rssi
> values read from the rxwi.
> 
> In function rt2800_agc_to_rssi() 3 variables (rssi0, rssi1, rss2)
> defined as int was assigned a 16bit signed values as unsigned.
> From a test with a hi-gain antenna I verified that the rxwi
> contains signed rssi values in the  range -13/+81 (inclusive)
> with 0 as an error condition. In case of negative values a
> condition is triggered and the function return -128dBm while
> the signal is at its maximum. This patch correct the cast so
> negative values are not treated as very high positive values
> (ex. -13 does not become 243).
> 
> Signed-off-by: Luigi Tarenga <luigi.tarenga@gmail.com>

Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>

Description is a bit embroiled, but patch is correct. Since rssi value
is exported to user space and can be use i.e to choose to withch AP
try to associate, I think this is a -stable sutiable fix.
