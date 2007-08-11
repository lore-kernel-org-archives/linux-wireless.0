Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33673
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813AbXHKJnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2007 05:43:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: How to use software encryption with WEP and mac80211
Date: Sat, 11 Aug 2007 11:42:15 +0200
Cc: wireless <linux-wireless@vger.kernel.org>
References: <46BD2C17.4000702@lwfinger.net>
In-Reply-To: <46BD2C17.4000702@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708111142.15991.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 11 August 2007 05:25:11 Larry Finger wrote:
> What do I need to do to get mac80211 to do software encryption for WEP? My port of the PHY code from 
> bcm43xx and the mac80211 front end works with WPA encryption. With WEP, it authenticates and 
> associates, but never gets an IP number from DHCP. That indicates to me that the encryption is not 
> set up correctly. I looked through the various definitions in include/net/mac80211.h, but nothing 
> seems to apply.

Which hw enc code do you use in that tree? The old softmac crap
or my new code from bcm43xx-mac80211?

Anyway, if you want to disable hw enc, always set the force sw enc bit
in the set_key function and return early:

	key->flags |= IEEE80211_KEY_FORCE_SW_ENCRYPT;
	return 0;

-- 
Greetings Michael.
