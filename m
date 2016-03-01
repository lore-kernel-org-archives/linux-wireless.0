Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35900 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434AbcCAOpq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 09:45:46 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.86)
	(envelope-from <johannes@sipsolutions.net>)
	id 1aalYX-0004LP-0m
	for linux-wireless@vger.kernel.org; Tue, 01 Mar 2016 15:45:45 +0100
Message-ID: <1456843543.3926.31.camel@sipsolutions.net> (sfid-20160301_154550_154582_351894AB)
Subject: Re: [PATCH] mac80211: check PN correctly for GCMP-encrypted
 fragmented MPDUs
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 01 Mar 2016 15:45:43 +0100
In-Reply-To: <1456521407-19915-1-git-send-email-johannes@sipsolutions.net> (sfid-20160226_221658_536889_F86C99E6)
References: <1456521407-19915-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20160226_221658_536889_F86C99E6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-02-26 at 22:16 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Just like for CCMP we need to check that for GCMP the fragments
> have PNs that increment by one; the spec was updated to fix this
> security issue and now has the following text:
> 
> 	The receiver shall discard MSDUs and MMPDUs whose constituent
> 	MPDU PN values are not incrementing in steps of 1.
> 
> Adapt the code for CCMP to work for GCMP as well, luckily the
> relevant fields already alias each other so no code duplication
> is needed (just check the aliasing with BUILD_BUG_ON.)
> 
Applied.

johannes
