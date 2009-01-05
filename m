Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:42042 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338AbZAEWEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 17:04:45 -0500
Message-ID: <496283F7.7010902@lwfinger.net> (sfid-20090105_230450_079381_247172FF)
Date: Mon, 05 Jan 2009 16:04:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem with rtl8187
References: <496273D4.6020600@lwfinger.net>	 <1231189302.3697.25.camel@johannes>  <4962775B.2040205@lwfinger.net> <1231190634.3697.32.camel@johannes>
In-Reply-To: <1231190634.3697.32.camel@johannes>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> That's rather strange, I see no way for this path to attempt sending an
> SKB that has since been freed. Unless... yes, here's a problem:
> rtl8187_tx is not supposed to return error codes, it's supposed to
> return NETDEV_TX_{OK,BUSY}.

Thanks. That took care of the WARN_ON message and the SLUB debug messages;
however, the device will not scan until it has been powered down. I'm still
looking for something there.

Are there any other mac80211 routines that should be fed other than error codes?

Larry
