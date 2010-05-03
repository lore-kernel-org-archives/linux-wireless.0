Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56493 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab0ECRsz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 13:48:55 -0400
Subject: Re: [PATCH] iwlagn: Change the TPT calculations sanity-check to
 WARN_ON
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johill@sipsolutions.net" <johill@sipsolutions.net>,
	Adel Gadllah <adel.gadllah@gmail.com>
In-Reply-To: <1272907549-25847-1-git-send-email-linville@tuxdriver.com>
References: <1272907549-25847-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 10:48:54 -0700
Message-ID: <1272908934.7879.5748.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-03 at 10:25 -0700, John W. Linville wrote:
> From: Adel Gadllah <adel.gadllah@gmail.com>
> 
> Currently it is a BUG_ON() which will hang the machine once triggered.
> 
> (Changed from WARN_ON to WARN_ON_ONCE. -- JWL)
> 
> Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

I can see a potential race condition here in the calculation of the
average throughput so a BUG_ON seems extreme.

I looked at the history of this code and it seems as though the BUG_ON was
added as a sidenote to a patch implementing something else. 

The patch adding this BUG_ON is:

commit 3110bef78cb4282c58245bc8fd6d95d9ccb19749
Author: Guy Cohen <guy.cohen@intel.com>
Date:   Tue Sep 9 10:54:54 2008 +0800

    iwlwifi: Added support for 3 antennas


... and it thus seems as though this BUG_ON was added along the way while doing
something else ... especially considering that the comments describing the
original code has not been removed yet. Since the current code still contains:

        /* Else we have enough samples; calculate estimate of
         * actual average throughput */

.. .which is obviously not done right now.

I looked at the original code and think we can revert the portion of this patch
adding the BUG_ON. Since users have not encountered the error I assume the
author considered that a BUG_ON was warranted, but now we know that users do
indeed encounter the error and we should return the original code.

I'll send the revert as a separate patch.

Reinette


