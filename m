Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:44689 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbZBXOGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 09:06:42 -0500
Date: Tue, 24 Feb 2009 16:06:25 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Add module parameter to disable hardware crypto
Message-ID: <20090224140625.GA30004@jm.kir.nu> (sfid-20090224_150645_594775_D82452A9)
References: <20090224114201.GB21933@jm.kir.nu> <1235483347.4320.7.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1235483347.4320.7.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2009 at 05:49:07AM -0800, Johannes Berg wrote:
> On Tue, 2009-02-24 at 13:42 +0200, Jouni Malinen wrote:
> > In
> > addition, this allows management frame protection to be tested with
> > older hardware revisions.
> 
> This is odd, shouldn't older revisions refuse the hw key setup and use
> software anyway? Or are they unable to distinguish between management
> and data frames and thus it all goes wrong?

The exact behavior depends on the hardware revision, but some older
versions would likely end up using the Data frame rules for decrypting
the management frames and as such, would require software workaround
that re-encrypt the frame using Data frame rules and then make the frame
go the normal software decryption. While this is possible to implement,
I have not bothered to do so yet and don't know how much interest there
would be for such a feature at this point. This would also require some
new APIs from mac80211 to allow re-use of CCMP code.

-- 
Jouni Malinen                                            PGP id EFC895FA
