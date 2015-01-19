Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35695 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbbASSCz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 13:02:55 -0500
Message-ID: <1421690572.1965.41.camel@sipsolutions.net> (sfid-20150119_190259_120071_E9A7CC0E)
Subject: Re: [PATCH] Revert "wireless: Support of IFLA_INFO_KIND rtnl
 attribute"
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Vadim Kochan <vadim4j@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>
Date: Mon, 19 Jan 2015 19:02:52 +0100
In-Reply-To: <1421689943-13264-1-git-send-email-johannes@sipsolutions.net> (sfid-20150119_185234_968564_95BB0018)
References: <1421689943-13264-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20150119_185234_968564_95BB0018)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-19 at 18:52 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This reverts commit ba1debdfed974f25aa598c283567878657b292ee.
> 
> Oliver reported that it breaks network-manager, for some reason with
> this patch NM decides that the device isn't wireless but "generic"
> (ethernet), sees no carrier (as expected with wifi) and fails to do
> anything else with it.
> 
> Revert this to unbreak userspace.

git-email didn't Cc Vadim or Marcel ...

Looks like we can't do this since it will break userspace - please don't
write any tools depending on it :)

johannes

