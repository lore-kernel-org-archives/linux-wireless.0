Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51371 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab2K0ItX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 03:49:23 -0500
Date: Tue, 27 Nov 2012 11:49:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: ath9k: Add concurrent WLAN and BT tx support for MCI based chips
Message-ID: <20121127084908.GS6186@mwanda> (sfid-20121127_094938_653465_2E119878)
References: <20121126210337.GA27645@elgon.mountain>
 <20121127082832.GA11602@hemis.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121127082832.GA11602@hemis.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 27, 2012 at 01:58:35PM +0530, Rajkumar Manoharan wrote:
> On Tue, Nov 27, 2012 at 12:03:37AM +0300, Dan Carpenter wrote:
> > Hello Rajkumar Manoharan,
> > 
> > The patch db60428b1af1: "ath9k: Add concurrent WLAN and BT tx support
> > for MCI based chips" from Oct 12, 2012, leads to the following
> > warning:
> > drivers/net/wireless/ath/ath9k/btcoex.c:414
> > 	ath9k_hw_btcoex_set_concur_txprio()
> > 		error: buffer overflow 'stomp_txprio' 4 <= 4
> > 
> Dan,
> 
> Thanks a lot. Is there a way to enable all checks while building smatch tool?
> 

This one requires the sqlite database to get the cross function
info.  It's a two compile process, the first builds the db and the
next does the test.  Replace the path names as appropriate:

~/progs/smatch/devel/smatch_scripts/build_kernel_data.sh
~/progs/smatch/devel/smatch_scripts/test_kernel.sh

regards,
dan carpenter

