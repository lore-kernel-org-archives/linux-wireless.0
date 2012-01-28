Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33755 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab2A1NZm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 08:25:42 -0500
Message-ID: <4F23F753.8070405@openwrt.org> (sfid-20120128_142608_152636_64C0E711)
Date: Sat, 28 Jan 2012 14:25:39 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Marek Lindner <lindner_marek@yahoo.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user supplied
 rts setting
References: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de> <1327735027-30121-2-git-send-email-lindner_marek@yahoo.de>
In-Reply-To: <1327735027-30121-2-git-send-email-lindner_marek@yahoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-01-28 8:17 AM, Marek Lindner wrote:
> Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
NACK, minstrel_ht sets RTS/CTS only from the second rate retry slot on,
to increase the success probability during retransmissions. For the
first slot, it is unset. The user supplied rts setting is not suitable
for configuring RTS/CTS usage this way, so if you want to disable it
entirely, you'd need to add a new setting for that.

- Felix
