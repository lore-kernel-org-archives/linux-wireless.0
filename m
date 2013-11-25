Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38428 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3KYP7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 10:59:55 -0500
Message-ID: <1385395191.4443.29.camel@jlt4.sipsolutions.net> (sfid-20131125_165957_484157_24C9D70A)
Subject: Re: [RFC 3/5] cfg80211: add regulatory quiescing support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 16:59:51 +0100
In-Reply-To: <20131114151809.GB29954@garbanzo.do-not-panic.com> (sfid-20131114_160753_012217_3FEDD59D)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384366379-25301-4-git-send-email-mcgrof@do-not-panic.com>
	 <1384377738.28806.15.camel@jlt4.sipsolutions.net>
	 <20131114141105.GB19070@garbanzo.do-not-panic.com>
	 <1384440286.13941.27.camel@jlt4.sipsolutions.net>
	 <20131114151809.GB29954@garbanzo.do-not-panic.com>
	 (sfid-20131114_160753_012217_3FEDD59D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-14 at 07:18 -0800, Luis R. Rodriguez wrote:

> > Think of the other way around, such as plugging in a stupid USB NIC just
> > to see if it works - and suddenly finding your 5 GHz connection broken
> > because that USB NIC said it really needed some stupid country with 2.4
> > only. I'm not convinced.
> 
> Actually your example is a good one that I'd use to make my case, 

But what's your case? Why trust a just-plugged-in USB NIC more than an
already-present PCIe NIC?

> but I
> can also see this being like a sledge hammer. What if we only quiesce on
> wdevs of types:
> 
>   o NL80211_IFTYPE_ADHOC
>   o NL80211_IFTYPE_MESH_POINT
>   o NL80211_IFTYPE_AP
>   o NL80211_IFTYPE_P2P_GO

At least we should then also have that patch that QCA has somewhere
about reporting to userspace that AP was stopped :P

johannes

