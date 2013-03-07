Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3CGKZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 05:25:17 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UDY0i-0006Iz-3T
	for linux-wireless@vger.kernel.org; Thu, 07 Mar 2013 11:25:16 +0100
Message-ID: <1362651913.8694.27.camel@jlt4.sipsolutions.net> (sfid-20130307_112521_813407_D8E1FF41)
Subject: Re: [PATCH] mac80211: provide ieee80211_sta_eosp()
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 07 Mar 2013 11:25:13 +0100
In-Reply-To: <1362415374-25460-1-git-send-email-johannes@sipsolutions.net> (sfid-20130304_174314_786594_53C4E86E)
References: <1362415374-25460-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130304_174314_786594_53C4E86E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 17:42 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The irqsafe version ieee80211_sta_eosp_irqsafe() exists, but
> drivers must not mix calls to any irqsafe/non-irqsafe function.
> Both ath9k and iwlwifi, the likely first users of this interface,
> use non-irqsafe RX/TX/TX status so must also use a non-irqsafe
> version of this function. Since no driver uses the _irqsafe()
> version, remove that.

Applied.

johannes

