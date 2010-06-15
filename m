Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50741 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab0FOUSa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 16:18:30 -0400
Subject: Re: radiotap rate no longer supported in mac80211?
From: Pavel Roskin <proski@gnu.org>
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTileP2BMsZUsA-NigDcmVcAmXn6KNw0R1vMzSgYw@mail.gmail.com>
References: <AANLkTileP2BMsZUsA-NigDcmVcAmXn6KNw0R1vMzSgYw@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 15 Jun 2010 16:18:27 -0400
Message-Id: <1276633107.14133.11.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-14 at 15:18 -0700, Steve deRosier wrote:
> I'm trying to support per-packet setting of rate on a packet injection
> via the radiotap header.  In an earlier version of mac80211 (around
> 2.6.26), there was code in __ieee80211_parse_tx_radiotap (in
> net/mac80211/tx.c) to support the use of the the rate element from the
> radiotap header.  In current versions of wireless-testing, most of the
> code here has been removed and only the flags are parsed.
> 
> I want to return the IEEE80211_RADIOTAP_RATE portion of this function
> in order to support this.  So the questions:
> 1. Why were all fields other than IEEE80211_RADIOTAP_FLAGS removed?
> 2. Would it be OK for me to prepare and submit a patch to restore the
> rate functionality?

I posted a patch that would add rate and retry flags:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/47441

I didn't see any interest in the patch.  Perhaps injecting packets at a
specific rate in not particularly needed.

Also, the patch is somewhat inelegant because of the requirement to
specify the rate when the retry count is specified.

mac80211 has an array of rates with corresponding retry counts.  The
radiotap standard has one rate and one retry count.  This doesn't map
well to the mac80211 approach.  Supporting the retry count without the
rate would require some tricky logic, and I don't know if anyone needs
that.

I don't feel good about pushing a patch that makes the code more complex
without knowing the use case.

-- 
Regards,
Pavel Roskin
