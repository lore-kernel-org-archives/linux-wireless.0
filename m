Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38904 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbcBXKhZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 05:37:25 -0500
Message-ID: <1456310242.2050.17.camel@sipsolutions.net> (sfid-20160224_113845_414606_90085170)
Subject: Re: [PATCH V7 1/2] nl80211: add feature for BSS selection support
From: Johannes Berg <johannes@sipsolutions.net>
To: arend@broadcom.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 24 Feb 2016 11:37:22 +0100
In-Reply-To: <56CD8039.9060407@broadcom.com> (sfid-20160224_110446_447810_ED4ACCA5)
References: <1455706070-11915-1-git-send-email-arend@broadcom.com>
	 <1456237245.9910.16.camel@sipsolutions.net> <56CCC50E.4040300@broadcom.com>
	 <1456260764.9910.31.camel@sipsolutions.net> <56CD8039.9060407@broadcom.com>
	 (sfid-20160224_110446_447810_ED4ACCA5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-24 at 11:04 +0100, Arend Van Spriel wrote:

> I actually do not see any NLA_NESTED attributes with an explicit
> length. As you mentioned the nla_parse() of the nested attribute will
> validate the length of the stream so no need to put that in the
> policy.

Right, I think what you want can be achieved by just using NLA_NESTED
to make sure it's long enough for nesting anything, and then nla_parse.
I'm pretty sure we do the same in other places, no?

johannes
