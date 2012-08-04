Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab2HDQIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2012 12:08:16 -0400
Message-ID: <1344096491.5982.1.camel@jlt3.sipsolutions.net> (sfid-20120804_180857_983910_93CC808F)
Subject: Re: [PATCH] compat: deal with backported codel
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sat, 04 Aug 2012 18:08:11 +0200
In-Reply-To: <1344095900.5982.0.camel@jlt3.sipsolutions.net> (sfid-20120804_175853_265949_A1686538)
References: <1344095900.5982.0.camel@jlt3.sipsolutions.net>
	 (sfid-20120804_175853_265949_A1686538)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-08-04 at 17:58 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Some distro kernels (in particular the Debian 3.2.0-3
> kernel I'm running) backport codel already, so trying
> to backport it again causes issues. Protect the compat
> backport with #ifdef TCA_CODEL_MAX.

Nope, this isn't sufficient -- it still causes issues because I still
build codel and the flow_dissector, and thus I get skb_flow_dissect() in
compat.ko which the kernel already defines ...

johannes

