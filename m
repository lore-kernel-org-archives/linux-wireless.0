Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34093 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbZC0V6Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 17:58:24 -0400
Subject: Re: [ath5k-devel] [BISECTED] AR5414 fails to scan after "ath5k:
 Update reset code"
From: Pavel Roskin <proski@gnu.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <40f31dec0903270704l52887eabw58ec893e3f3b7701@mail.gmail.com>
References: <1238020625.15025.15.camel@mj>
	 <40f31dec0903251847p260446bfi22a1b4c587dc41cc@mail.gmail.com>
	 <1238126849.20768.12.camel@mj>
	 <40f31dec0903270704l52887eabw58ec893e3f3b7701@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 17:58:19 -0400
Message-Id: <1238191099.27657.7.camel@mj> (sfid-20090327_225827_249415_DC5C07D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-03-27 at 16:04 +0200, Nick Kossifidis wrote:

> Nice catch ;-)

I just realized that ath5k worked when I was in Russia a week ago
because I was setting the country code correctly, and there is no 5 GHz
band in Russia.  But in the US, ath5k fails to scan!  That's why ath5k
"broke" when I came back! :-)

Also, the unpatched ath5k scans in the "GR" locale for some reason, even
though it has some 5 GHz channels.  Anyway, it's not very interesting
why the 0x44 value for PLL is working in some cases.  It should be 0x04.
I've submitted the patch.

-- 
Regards,
Pavel Roskin
