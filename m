Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:39069 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954AbbCaO7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 10:59:14 -0400
Date: Tue, 31 Mar 2015 17:59:10 +0300
From: Jouni Malinen <j@w1.fi>
To: Avinash Patil <patila@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Li Long <longli@marvell.com>
Subject: Re: [PATCH 1/3] mwifiex: add cfg80211 set_default_mgmt_key handler
Message-ID: <20150331145910.GA8244@w1.fi> (sfid-20150331_165918_698232_3BA79BB5)
References: <1423764954-30412-1-git-send-email-patila@marvell.com>
 <1423850815.2936.4.camel@sipsolutions.net>
 <CBACCFA0AEB13A41977475BCF3E896FC689F4C7E9B@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC689F4C7E9B@SC-VEXCH2.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 31, 2015 at 07:33:39AM -0700, Avinash Patil wrote:
> We feel set_default_key_mgmt handler is required for devices which supports 2 pair of GTKs.

Why would a device not support multiple GTKs/IGTKs? It does not sound
possible to implement RSN correctly without such support.. AP side could
kind of try to work with only a single GTK/IGTK, but non-AP STA would
not handle GTK/IGTK rekeying. In any case, IEEE Std 802.11-2012 seems to
be pretty clear on the assumption being that the device (including
AP-only cases) supports multiple GTK/IGTK. The authenticator state
machines use key index values 1 and 2 and swap between these when doing
rekeying.

-- 
Jouni Malinen                                            PGP id EFC895FA
