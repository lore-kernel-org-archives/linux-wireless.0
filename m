Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:13896 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYI2Lil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 07:38:41 -0400
Received: by ey-out-2122.google.com with SMTP id 6so544611eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 04:38:39 -0700 (PDT)
Message-ID: <48E0BE3B.7030204@gmail.com> (sfid-20080929_133845_357881_B1A31349)
Date: Mon, 29 Sep 2008 13:38:35 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
References: <48E0A65A.2060102@gmail.com>	 <1222682480.7064.16.camel@johannes.berg> <20080929102021.GE10429@jm.kir.nu> <1222683923.7064.18.camel@johannes.berg>
In-Reply-To: <1222683923.7064.18.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2008 12:25 PM, Johannes Berg wrote:
> Jiri, can you tell me what happens with iw? iw phy phy0 info or
> something.

[iw from v0.9.5-1-ged69ad9]
# ./iw phy phy0 info
command failed: No buffer space available (-105)

as expected :). It depends only on how nl80211_send_wiphy() is written (the msg
doesn't fit into NLMSG_GOODSIZE).
