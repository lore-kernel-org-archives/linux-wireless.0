Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:50611 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758902AbZFZMLB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2009 08:11:01 -0400
From: Frans Pop <elendil@planet.nl>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [2.6.31-rc1] iwlagn (4965): no wireless due to RFKILL problem
Date: Fri, 26 Jun 2009 14:10:57 +0200
Cc: linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200906261336.29318.elendil@planet.nl> <8db1092f0906260459n308311faweb6d9733cdd1eb13@mail.gmail.com>
In-Reply-To: <8db1092f0906260459n308311faweb6d9733cdd1eb13@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200906261410.58808.elendil@planet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 June 2009, Maciej Rutecki wrote:
> 2009/6/26 Frans Pop <elendil@planet.nl>:
> > I've tried .31-rc1 on my HP 2510p notebook and the only problem I
> > found was that wireless no longer works. The cause looks to be
> > related to RFKILL.
>
> Same on HP/Compaq nx6310, caused by hp-wmi module. It's disable
> bluetooth and wireless. I must turn it on in Windows XP (in HP tools).
> Workaround: don't load hp-wmi. Already I try find how enable it via
> /sys like in Windows.

Thanks for narrowing it down.

Well, with 2.6.30 hp-wmi worked together with rfkill without problems.
Looking at the commit logs, it looks like the rfkill rewrite by Johannes 
and Alan is the cause here. CCs added.
