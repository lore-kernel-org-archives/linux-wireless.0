Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38081 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbKZQsP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 11:48:15 -0500
Message-ID: <1448556492.2167.23.camel@sipsolutions.net> (sfid-20151126_174818_823470_83FE5CD5)
Subject: Re: [PATCH] mac80211_hwsim: check ATTR_FREQ for wmediumd (netlink)
 packets
From: Johannes Berg <johannes@sipsolutions.net>
To: arwelle@cert.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2015 17:48:12 +0100
In-Reply-To: <1446477900-10430-1-git-send-email-arwelle@cert.org>
References: <1446477900-10430-1-git-send-email-arwelle@cert.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-02 at 10:25 -0500, arwelle@cert.org wrote:
> From: Adam Welle <arwelle@cert.org>
> 
> If a packet is received from netlink with the frequency value set it
> is
> checked against the current radio's frequency and discarded if
> different.
> 
Reviewing this more closely, it seems that the frequency should also be
checked against data->tmp_channel if that's non-zero, to support the
"hw" off-channel/scan case.

johannes
