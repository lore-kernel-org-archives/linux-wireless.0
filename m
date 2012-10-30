Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604Ab2J3KcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 06:32:22 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TT97N-0000Sx-3W
	for linux-wireless@vger.kernel.org; Tue, 30 Oct 2012 11:32:21 +0100
Message-ID: <1351593177.10097.9.camel@jlt4.sipsolutions.net> (sfid-20121030_113225_995734_B9D882C4)
Subject: Re: [RFC] wireless: add utility function to get P2P attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Tue, 30 Oct 2012 11:32:57 +0100
In-Reply-To: <1351536651-3176-1-git-send-email-johannes@sipsolutions.net> (sfid-20121029_195023_823133_BFB0B605)
References: <1351536651-3176-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121029_195023_823133_BFB0B605)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-29 at 19:50 +0100, Johannes Berg wrote:

> +		while (iedatalen > 0) {
> +			u16 attr_len;
> +
> +			/* P2P attribute ID & size must fit */
> +			if (iedatalen < 3)
> +				return -EILSEQ;

Ok, damn, this is wrong. Even that could spill over into the next IE :-(

johannes

