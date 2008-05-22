Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21414 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYEVSuF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 14:50:05 -0400
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -
	2.6.26-rc1 kernel
From: Pavel Roskin <proski@gnu.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	Vincent C Jones <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
In-Reply-To: <1211481249.28022.15.camel@localhost.localdomain>
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
	 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
	 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
	 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
	 (sfid-20080522_185359_028598_D17C0097)  <1211478969.3698.56.camel@johannes.berg>
	 <1211481249.28022.15.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 22 May 2008 14:50:03 -0400
Message-Id: <1211482203.18709.9.camel@dv> (sfid-20080522_205010_477736_D557D2B6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-22 at 14:34 -0400, Dan Williams wrote:

> But what's the best fix to the supplicant?  It could just parse A-band
> channels and where the numbers overlap, assume B/G band.  Or, it could
> be patched to prefer FREQ+frequency over FREQ+channel if it received
> both.  That's probably the best solution.

I checked the wpa_supplicant sources and I see that all it needs is the
frequency.  All that needs to be done is not to allow channels
(everything below, say, 10000) overwrite existing frequency data.
That's the second approach.

-- 
Regards,
Pavel Roskin
