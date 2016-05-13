Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:58611 "EHLO
	mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbcEMKhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2016 06:37:12 -0400
Message-ID: <1463135828.1443.6.camel@strongswan.org> (sfid-20160513_123723_798820_46BABBA0)
Subject: Re: [PATCH v2 0/2] wireless: Allow wiphy/hwsim management from user
 namespaces
From: Martin Willi <martin@strongswan.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Fri, 13 May 2016 12:37:08 +0200
In-Reply-To: <1463045221.13313.16.camel@sipsolutions.net>
References: <1462811639-29906-1-git-send-email-martin@strongswan.org>
	 <1463045221.13313.16.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> So I think you should change the "wmediumd_portid" variable to live
> in struct hwsim_net and then allow HWSIM_CMD_REGISTER to be done
> inside the net namespace.
> 
> With that, and making the other few wmediumd related operations
> namespace aware, we would be able to run wmediumd in any net
> namespace and have it manage all the radios created in that
> namespace.

Yes, that makes sense. I've a patch mostly ready, but it needs some
more testing before I can submit it. Hope to complete that today.

While testing I've hit a Netlink verification issue that I'll
separately submit a patch for.

Best regards
Martin
