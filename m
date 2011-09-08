Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab1IHHBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 03:01:39 -0400
Subject: Re: [PATCH 0/2] QoS headers for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <CAPjQAd8su+CLkq84L2xtZO3XrKv2RS3fehsYVu2T_5MRwbnQxg@mail.gmail.com> (sfid-20110908_053518_772793_714755F5)
References: <1315347976-13950-1-git-send-email-javier@cozybit.com>
	 <1315418920.4002.13.camel@jlt3.sipsolutions.net>
	 <1315419259.4002.16.camel@jlt3.sipsolutions.net>
	 <CAPjQAd8ZLDQKvBOMOoe+hoo5FEjiLV6vBxzdE-bMcz_iEt59tQ@mail.gmail.com>
	 <CAPjQAd8su+CLkq84L2xtZO3XrKv2RS3fehsYVu2T_5MRwbnQxg@mail.gmail.com>
	 (sfid-20110908_053518_772793_714755F5)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Sep 2011 09:01:31 +0200
Message-ID: <1315465291.3948.3.camel@jlt3.sipsolutions.net> (sfid-20110908_090143_216541_2920AD13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-07 at 20:34 -0700, Javier Cardona wrote:

> Kazuyuki Sakoda, the current technical editor of TGs kindly pointed me
> to the right section in the draft:  Sec 5.2.14.3 states that "mesh
> STAs are QoS STAs (...) [that] implement a subset of QoS
> functionality".  The use of the QoS frame format and EDCA support are
> mandatory.

Makes sense.

> Based on that I'd like to prevent the creation of mesh interfaces on
> phy's that don't support multiple queues.  Would you like to suggest a
> good place to perform that check?

Since we probably can't do that in cfg80211, the most logical place
would be ieee80211_check_concurrent_iface() even though on the face of
it that function does something else; however, note the comment on
ieee80211_do_open(). Maybe it warrants a rename of the function,
something like ieee80211_check_iface_possible() maybe?

johannes

