Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:52826 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbZHLSPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 14:15:18 -0400
Received: by pzk34 with SMTP id 34so135874pzk.4
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 11:15:19 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: andrey@cozybit.com, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	xinhua_wu@realsil.com.cn
Subject: Fix preq frame process and peer link frame baselen.
Date: Wed, 12 Aug 2009 11:03:42 -0700
Message-Id: <1250100224-23832-1-git-send-email-javier@cozybit.com>
In-Reply-To: <4A82639F.6000908@realsil.com.cn>
References: <4A82639F.6000908@realsil.com.cn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yes, I agree with you, and this patch is just to check whether this PREQ is valid with
> the ttl it contains instead of local TTL, and the local TTL has also been provided for
> PREP further process.

I'm still unconvinced with that change.  The ttl check you refer to is done on
transmission: PREQs with ttl of zero are never transmitted.  See further down in
that same function:

	ttl = PREQ_IE_TTL(preq_elem);
	lifetime = PREQ_IE_LIFETIME(preq_elem);
	if (ttl <= 1) {
		/* supress frame */

Furthermore, with the change you propose, you open the possibility for PREPs to
be transmitted with ttl=0 (if ifmsh->mshcfg.dot11MeshTTL was set to zero).

Regarding your baselen explanation, I now understand it and agree to the
suggested change.  Your initial patch submission was reversed and I got confused
looking at two version of the same.

I've created a new series with the parts of your patch that I agree with.  They
follow this e-mail.

Thanks!

Javier
