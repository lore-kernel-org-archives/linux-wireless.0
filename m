Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46128 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaIQEyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 00:54:17 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21529.5141.845629.86918@gargle.gargle.HOWL> (sfid-20140917_065420_959447_F588C740)
Date: Wed, 17 Sep 2014 10:24:45 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
In-Reply-To: <1410928422-25587-1-git-send-email-sujith@msujith.org>
References: <1410928422-25587-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> With drivers that support multi-channel concurrency,
> make sure that the correct context is in use before
> sending a deauth frame. The driver could be in a different
> context, in which case the frame could be dropped.

The behavior appears to have been changed in:

commit 8c7d857c4a4a552d8d3e1b2e24e1864ec2989285
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Wed Jul 25 01:42:36 2012 +0300

    mac80211: don't call mgd_prepare_tx when associated


I am not sure how it can be guaranteed that the driver is
on the right context when trying to send a mgmt frame.
ath9k uses mgd_prepare_tx() to switch to the required context,
so I think this call is necessary even if we are associated.

Sujith
