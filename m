Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:38962 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab0IJWoV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 18:44:21 -0400
Message-ID: <4C8AB4BD.5090204@openwrt.org>
Date: Fri, 10 Sep 2010 15:44:13 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [virtual-sta 3/3] mac80211:  Allow multiple STA on same BSS.
References: <1284156298-15863-1-git-send-email-greearb@candelatech.com> <1284156298-15863-3-git-send-email-greearb@candelatech.com>
In-Reply-To: <1284156298-15863-3-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-10 3:04 PM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> When adding an STA, the old code checked if there was already
> an STA with the same BSS.  Instead, check to see if there is
> exactly the same STA in order to allow multiple STA to be
> associated with the same AP.
I think that's misleading. sta_info_get_bss does not check if there is a
STA with the same BSS. Like sta_info_get it looks for a STA with the
given address, but unlike sta_info_get, it also accepts it if it's on a
different interface than the provided sdata, but part of the same BSS as
the sdata's.
Because of that, this change seems bogus to me.

- Felix
