Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:38915 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbYJGTpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 15:45:08 -0400
Date: Tue, 7 Oct 2008 22:44:06 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: wpa supplicant interface up delay
Message-ID: <20081007194406.GK4941@jm.kir.nu> (sfid-20081007_214513_010095_8AC4123F)
References: <1223403361.7328.71.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223403361.7328.71.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 07, 2008 at 08:16:01PM +0200, Johannes Berg wrote:
>                          * Wait some time to allow driver to initialize before
>                          * starting configuring the driver. This seems to be  
>                          * needed at least some drivers that load firmware etc.
>                          * when the interface is set up.
> 
> which drivers are those, and why can't we fix the drivers instead? This
> seems like a bug in the drivers that they return from their open
> callback prematurely.

I've observed issues with a driver that (at least at the time) was not
fully open source. I didn't feel like fixing the driver at the time.

Anyway, I'm perfectly fine with removing this from nl80211. As far as
driver_wext.c is concerned, I would like to first verify what the
original issue is and whether the driver could be fixed easily.

-- 
Jouni Malinen                                            PGP id EFC895FA
