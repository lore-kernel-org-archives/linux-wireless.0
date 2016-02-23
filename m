Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33099 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbcBWO3b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 09:29:31 -0500
Message-ID: <1456237769.9910.20.camel@sipsolutions.net> (sfid-20160223_152935_478073_20DEC34C)
Subject: Re: [PATCH 2/2] mac80211: add NEED_ALIGNED4_SKBS hw flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 23 Feb 2016 15:29:29 +0100
In-Reply-To: <1455876110-12758-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20160219_110214_050872_A1A295A7)
References: <1455876110-12758-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1455876110-12758-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20160219_110214_050872_A1A295A7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-02-19 at 11:01 +0100, Janusz Dziedzic wrote:
> HW/driver should set NEED_ALIGNED4_SKBS flag in case
> require aligned skbs to four-byte boundaries.
> This affect only TX direction.
> 
> Padding is added after ieee80211_hdr, before IV/LLC.

I'm still not super happy with how invasive these patches are.

Perhaps we could live with this being done only for the fast-xmit case?

johannes
