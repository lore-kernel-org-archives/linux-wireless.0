Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48996 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbcHFUaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Aug 2016 16:30:19 -0400
Message-ID: <1470513454.3374.1.camel@sipsolutions.net> (sfid-20160806_223024_031700_35D299F0)
Subject: Re: [PATCH] cfg80211: Add support for user configurable beacon data
 rate
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
	"Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Kondabattini, Ganesh" <ganeshk@qti.qualcomm.com>,
	"Kalikot Veetil, Mahesh Kumar" <mkalikot@qca.qualcomm.com>,
	"Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>
Date: Sat, 06 Aug 2016 21:57:34 +0200
In-Reply-To: <92b06d4df5984e6ea91081126e096a96@aphydexm01f.ap.qualcomm.com>
References: <1470371701-13074-1-git-send-email-pkushwah@qti.qualcomm.com>
 <1470387784.2977.30.camel@sipsolutions.net>
	 <92b06d4df5984e6ea91081126e096a96@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-08-06 at 04:38 +0000, Undekari, Sunil Dutt wrote:
> > 
> > Doesn't this have to check that it actually got information for the
> > right band?
> Hi Johannes ,
> nl80211_parse_tx_bitrate_mask ( a new wrapper to the existing
> functionality in nl80211_set_tx_bitrate_mask ) does this , isn't ? 
> 
It checks that everything matches up with capabilities, but it doesn't
check that if you specified NL80211_ATTR_TX_RATES you didn't do
something stupid like specifying it for 2.4GHz while your AP is
starting up on 5GHz.

It also doesn't check that you specified exactly one rate, but it's not
clear how else this would work?

johannes
