Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab1F1MrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 08:47:04 -0400
Subject: Re: [PATCH] mac80211: Skip tailroom reservation for full HW-crypto
 devices with race fix
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
In-Reply-To: <20110628122810.GA15464@hertz.marvell.com>
References: <20110628122810.GA15464@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jun 2011 14:46:57 +0200
Message-ID: <1309265217.3929.6.camel@jlt3.sipsolutions.net> (sfid-20110628_145239_588814_43825C56)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-28 at 17:58 +0530, Yogesh Ashok Powar wrote:
> Based on inputs from Johannes Berg <johannes@sipsolutions.net>
> from http://markmail.org/thread/t4acssvlgb5gamt2 and
> http://markmail.org/thread/mydlihrhvfvevuim
> 
> In xmit path, devices that do full hardware crypto (including
> MMIC and ICV) need no tailroom. For such devices, tailroom
> reservation can be skipped if all the keys are programmed into
> the hardware (i.e software crypto is not used for any of the
> keys) and none of the keys wants software to generate Michael
> MIC and IV.
> 
> v2: Added check for IV along with MMIC to avoid
> >WARNING: at net/mac80211/wep.c:101 ieee80211_wep_add_iv+0x56/0xf3()
> Reported-by: Fabio Rossi <rossi.f@inwind.it>
> Tested-by: Fabio Rossi <rossi.f@inwind.it>
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> Cc: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> v3: Fixing races to avoid
> >WARNING: at net/mac80211/wpa.c:397 ccmp_encrypt_skb+0xc4/0x1f0
> Reported-by: Andreas Hartmann <andihartmann@01019freenet.de>
> Tested-by: Andreas Hartmann <andihartmann@01019freenet.de>
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>

This changelog entry is kinda messed up.

> +	 * Solution has been explained at
> +	 * http://markmail.org/message/c3ykchyv6azzmdum

Nothing against markmail, but I prefer links that contain a message ID
so if the link ever goes dead, you can google for the message ID. Maybe
use
http://mid.gmane.org/1308590980.4322.19.camel@jlt3.sipsolutions.net

johannes

