Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:34373 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449AbZJFRnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 13:43:24 -0400
Received: by bwz6 with SMTP id 6so3469149bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 10:42:47 -0700 (PDT)
Message-ID: <4ACB818F.7000508@gmail.com>
Date: Tue, 06 Oct 2009 18:42:39 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: question about cfg80211_inform_bss()
References: <200910061418.05039.hs4233@mail.mn-solutions.de>
In-Reply-To: <200910061418.05039.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig wrote:
> However, cfg80211_inform_bss() want's a channel. And it wants the 
> IEs as well. A presume it scans those IEs, too. So do we need to 
> parse the IEs twice?

That is what orinoco does.

It's slightly worse for non-WPA firmware on orinoco. They supply ssid
and supported rates in a structure, and don't give access to the
original IEs - so the driver has to reconstruct the approporiate IE as
best it can, so cfg80211 can export them (all in orinoco/scan.c).



Dave.
