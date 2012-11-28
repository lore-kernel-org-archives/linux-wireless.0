Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43600 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab2K1MfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 07:35:09 -0500
Message-ID: <1354106128.9345.6.camel@jlt4.sipsolutions.net> (sfid-20121128_133513_369326_2A721201)
Subject: Re: [RFC 1/3] nl80211: add spec scan flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 28 Nov 2012 13:35:28 +0100
In-Reply-To: <1354042885-32688-2-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1354042885-32688-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 20:01 +0100, Simon Wunderlich wrote:
> This flag indicates that a spectrum scan is requested, if supported.

That "if supported" here is pretty problematic. There's no way to know.
Feature flag maybe?

Also, there are scan flags now. However, I don't see that this should
(ab)use the scan function. It doesn't seem likely that you want to do
this while you're sending probe requests, etc. OTOH, it seems likely
you'd want identical dwell times on all channels to have comparable
values, which isn't the case here.

I really think you need to decouple the API for this from scanning.

johannes

