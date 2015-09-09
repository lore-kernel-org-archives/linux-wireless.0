Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36249 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbbIIQtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 12:49:47 -0400
Received: by ioii196 with SMTP id i196so29161001ioi.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2015 09:49:46 -0700 (PDT)
Date: Wed, 9 Sep 2015 12:49:45 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
Message-ID: <20150909164945.GA4062@localhost> (sfid-20150909_184950_812635_9318273F)
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
 <1440673024-13696-4-git-send-email-me@bobcopeland.com>
 <87oahc9g9h.fsf@kamboji.qca.qualcomm.com>
 <87fv2o9cvl.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87fv2o9cvl.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 09, 2015 at 12:10:38PM +0300, Kalle Valo wrote:
> > I did a quick smoke test and saw the splat below. It's this warning from
> > cfg80211:
> >
> > 			/*
> > 			 * Don't advertise an unsupported type
> > 			 * in a combination.
> > 			 */
> > 			if (WARN_ON((wiphy->interface_modes & types) != types))
> > 				return -EINVAL;

OK, this happens when mesh is configured out (we mask off the mesh
interface_modes internally but not the types).  Sent an updated version
with appropriate ifdefs added.

-- 
Bob Copeland %% http://bobcopeland.com/
