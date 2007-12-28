Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34277
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbXL1WBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2007 17:01:04 -0500
Date: Fri, 28 Dec 2007 14:01:03 -0800 (PST)
Message-Id: <20071228.140103.159573237.davem@davemloft.net> (sfid-20071228_220113_025956_3B2CF6B8)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: cfg80211 API for channels/bitrates, mac80211 and driver
 conversion
From: David Miller <davem@davemloft.net>
In-Reply-To: <1198878633.4172.19.camel@johannes.berg>
References: <1198878633.4172.19.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 28 Dec 2007 22:50:33 +0100

>  include/net/wireless.h                       |  168 ++++++++++ 

Are the datastructures in this file the ones that go over
netlink and thus userland sees?

If so, please move the definitions to some file under include/linux,
as a convention we do not put userland API definitions into files
under include/net, that's why there is no include/net/Kbuild file.
