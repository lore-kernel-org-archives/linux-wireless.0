Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.185]:36916 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbYILCmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 22:42:17 -0400
Received: by gv-out-0910.google.com with SMTP id e6so412210gvc.37
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2008 19:42:15 -0700 (PDT)
Date: Fri, 12 Sep 2008 06:44:09 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: I need help with a sparse warning
Message-ID: <20080912024409.GB3670@x200.localdomain> (sfid-20080912_044221_377496_617D04CC)
References: <48C9D040.8010107@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48C9D040.8010107@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 11, 2008 at 09:13:20PM -0500, Larry Finger wrote:
> In file drivers/net/wireless/p54/p54common.c, the statement
>
>        priv->rx_mtu = (size_t) le16_to_cpu((__le16)bootrec->data[10]);
>
> generates the sparse warning
>
> .../p54common.c:185:29: warning: cast to restricted __le16
>
> where bootrec->data is u32, and priv->rx_mtu is u16.
>
> What should be done to eliminate this warning?

What is the intent?

MTU is 2-byte little-endian starting at 40-th byte?

Oh, and size_t cast is pointless.
