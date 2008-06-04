Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:52720 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbYFDPz5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 11:55:57 -0400
Date: Wed, 4 Jun 2008 18:55:04 +0300
From: Jouni Malinen <j@w1.fi>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 ad-hoc mode problems
Message-ID: <20080604155504.GH580@jm.kir.nu> (sfid-20080604_175602_422901_B2B9F87B)
References: <1212543664.4237.14.camel@localhost.localdomain> <1212570001.14371.16.camel@johannes.berg> <20080604091656.GE580@jm.kir.nu> <1212589104.13676.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1212589104.13676.17.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 04, 2008 at 10:18:24AM -0400, Dan Williams wrote:

> Ok, I'll drop it down to 5 seconds if that's OK with you.  That's still
> the same amount of time as the wpa_supplicant assoc_failed auth timeout
> in wpa_supplicant_associate() though, so they could still step on each
> other.  Not quite sure what to do about that except bump up the
> wpa_supplicant assoc_failed timeout by a few more seconds?

As long as there is still enough time for the scan to be completed
before deciding to create a new IBSS. I don't remember how that code
worked, so I don't know whether 5 second as the IBSS timeout will
guarantee this for every case. If there are any problems in providing
such guarantee, I have nothing against increasing the wpa_supplicant
timeout for IBSS. I might do that anyway since there is not really much
point in timing out IBSS join/create in most cases.

-- 
Jouni Malinen                                            PGP id EFC895FA
