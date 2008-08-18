Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:39479 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759233AbYHRTJZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 15:09:25 -0400
Received: from gprs-prointernet-ff6f6a00-114.dhcp.inet.fi ([93.106.111.114] helo=jm)
	by hostap.isc.org with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <j@w1.fi>)
	id 1KVA4D-0003JO-AK
	for linux-wireless@vger.kernel.org; Mon, 18 Aug 2008 12:07:04 -0700
Date: Mon, 18 Aug 2008 22:08:29 +0300
From: Jouni Malinen <j@w1.fi>
To: linux-wireless@vger.kernel.org
Subject: Re: Userspace client MLME and BSSID-mismatch filtering for scans
Message-ID: <20080818190829.GB4809@jm.kir.nu> (sfid-20080818_210930_073690_AF77E32C)
References: <20080818164741.GA4809@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080818164741.GA4809@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 18, 2008 at 07:47:42PM +0300, Jouni Malinen wrote:
> I'm trying to get userspace client MLME working again and the next
> blocker seems to be in Probe Response frames being dropped during
> scanning

I got the userspace client MLME working with the current wpa_supplicant
0.6.x git version and using -Dnl80211. mac80211 needs two changes for
this to work: cfg80211 vif configuration option for enabling userspace
MLME (I'll send an updated patch for this) and workaround/fix for
ProbeResp frames (BSSID-mismatch) dropping during scan (works with the
patch I sent in the previous message in this thread or alternatively,
could add a mechanism for letting mac80211 know when userspace MLME is
doing scanning if that is considered more preferable; that extension
would add on top of the vif configuration patch to bring in extra
parameters for indicating scan state).
 
-- 
Jouni Malinen                                            PGP id EFC895FA
