Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50195 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082AbcDHG5A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2016 02:57:00 -0400
Message-ID: <1460098614.30678.1.camel@sipsolutions.net> (sfid-20160408_085710_192124_E4948ED0)
Subject: Re: [PATCH] mac80211: debugfs var for the default aggregation
 timeout.
From: Johannes Berg <johannes@sipsolutions.net>
To: Avery Pennarun <apenwarr@gmail.com>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Date: Fri, 08 Apr 2016 08:56:54 +0200
In-Reply-To: <CAHqTa-3VtwYWLUHQuFyqtmMwPE2XQYJD4-U+-1PqXKtmTFrEgA@mail.gmail.com> (sfid-20160408_033318_084748_CFEAEAF8)
References: <CAHqTa-22NpabO6B7nL=O26fnuGQHFOzpagWtsfQz4_BfrO6nTw@mail.gmail.com>
	 <1455658091-28262-1-git-send-email-apenwarr@gmail.com>
	 <1455658091-28262-2-git-send-email-apenwarr@gmail.com>
	 <1456222441.2041.10.camel@sipsolutions.net>
	 <CAHqTa-1CkJ-Pm6o7-pxcek4h+hmq6EtA0u12zGGraOUjDjeXSQ@mail.gmail.com>
	 <1456257946.9910.23.camel@sipsolutions.net>
	 <CAHqTa-2bd2Z3LotVUpexWo2B95h3m5pjbjkWy-N=P=LYzCA4Mw@mail.gmail.com>
	 <1459928436.17504.11.camel@sipsolutions.net>
	 <CAHqTa-3VtwYWLUHQuFyqtmMwPE2XQYJD4-U+-1PqXKtmTFrEgA@mail.gmail.com>
	 (sfid-20160408_033318_084748_CFEAEAF8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-04-07 at 21:32 -0400, Avery Pennarun wrote:

> Yes.  Here it is:
> http://apenwarr.ca/tmp/mac80211-agg-status-crash.ko
> 

Unfortunately there are no debug symbols in this file, so it doesn't
help me much. I can't even seem to get objdump to disassemble it
correctly: looks like the file is in thumb, going from things
like R_ARM_THM_CALL relocations, but even -Mforce-thumb doesn't seem to
DRT; sta_agg_status_read+0xeb isn't even a valid instruction offset in
regular ARM mode.

johannes
