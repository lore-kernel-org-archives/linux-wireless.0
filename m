Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55741 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964919AbaLKIOv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2014 03:14:51 -0500
Message-ID: <1418285688.1947.0.camel@sipsolutions.net> (sfid-20141211_091458_544848_F6C3BABA)
Subject: Re: [PATCH 1/1] wireless: mac80211: Avoid using uninitialized stack
 data
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Dec 2014 09:14:48 +0100
In-Reply-To: <1418238847-3332-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1418238847-3332-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1418238847-3332-2-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-10 at 14:14 -0500, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Avoid case where we would access uninitialized stack data if a driver
> advertises HT support without 40MHz channel support.

>  		ret = IEEE80211_STA_DISABLE_40MHZ;
> +		vht_chandef = *chandef;

I think we can and should disable VHT in this case, since VHT requires
40 and 80 MHz support.

johannes

