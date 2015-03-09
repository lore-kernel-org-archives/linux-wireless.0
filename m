Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33663 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbbCIIcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 04:32:13 -0400
Received: by wggz12 with SMTP id z12so6938395wgg.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 01:32:12 -0700 (PDT)
From: Sven Eckelmann <sven@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC v2] [RFC] mac80211: lock rate control
Date: Mon, 09 Mar 2015 09:32:08 +0100
Message-ID: <1741038.iCoNEntVIV@bentobox> (sfid-20150309_093217_573370_C3363CC7)
In-Reply-To: <1425639348.3339.2.camel@sipsolutions.net>
References: <1425575237-5556-1-git-send-email-johannes@sipsolutions.net> <2736671.Y6Lt54SxyK@bentobox> <1425639348.3339.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 March 2015 11:55:48 Johannes Berg wrote:
> > I will just add following modification to your patch and ask for a new
> > test.
>
> Let me know how that goes :)

I got a reply and they informed me that the test looked promising. The test 
setup didn't crash and was running stable for hours. It looks like the extra 
locking in rate_control_rate_init around ref->ops->rate_init was the missing 
part in your patch that was necessary fix the problem for them.

Kind regards,
	Sven
