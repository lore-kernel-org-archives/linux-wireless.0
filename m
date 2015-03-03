Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54743 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbbCCJQK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 04:16:10 -0500
Message-ID: <1425374168.2450.17.camel@sipsolutions.net> (sfid-20150303_101615_497789_9A9EB162)
Subject: Re: [PATCH] mac80211: disable u-APSD queues by default
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 03 Mar 2015 10:16:08 +0100
In-Reply-To: <1423568924-11895-1-git-send-email-michal.kazior@tieto.com> (sfid-20150210_125033_043617_6CA9D3E9)
References: <1423568924-11895-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150210_125033_043617_6CA9D3E9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-10 at 12:48 +0100, Michal Kazior wrote:
> Some APs experience problems when working with
> U-APSD. Decreasing the probability of that
> happening by using legacy mode for all ACs but VO
> isn't enough.
> 
> Cisco 4410N originally forced us to enable VO by
> default only because it treated non-VO ACs as
> legacy.
> 
> However some APs (notably Netgear R7000) silently
> reclassify packets to different ACs. Since u-APSD
> ACs require trigger frames for frame retrieval
> clients would never see some frames (e.g. ARP
> responses) or would fetch them accidentally after
> a long time.

This makes me a little sad, but I've applied this and even added a Cc
stable tag due to the interoperability issues.

johannes

