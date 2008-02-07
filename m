Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:32063 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbYBGQG1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 11:06:27 -0500
Received: by an-out-0708.google.com with SMTP id d31so810852and.103
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2008 08:06:26 -0800 (PST)
Message-ID: <40f31dec0802070806g7ebb098o1f9c094346db3f1@mail.gmail.com> (sfid-20080207_160632_486225_A13FD19B)
Date: Thu, 7 Feb 2008 18:06:26 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC v2] mac80211: add general rate information to Tx status
Cc: "Tomas Winkler" <tomasw@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1202380914.5718.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <12022263282085-git-send-email-tomas.winkler@intel.com>
	 <1202307331.4395.41.camel@johannes.berg>
	 <1ba2fa240802060644k3f0b5e7cgb48380a2b3181f41@mail.gmail.com>
	 <1202309885.9965.3.camel@johannes.berg>
	 <1ba2fa240802060818t5945ff67jb64ccee0a407c604@mail.gmail.com>
	 <1202315330.9965.16.camel@johannes.berg>
	 <1ba2fa240802061004u5f4bc2f8q2fbfbb7778121873@mail.gmail.com>
	 <1202380914.5718.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Actually in spite of the IF there I don't think  it  ever happens that
> > iwlwifi uses tx_status() directly only irqsafe. Does any driver uses
> > tx_status directly anyway?
>
> ath5k does, but I have no idea why.
>

We have separate tasklets for tx/rx (so we can parse descriptrors,
keep buffers/descriptors in sync etc), so we call ieee80211_tx_status
from our tx tasklet.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
