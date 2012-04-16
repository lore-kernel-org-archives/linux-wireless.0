Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36670 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2DPQZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 12:25:37 -0400
Message-ID: <4F8C47FD.6060100@sipsolutions.net> (sfid-20120416_182540_346253_BA69CA91)
Date: Mon, 16 Apr 2012 09:25:33 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: fix truncated packets in cooked monitor rx
References: <1334581008-22807-1-git-send-email-nbd@openwrt.org> (sfid-20120416_145711_625361_925CBBCF)
In-Reply-To: <1334581008-22807-1-git-send-email-nbd@openwrt.org> (sfid-20120416_145711_625361_925CBBCF)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/16/2012 5:56 AM, Felix Fietkau wrote:
> Cooked monitor rx was recently changed to use ieee80211_add_rx_radiotap_header
> instead of generating only limited radiotap information.
> ieee80211_add_rx_radiotap_header assumes that FCS info is still present if
> the hardware supports receiving it, however when cooked monitor rx packets
> are processed, FCS info has already been stripped.
> Fix this by adding an extra flag indicating FCS presence.

Good catch, thanks.

johannes
