Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39524 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965096AbcAZMye (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 07:54:34 -0500
Message-ID: <1453812869.2759.38.camel@sipsolutions.net> (sfid-20160126_135437_057538_D753226F)
Subject: Re: [PATCH] cfg80211: basic support for PBSS network type
From: Johannes Berg <johannes@sipsolutions.net>
To: Lior David <liord@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Dedy Lansky <dlansky@codeaurora.org>,
	Maya Erez <merez@codeaurora.org>,
	Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Date: Tue, 26 Jan 2016 13:54:29 +0100
In-Reply-To: <56A767E4.7090906@codeaurora.org>
References: <56961335.4040801@codeaurora.org>
	 <1453807346.2759.29.camel@sipsolutions.net>
	 <56A767E4.7090906@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Yes, DMG devices can function as a full AP in addition to PCP.

Ok. I'll try to remember :)

> Certified 11ad devices must support PBSS, but in theory you can have
> 11ad drivers that do not support it. 11ac devices cannot support
> it and currently will just ignore this flag, so I think I will add a
> feature flag (something like NL80211_EXT_FEATURE_PBSS) and return an
> error if the driver does not support this feature.

I'd rather return an error when the device isn't 11ad.

If it's basically a requirement then I don't think we really need a
feature flag, but can just have the driver reject the flag in the
meantime. I do want to avoid having a situation where userspace
specified PBSS and it gets ignored entirely though.

> I have a patch for the wil6210 driver that uses this feature. Do you
> prefer that I add the wil6210 driver changes to this patch?

Great. No, I don't want bigger wil6210 changes in this patch, so I'd
prefer you add a few lines to this patch that make wil6210 reject the
configuration with PBSS, and then obviously in the real wil6210 patch
remove that again.

johannes
