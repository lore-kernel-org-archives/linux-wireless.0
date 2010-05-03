Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:44953 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab0ECU3v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 16:29:51 -0400
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, johill@sipsolutions.net,
	reinette.chatre@intel.com, Adel Gadllah <adel.gadllah@gmail.com>
Subject: Re: [PATCH] iwlagn: Change the TPT calculations sanity-check to WARN_ON
References: <1272907549-25847-1-git-send-email-linville@tuxdriver.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 03 May 2010 23:29:44 +0300
In-Reply-To: <1272907549-25847-1-git-send-email-linville@tuxdriver.com> (John W. Linville's message of "Mon\,  3 May 2010 13\:25\:49 -0400")
Message-ID: <87k4rkk9tz.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> From: Adel Gadllah <adel.gadllah@gmail.com>
>
> Currently it is a BUG_ON() which will hang the machine once triggered.

Related to this: can we have a rule that no wireless driver should
ever use BUG_ON()? I think we could extend this even to cfg80211 and
mac80211.

BUG_ON() is valid whenever there's a risk of corrupting data, for
example on a filesystem, but I really don't see the point of using
them in wireless drivers. They just make things miserable, especially
for the normal users. Printing a warning and handling the case as
gracefully as possible is much better IMHO.

-- 
Kalle Valo
