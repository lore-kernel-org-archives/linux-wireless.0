Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:55358 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753340AbeAFPGx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Jan 2018 10:06:53 -0500
Date: Sat, 6 Jan 2018 15:06:21 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Christian Lamparter <chunkeey@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        peterz@infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, Kalle Valo <kvalo@codeaurora.org>,
        alan@linux.intel.com
Subject: Re: [PATCH 08/18] carl9170: prevent bounds-check bypass via
 speculative execution
Message-ID: <20180106150621.2221a646@alans-desktop> (sfid-20180106_160712_462314_C945DDC4)
In-Reply-To: <3586343.KJymplWpZW@debian64>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
        <151520103755.32271.6819511294540882298.stgit@dwillia2-desk3.amr.corp.intel.com>
        <3586343.KJymplWpZW@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The only way a user can set this in any meaningful way would be via
> a NL80211_CMD_SET_WIPHY netlink message. However, the value will get
> vetted there by cfg80211's parse_txq_params [0]. This is long before

Far more than a couple of hundred instructions ? The problem is that the
processor will speculate that the parameter is valid and continue on that
basis until the speculation resolves or it hits some other limit that
stops it speculating further. That can be quite a distance on a modern
x86 processor, and for all we know could be even more on some of the
other CPUs involved.

> it reaches any of the *_op_conf_tx functions.
> 
> And Furthermore a invalid queue (param->ac) would cause a crash in 
> this line in mac80211 before it even reaches the driver [1]:
> |	sdata->tx_conf[params->ac] = p;
> |                   ^^^^^^^^

Firstly it might not because the address you get as a result could be
valid kernel memory. In fact your attackers wants it to be valid kernel
memory since they are trying to find the value of a piece of that memory.

Secondly the processor is doing this speculatively so it won't fault. It
will eventually decide it went the wrong way and throw all the
speculative work away - leaving footprints. It won't fault unless the
speculative resolves that was the real path the code took.

If it's not a performance critical path then it's better to be safe.

Alan
