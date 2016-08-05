Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36857 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757779AbcHEIsi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2016 04:48:38 -0400
Message-ID: <1470386912.2977.28.camel@sipsolutions.net> (sfid-20160805_104859_042167_DA63D432)
Subject: Re: [PATCH v4] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
Date: Fri, 05 Aug 2016 10:48:32 +0200
In-Reply-To: <1470374768-22297-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1470374768-22297-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-08-05 at 10:56 +0530, Purushottam Kushwaha wrote:
> This commit provides the option for the host drivers to advertise the
> support for different beacon intervals among the respective interface
> combinations, through supp_diff_beacon_int (bool).

Neither your commit message nor the documentation makes a direct
reference to this affecting only AP/GO interface. However, you then go
and require that at least 2 interfaces with AP/GO are present.

What if you have AP,GO,mesh in the same interface combination? Either
your documentation needs to very very clearly state that the mesh must
match (either one of them?) and I'd go as far as renaming the APIs, or
you shouldn't require multiple APs and make this apply on mesh and IBSS
as well.

Are there really no restrictions whatsoever, btw?

It seems to me that if I were to specify beacon intervals which have a
very small GCD, you'll run into trouble when actually sending beacons.
Perhaps there should be a requirement on the GCD?

johannes
