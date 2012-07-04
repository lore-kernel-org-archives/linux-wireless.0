Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:54354 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569Ab2GDKDH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 06:03:07 -0400
Message-ID: <4FF414D9.4060509@lri.fr> (sfid-20120704_120311_810826_C0460139)
Date: Wed, 04 Jul 2012 12:03:05 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH v2] mac80211: tx: do not drop non-robust mgmt to non-MFP
 stas.
References: <1341393221-5396-1-git-send-email-cavallar@lri.fr> <1341394528.4482.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1341394528.4482.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/07/2012 11:35, Johannes Berg wrote:
> On Wed, 2012-07-04 at 11:13 +0200, Nicolas Cavallari wrote:
>> Found this while trying to manage auth  frames in userspace
>> on a IBSS RSN network.
>> I'm  a bit surprised that drop_unencrypted is disabled both
>> in AP and managed mode, but only enabled in IBSS RSN, which
>> does not support MFP, yet.
> 
> Hmmm. Yes, all this seems a bit messy. Can we clean this up first?

The whole function is a bit messy. some clean ups would be nice
but it is too easy to break corner cases.

> 
> Maybe something like this?
> http://p.sipsolutions.net/d68a99dd3d9b1ab1.txt

No problem for me. I didn't want that patch to too intrusive at first.

Do you want to apply it yourself ? or should i include it in a series ?

> The whole drop_unencrypted seems strange to start with though...

what to you find strange ? that it is not used in a ESS, or how it works
? or both ?
