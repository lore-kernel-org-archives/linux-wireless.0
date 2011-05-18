Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab1ERXCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 19:02:24 -0400
Subject: Re: [PATCH 1/1] nl80211: check return code for genlmsg_end
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1305555848-17609-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110516_162725_013623_B6AF7B8A)
References: <1305555848-17609-1-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20110516_162725_013623_B6AF7B8A)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 16:04:58 -0700
Message-ID: <1305759898.8827.7.camel@jlt3.sipsolutions.net> (sfid-20110519_010227_111316_826925B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-16 at 07:24 -0700, Wey-Yi Guy wrote:
> Check the return value for genlmsg_end and handle it.

It can never return < 0:

/**
 * nlmsg_end - Finalize a netlink message
 * @skb: socket buffer the message is stored in
 * @nlh: netlink message header
 *
 * Corrects the netlink message header to include the appeneded
 * attributes. Only necessary if attributes have been added to
 * the message.
 *
 * Returns the total data length of the skb.


johannes

