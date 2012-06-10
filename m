Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:21055 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2FJPjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 11:39:49 -0400
Date: Sun, 10 Jun 2012 18:39:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch v2] iwlwifi: turn on a lockdep assertion
Message-ID: <20120610153920.GP4400@mwanda> (sfid-20120610_174021_636742_65BC3325)
References: <20120610112521.GA20676@elgon.mountain>
 <4FD4BC51.80407@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FD4BC51.80407@bfs.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 10, 2012 at 05:25:05PM +0200, walter harms wrote:
> 
> 
> Am 10.06.2012 13:25, schrieb Dan Carpenter:
> > CMD_SYNC is zero so the if (cmd->flags & CMD_SYNC) is never true and we
> > never check the assertion.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > v2: enables the assertion even more than v1 (based on feedback from
> > Johannes Berg).
> 
> The important part is CMD_SYNC -> CMD_ASYNC

Not really, no.  I considered Johannes's version for my first patch
but I decided to be conservative because I didn't know the code well
enough to say what is safe.

regards,
dan carpenter
