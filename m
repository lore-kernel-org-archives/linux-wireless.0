Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51785 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab2K3MoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 07:44:01 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TePwm-0002eg-2q
	for linux-wireless@vger.kernel.org; Fri, 30 Nov 2012 13:44:00 +0100
Message-ID: <1354279464.10035.32.camel@jlt4.sipsolutions.net> (sfid-20121130_134404_627585_AF236BDC)
Subject: Re: [PATCH] cfg80211: fix BSS struct IE access races
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 30 Nov 2012 13:44:24 +0100
In-Reply-To: <1354197580-18507-1-git-send-email-johannes@sipsolutions.net> (sfid-20121129_145927_082692_30AD7B40)
References: <1354148804-26678-1-git-send-email-johannes@sipsolutions.net>
	 <1354197580-18507-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121129_145927_082692_30AD7B40)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-29 at 14:59 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When a BSS struct is updated, the IEs are currently
> overwritten or freed. This can lead to races if some
> other CPU is accessing the BSS struct and using the
> IEs concurrently.
> 
> Fix this by always allocating the IEs in a new struct
> that holds the data and length and protecting access
> to this new struct with RCU.

Applied.

johannes

