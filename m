Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54091 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbaIXASj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 20:18:39 -0400
From: Sujith Manoharan <sujith@msujith.org>
Message-ID: <21538.3575.430682.821603@gargle.gargle.HOWL> (sfid-20140924_021842_109414_79F24FA8)
Date: Wed, 24 Sep 2014 05:49:03 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: How are ht-caps changes propagated after ieee80211_register_hw?
In-Reply-To: <5421FF7F.2080109@candelatech.com>
References: <5421FF7F.2080109@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> In ath9k, when you set the chainmask to 2x2 on a 3x3 NIC,
> the ht-caps appear as 2-streams in station association requests.
> 
> But, in ath10k, they still appear as 3x3.  I don't see any obvious way
> that ath9k notifies the mac80211 stack that it changed the
> ht-caps, but it must be working somehow.

In ath9k, we re-register the new HT parameters with mac80211
when set_antenna() is called.

Sujith
