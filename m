Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:45672 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756076AbXLPJ4u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 04:56:50 -0500
Date: Sun, 16 Dec 2007 10:40:31 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/T][PATCH 3/3] rc80211-pid: allow for parameters to be set
 through sysfs
Message-ID: <20071216104031.7e70cf56@morte> (sfid-20071216_095654_741506_4FA0CEA1)
In-Reply-To: <20071209212842.1515704c@morte>
References: <20071209211547.2d7fca32@morte>
	<20071209212842.1515704c@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 9 Dec 2007 21:28:42 +0100
Stefano Brivio <stefano.brivio@polimi.it> wrote:

> This patch allows for tuning parameters to be set through sysfs. Note that
> this lacks locking, as another copy of the whole parameters data would have
> been needed and this won't be the final approach anyway, so don't bother
> too much.
> 
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> 
> ---
> 
> Mattias: oops. Just noticed that my previous approach to locking here was
> bogus due to misconceptions about sysfs parameters. It's possible to get
> locking right here, but quite troublesome.
> Everybody: this lacks proper locking. Never apply this to any sane tree,
> please.

Actually, it looks like we can assume atomic operation by sysfs here. So
I'd go with this approach until we don't add the needed hooks to cfg80211.


--
Ciao
Stefano
