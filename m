Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36135 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1BLNDe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 08:03:34 -0500
Message-ID: <4D56851D.7000509@hauke-m.de>
Date: Sat, 12 Feb 2011 14:03:25 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: George Kashperko <george@znau.edu.ua>
CC: linux-wireless@vger.kernel.org
Subject: Re: SSB AI support code
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
In-Reply-To: <1297258590.17400.37.camel@dev.znau.edu.ua>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

After rethinking this I came to the same result as Michael that it would
bet better to have a extra module for the AI bus separated from the ssb.
I grepped for ssb_ in the b43 driver code and it should be doable to
change the api of ssb so that adding an other bus can be done without
any changes to ssb. After the SSB API was changed once.

Most of the ssb_* methods calls in the b43 driver are getting an
ssb_device struct so just a common struct for ssb and the ai bus is
needed and it must contain some function pointers to the needed functions.

Then the drivers integrated in the drivers/ssb must be extracted and
unbundled from the ssb code. One common header file with some common
structs for ssb and AI is needed and the rest can be separated.

If you need help with something, I would like to help you with these
things. I just ordered an Netgear WNR3500L. ;-)

Hauke
