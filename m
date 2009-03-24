Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:34700 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379AbZCXWUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 18:20:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LmEyY-00077H-85
	for linux-wireless@vger.kernel.org; Tue, 24 Mar 2009 22:20:02 +0000
Received: from 80-45-51-238.static.dsl.as9105.com ([80.45.51.238])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 22:20:02 +0000
Received: from Quentin by 80-45-51-238.static.dsl.as9105.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 22:20:02 +0000
To: linux-wireless@vger.kernel.org
From: Quentin Armitage <Quentin@Armitage.org.uk>
Subject: Re: Oops and other problems in cfg80211
Date: Tue, 24 Mar 2009 22:18:39 +0000 (UTC)
Message-ID: <loom.20090324T220312-187@post.gmane.org> (sfid-20090324_232013_801604_8228015C)
References: <1237224184.5027.600.camel@samson.armitage.org.uk> <43e72e890903191800y7f30a58fheeb1b8f25eb6d7f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@...> writes:

> > If reg_is_world_roaming is modified to check for last_request not being
> > NULL, e.g.
> > if (last_request && last_request->initiator != REGDOM_SET_BY_COUNTRY_IE
> > &&
> > then I also get an oops in reg_device_remove where last_request is
> > referenced and there is only a subsequent check for it being NULL.
Following the commits included in master-2009-03-23, in function
reg_device_remove in net/wireless/reg.c there is still a dereference via
last_request (request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);)
prior to the test for last_request != NULL (if (!last_request || !request_wiphy)
)
I suspect that following the patches applied, last_request cannot be NULL, and
therefore the check !last_request is not required; otherwise the check needs to
be made before the call to wiphy_idx_to_wiphy.
One way or the other, as it stands the code looks wrong.


