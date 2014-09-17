Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32923 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaIQFBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 01:01:36 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Sujith Manoharan <sujith@msujith.org>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
Date: Wed, 17 Sep 2014 05:01:31 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B523034@hasmsx107.ger.corp.intel.com> (sfid-20140917_070139_025553_B6C64556)
References: <1410928422-25587-1-git-send-email-sujith@msujith.org>
 <21529.5141.845629.86918@gargle.gargle.HOWL>
In-Reply-To: <21529.5141.845629.86918@gargle.gargle.HOWL>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Sujith Manoharan wrote:
> > From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> >
> > With drivers that support multi-channel concurrency, make sure that
> > the correct context is in use before sending a deauth frame. The
> > driver could be in a different context, in which case the frame could
> > be dropped.
> 
> The behavior appears to have been changed in:
> 
> commit 8c7d857c4a4a552d8d3e1b2e24e1864ec2989285
> Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Date:   Wed Jul 25 01:42:36 2012 +0300
> 
>     mac80211: don't call mgd_prepare_tx when associated
> 
> 
> I am not sure how it can be guaranteed that the driver is on the right context
> when trying to send a mgmt frame.
> ath9k uses mgd_prepare_tx() to switch to the required context, so I think
> this call is necessary even if we are associated.
> 

Why are mgmt frames different from data frames with respect to that?
You have a separated queue for mgmt frames that is common to all the contexts?
Just like an "offchannel" queue?
