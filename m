Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50269 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbcD0JpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 05:45:14 -0400
Message-ID: <1461750305.3723.9.camel@sipsolutions.net> (sfid-20160427_114528_041318_FA19C35E)
Subject: Re: [PATCH v2] ath10k: remove VHT capabilities from 2.4GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Jouni Malinen <j@w1.fi>
Cc: Ben Greear <greearb@candelatech.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 27 Apr 2016 11:45:05 +0200
In-Reply-To: <CABPxzYJz59wOXjK2fCK_Tp05g0g1FY+VWscFKz9fG+D1swZGBA@mail.gmail.com> (sfid-20160427_113746_741811_8AD5A5E1)
References: <1461244669-19871-1-git-send-email-kvalo@qca.qualcomm.com>
	 <5718EE7A.4030503@candelatech.com>
	 <1461654272.16188.4.camel@sipsolutions.net>
	 <87mvogy3ux.fsf@kamboji.qca.qualcomm.com>
	 <CABPxzYL=sQg=HczxM3gdERHRD-3-KaOG455wsqjpZ6YZDkybmw@mail.gmail.com>
	 <571FCB22.5000305@candelatech.com>
	 <CABPxzY+UuCABUcFbV0EpdoRaSzpgGvMani_j7xvg2a=xh-Bw0g@mail.gmail.com>
	 <20160427091653.GB4345@w1.fi>
	 <CABPxzYJz59wOXjK2fCK_Tp05g0g1FY+VWscFKz9fG+D1swZGBA@mail.gmail.com>
	 (sfid-20160427_113746_741811_8AD5A5E1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-04-27 at 15:07 +0530, Krishna Chaitanya wrote:
> 
> If many vendors need this support, then mac80211 appraoch would be
> good. If not, we should stick to driver approach.

Trying to do this in the driver gets practically impossible, so no, it
really should be done in mac80211 either way. Drivers have to opt in by
reporting VHT caps for 2.4 GHz, at which point we simply revert this
patch, but get the right over-the-air behaviour.

johannes
