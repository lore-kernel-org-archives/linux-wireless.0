Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37753 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbcHIH4h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 03:56:37 -0400
Message-ID: <1470729393.28531.11.camel@sipsolutions.net> (sfid-20160809_095640_686085_07C122B5)
Subject: Re: [PATCH v4] cfg80211: Provision to allow the support for
 different beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
	"Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Kondabattini, Ganesh" <ganeshk@qti.qualcomm.com>,
	"Kalikot Veetil, Mahesh Kumar" <mkalikot@qca.qualcomm.com>,
	"Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>,
	"Kumar, Deepak (QCA)" <djindal@qti.qualcomm.com>
Date: Tue, 09 Aug 2016 09:56:33 +0200
In-Reply-To: <9513d3caf9354aeda408f65128b4a079@aphydexm01f.ap.qualcomm.com>
References: <1470374768-22297-1-git-send-email-pkushwah@qti.qualcomm.com>
 <1470386912.2977.28.camel@sipsolutions.net>
	 <9513d3caf9354aeda408f65128b4a079@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I guess , we can extend this to mesh and IBSS as well. 

I don't know what your firmware/hardware capabilities are :)

> > It seems to me that if I were to specify beacon intervals which
> > have a very small GCD, you'll run into trouble when actually
> > sending beacons.
> > Perhaps there should be a requirement on the GCD?
> Can we have this published by the host drivers through a new wiphy
> parameter , say "min_diff_beacon_interval_multiplier". This set's the
> expectation that any different beacon intervals on the wiphy  shall
> be a multiple of this parameter which is advertised by the host
> driver , isn't ?
> 
I'd argue that instead of having the interface combinations flag, that
nl80211 attribute could carry the GCD?

johannes
