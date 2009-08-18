Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:2247 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759390AbZHRRGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 13:06:34 -0400
Subject: Re: status of AP mode in iwlwifi?
From: reinette chatre <reinette.chatre@intel.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <45e8e6c40908171413s72d8a245vfab18283ae85eecf@mail.gmail.com>
References: <45e8e6c40908171413s72d8a245vfab18283ae85eecf@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 10:06:34 -0700
Message-Id: <1250615194.30019.14169.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrey,

On Mon, 2009-08-17 at 14:13 -0700, Andrey Yurovsky wrote:
> Hi folks.  What's the status of AP mode in iwlwifi?  I used it some
> time in the past but I see that it's disabled in wireless-testing now.
>  Is there an issue with AP mode in this driver?  Can it be re-enabled?

Some details can be found in the patch that disabled AP mode (see
below). It cannot be re-enabled until the issues mentioned in this patch
have been addressed ... and the AP mode requirements mentioned in
http://wireless.kernel.org/en/developers/Documentation/mac80211/API
needs to be reviewed also.

commit 44b73f240da0d18a2d17afca488e8c80496d92ca
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Mon Dec 1 18:50:27 2008 +0100

    iwlwifi: disable AP mode
    
    iwlwifi does not support AP mode in any way. For one, it doesn't even
    buffer multicast/broadcast frames properly. We didn't allow zd1211rw AP
    mode to be enabled without this, so iwlwifi shouldn't be allowed to
    advertise AP mode either.
    
    It also doesn't work at all, it doesn't even answer to probe requests,
    I'm guessing the packet injection code was disabled again.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Acked-by: Reinette Chatre <reinette.chatre@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


Reinette


