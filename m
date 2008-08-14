Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:48126 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbYHNI0I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 04:26:08 -0400
Date: Thu, 14 Aug 2008 11:25:19 +0300
From: Jouni Malinen <j@w1.fi>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Pondering: how to improve mac80211 roaming ...
Message-ID: <20080814082519.GI4981@jm.kir.nu> (sfid-20080814_102613_154812_8E00B044)
References: <200808120838.52888.hs4233@mail.mn-solutions.de> <20080812082246.GD4981@jm.kir.nu> <87skt86pqg.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87skt86pqg.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 14, 2008 at 10:05:27AM +0300, Kalle Valo wrote:

> What about PMKSA caching? Shouldn't user space need to provide PMKIDs
> (or the IEs) to mac80211 before association?

There are two possible designs for this. In wpa_supplicant terms,
ap_scan=2 would most likely mean that driver is responsible for
generating the RSN IE, including PMKID list, and wpa_supplicant is
providing the driver a list of currently available PMKs (PMKIDs for
them). In ap_scan=1, there is option for the driver to use the RSN IE
from wpa_supplicant (which is something that mac80211 is doing at the
moment) and in that case, yes, PMKIDs would indeed need to be updated
in the RSN IE just before association.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
