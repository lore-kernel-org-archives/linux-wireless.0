Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53953 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2AZSMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 13:12:30 -0500
To: Nicolas Cavallari <nicolas.cavallari@lri.fr>
Subject: Re: [PATCH] mac80211: Do not encrypt EAPOL frames in IBSS Mode.
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Thu, 26 Jan 2012 11:12:27 -0700
From: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
In-Reply-To: <1327581742-15460-1-git-send-email-cavallar@lri.fr>
References: <1327581742-15460-1-git-send-email-cavallar@lri.fr>
Message-ID: <57ae7aaa1353b4e9794d54187262126f@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-01-26 05:42, Nicolas Cavallari wrote:
> Currently, EAPOL Frames in IBSS mode are encrypted if a PTK
> is available.  This patch turn off encryption for all EAPOL
> frames when on IBSS mode, as there is no suitable userspace
> calls to configure the control port protocol and settings.
>
> IBSS RSN sort-of worked without this patch because PTKs
> are only installed after the completion of a successful
> EAPOL exchange,  so unicast operations would work,  but
> multicast and rekeying would often fail.

Err, NACK? I'm 99% sure this is completely wrong -- point out where the 
IEEE RSN spec allows this.

johannes
