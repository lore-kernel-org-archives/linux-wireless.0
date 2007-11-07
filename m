Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:44581 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752495AbXKGJpn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 04:45:43 -0500
Date: Wed, 7 Nov 2007 10:42:22 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211 doesn't reassociate after failed ProbeResp
Message-ID: <20071107104222.1fa0b728@morte> (sfid-20071107_094554_926754_7BA8D944)
In-Reply-To: <20071107102158.61b4ca3d@morte>
References: <20071107102158.61b4ca3d@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 7 Nov 2007 10:21:58 +0100
Stefano Brivio <stefano.brivio@polimi.it> wrote:

> I got a quite reproducible bug with mac80211. Sometimes, this happens
> (phy0 is a b43 PHY):
> 
> Nov  7 02:06:23 morte [123784.591945] wlan0: No ProbeResp from current AP
> 00:14:c1:35:8d:eb - assume out of range Nov  7 02:06:23 morte
> [123784.591968] phy0: Removed STA 00:14:c1:35:8d:eb
> 
> then, instead of trying to reassociate, mac80211 acts like this:
> Nov  7 02:06:25 morte [123785.138041] wlan0: dropped data frame to not
> associated station 00:14:c1:35:8d:eb Nov  7 02:06:25 morte
> [123785.138243] wlan0: dropped data frame to not associated station
> 00:14:c1:35:8d:eb Nov  7 02:06:55 morte [123798.704732] wlan0: No STA
> entry for own AP 00:14:c1:35:8d:eb

BTW, what I have to do to get mac80211 to associate is to set a bogus ESSID
and then the correct one back, then it will associate.


-- 
Ciao
Stefano
