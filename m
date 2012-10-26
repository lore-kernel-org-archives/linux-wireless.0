Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56208 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966344Ab2JZUQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 16:16:53 -0400
Message-ID: <1351282646.10813.21.camel@jlt4.sipsolutions.net> (sfid-20121026_221657_617100_B03B7E9B)
Subject: Re: wireless testing working with ath9k?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 26 Oct 2012 22:17:26 +0200
In-Reply-To: <508AEC91.5090901@candelatech.com> (sfid-20121026_220334_505306_386A2A42)
References: <508AEC91.5090901@candelatech.com>
	 (sfid-20121026_220334_505306_386A2A42)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-26 at 13:03 -0700, Ben Greear wrote:
> I have a few small patches...and wireless-testing is failing to
> register it's hardware:
> 
> 	/* Register with mac80211 */
> 	error = ieee80211_register_hw(hw);
> 	if (error) {
> 		ath_err(common, "Unable to register hw: %i\n", error);
> 		goto error_register;
> 	}
> 
> [  764.193028] ath: country maps to regdmn code: 0x3a
> [  764.193042] ath: Country alpha2 being used: US
> [  764.193052] ath: Regpair used: 0x3a
> [  764.195415] ath: phy0: Unable to register hw: -22
> [  764.200949] ath9k 0000:03:00.0: Failed to initialize device
> [  764.206811] ath9k: probe of 0000:03:00.0 failed with error -22
> 
> Just wondering if this is a known problem before start digging into it...

yes, patch in my last mac80211-next pull request.

johannes

