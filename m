Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33027 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbcBWOKc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 09:10:32 -0500
Message-ID: <1456236627.9910.10.camel@sipsolutions.net> (sfid-20160223_151035_550818_A9A1D71F)
Subject: Re: [PATCH] mac80211:  Let VHT work on 2.4Ghz
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
Date: Tue, 23 Feb 2016 15:10:27 +0100
In-Reply-To: <1456180974-21062-1-git-send-email-greearb@candelatech.com>
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-22 at 14:42 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> ath10k supports VHT on 2.4Ghz band.

It can't. At least not formally, as this sentence is written, since VHT
per the spec requires operating on the 5 GHz band, and it also requires
80 MHz bandwidth which isn't even available in 2.4 GHz in many
countries.

What you really "want" is to use VHT modulations, mostly for the
dubious purpose of marketing benchmarks to reach 256-QAM modulations.

I think the de-facto standard for this would be to use IEs similar to
VHT ones, encapsulated in some (Broadcom?) vendor IE. We may have to
work with that, but that's not what this patch does. Jouni had some
better idea how this worked, I think.

Also, as written, this patch has practically no effect because no
driver can or should advertise real VHT support on 2.4 GHz band, even
if the code structure were to allow that.

johannes
