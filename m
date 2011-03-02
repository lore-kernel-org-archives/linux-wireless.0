Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38280 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab1CBNpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 08:45:39 -0500
Date: Wed, 2 Mar 2011 08:38:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Hubert Tonneau <hubert.tonneau@fullpliant.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 32 bits executables with 64 bits kernel wifi issue
Message-ID: <20110302133848.GA2536@tuxdriver.com>
References: <0B3412811@briare1.fullpliant.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0B3412811@briare1.fullpliant.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 02, 2011 at 11:54:07AM +0000, Hubert Tonneau wrote:
> Hi,
> 
> If I use a 32 bits kernel, then I can connect to any Wifi box,
> but if I use a 64 bits kernel with 32 bits executables,
> it will connect on some Wifi boxes (french Freebox), but fail to connect to others (french Livebox).
> 
> The wifi driver used is iwl3945.
> When connection fails, WPA supplicant will report successfull association,
> but udhcpc will fail to get a lease.
> It does not seem to be related to a peticular kernel release: I tested with 2.6.36.4,
> but get the same problem with 2.6.32.28 64 bits.
> 
> Regards,
> Hubert Tonneau

We have had a number of 32/64 compatibility problems with the wireless
extensions API in the past.  I wonder if this is another one?

Does your version of wpa_supplicant support the "-Dnl80211" option
(instead of "-Dwext")?  It might be worth trying that to see if it
works better?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
