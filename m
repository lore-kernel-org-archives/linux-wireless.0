Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39932 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbcELJMv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2016 05:12:51 -0400
Message-ID: <1463044367.13313.9.camel@sipsolutions.net> (sfid-20160512_111319_672814_399E041E)
Subject: Re: [PATCH v2] mac80211:  add vht cap decode to debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Thu, 12 May 2016 11:12:47 +0200
In-Reply-To: <1462224198-24154-1-git-send-email-greearb@candelatech.com> (sfid-20160502_232327_373056_D35C73E3)
References: <1462224198-24154-1-git-send-email-greearb@candelatech.com>
	 (sfid-20160502_232327_373056_D35C73E3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-05-02 at 14:23 -0700, greearb@candelatech.com wrote:
> 
> +		PFLAG(MAX_MPDU_LENGTH_3895, "MAX-MPDU-3895");
> +		PFLAG(MAX_MPDU_LENGTH_7991, "MAX-MPDU-7991");
> +		PFLAG(MAX_MPDU_LENGTH_11454, "MAX-MPDU-11454");

This doesn't work as intended, please treat this two-bit field
properly.

> +		PFLAG(SUPP_CHAN_WIDTH_160MHZ, "160Mhz");
> +		PFLAG(SUPP_CHAN_WIDTH_160_80PLUS80MHZ, "160-
> 80+80Mhz");

Same here.

> +		PFLAG(RXSTBC_1, "RXSTBC_1");
> +		PFLAG(RXSTBC_2, "RXSTBC_2");
> +		PFLAG(RXSTBC_3, "RXSTBC_3");
> +		PFLAG(RXSTBC_4, "RXSTBC_4");

This is clearly also wrong, as you could even see in the output you
pasted into the commit log.

johannes
