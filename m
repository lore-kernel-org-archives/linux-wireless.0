Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13312 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbZLVPDy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 10:03:54 -0500
Message-ID: <20091222100353.afqlt5tog0o0cw4w-cebfxv@webmail.spamcop.net>
Date: Tue, 22 Dec 2009 10:03:53 -0500
From: Pavel Roskin <proski@gnu.org>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Markus Baier <Markus_Baier@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [BISECTED] [PATCH v2 8/8] rt2x00: Properly request tx headroom
	for alignment operations.
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>
	<1259012694-14869-2-git-send-email-gwingerde@gmail.com>
	<1259012694-14869-3-git-send-email-gwingerde@gmail.com>
	<1259012694-14869-4-git-send-email-gwingerde@gmail.com>
	<1259012694-14869-5-git-send-email-gwingerde@gmail.com>
	<1259012694-14869-6-git-send-email-gwingerde@gmail.com>
	<1259012694-14869-7-git-send-email-gwingerde@gmail.com>
	<1259012694-14869-8-git-send-email-gwingerde@gmail.com>
	<1259012694-14869-9-git-send-email-gwingerde@gmail.com>
	<loom.20091220T163829-137@post.gmane.org> <4B2E8729.7050501@gmail.com>
	<20091221013316.nm9belnhywwwsc0w-cebfxv@webmail.spamcop.net>
	<4B2FA1CF.1010903@gmail.com> <1261459549.31982.2.camel@ct>
	<4B307FB1.5040806@gmail.com>
In-Reply-To: <4B307FB1.5040806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Gertjan van Wingerde <gwingerde@gmail.com>:

> Doh, that's it. Here we should indeed only take the real extra TX   
> headroom required by
> the driver into account. Seems like I goofed up in a preparatory   
> patch that centralized
> setting of rt2x00dev->hw->extra_tx_headroom.
>
> Can you confirm that everything works okay with the original code   
> and this patch applied?

The managed mode is working fine for me.

I think it would be a good idea to test all modes and make sure that  
the patch for adding extra headroom does what it should (in addition  
to not breaking things).

-- 
Regards,
Pavel Roskin
