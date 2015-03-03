Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54748 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbbCCJSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 04:18:25 -0500
Message-ID: <1425374299.2450.18.camel@sipsolutions.net> (sfid-20150303_101829_592217_D20D77BC)
Subject: Re: [PATCH v2 3/4] mac80211: initialize rate control earlier for
 tdls station
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Date: Tue, 03 Mar 2015 10:18:19 +0100
In-Reply-To: <CA+XVXfchZ+L1iH47S=rM04vJbjBSKA4O8TYuhEkfZuLpNb9QDA@mail.gmail.com> (sfid-20150301_092138_211960_577091EE)
References: <1424850911-21017-1-git-send-email-marek.puzyniak@tieto.com>
	 <1424850911-21017-4-git-send-email-marek.puzyniak@tieto.com>
	 <1425041427.1960.1.camel@sipsolutions.net>
	 <CA+XVXfchZ+L1iH47S=rM04vJbjBSKA4O8TYuhEkfZuLpNb9QDA@mail.gmail.com>
	 (sfid-20150301_092138_211960_577091EE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-03-01 at 10:21 +0200, Arik Nemtsov wrote:

> > Arik, you have a similar patch handling only NSS. Does this one look
> > fine to you, and would it solve the problem your other patch solved?
> 
> Well currently iwlmvm requires the NSS to be set before
> IEEE80211_STA_ASSOC (earlier), so this doesn't help directly.
> I could change mvm a bit to make it work, but I don't really see a
> good reason for it :)
> 
> The patch looks good. Shouldn't introduce new issues (at least for iwlwifi).

Ok, thanks. Do you think it would be possible to move all of this before
ASSOC?

(if not, why not, and how is it that we have valid NSS if we don't have
the remaining data valid?)

johannes

