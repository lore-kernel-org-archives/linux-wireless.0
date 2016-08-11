Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52954 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbcHKNaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 09:30:18 -0400
Message-ID: <1470919928.12075.9.camel@sipsolutions.net> (sfid-20160811_153021_990346_97EF2A0F)
Subject: Re: [PATCH] cfg80211: validate beacon interval for MESH/IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>,
	"Kalikot Veetil, Mahesh Kumar" <mkalikot@qca.qualcomm.com>,
	"Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>,
	"Kumar, Deepak (QCA)" <djindal@qti.qualcomm.com>
Date: Thu, 11 Aug 2016 14:52:08 +0200
In-Reply-To: <99a970ef2b8f4d41b757c4e6b65648ac@aphydexm01b.ap.qualcomm.com>
References: <1470908642-13535-1-git-send-email-pkushwah@qti.qualcomm.com>
	 <99a970ef2b8f4d41b757c4e6b65648ac@aphydexm01b.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-08-11 at 09:56 +0000, Kushwaha, Purushottam wrote:
> Johannes , 
> While addressing this change, we could notice that the minimum
> boundary for beacon interval for the case of IBSS is 1 but for Mesh
> it is 10. Also this check is not done for AP/P2P GO . 
> Any reason why there is a discrepancy among them ? These
> configurations should be aligned , I guess. 
> Shouldn't the minimum value be 10 ? If yes , the boundary check
> should be moved to cfg80211_validate_beacon_int ? 
> 

Yeah, I've applied the patch and moved the range checks in as well.

johannes
