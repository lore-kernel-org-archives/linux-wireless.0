Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3E0JDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 05:03:45 -0400
Message-ID: <1369645418.8229.17.camel@jlt4.sipsolutions.net> (sfid-20130527_110348_351060_93767C64)
Subject: Re: P2P Device support: how to deal with p2p_no_group_iface option
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jithu Jance <jithu@broadcom.com>
Date: Mon, 27 May 2013 11:03:38 +0200
In-Reply-To: <51A09F43.5030004@broadcom.com>
References: <51A09F43.5030004@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I looked into issues around hwsim p2p tests and got all but one p2p test 
> passing now (test_autogo_tdls). I had to remove the p2p_no_group_iface 
> option from the p2px.conf files, because otherwise it tries to change 
> the P2P management interface into a P2P group interface. When using 
> P2P_DEVICE and P2P management interface this is not allowed by 
> mac80211_hwsim. Also for brcmfmac the P2P_DEVICE interface is dedicated 
> and can only be added/deleted, but not changed. Not sure if that is true 
> for iwlmvm as well.
> 
> So I would like to discuss how to deal with the p2p_no_group_iface 
> option. As P2P_DEVICE is a new concept the name of the option may no 
> longer match what it intends. Is the option to force all P2P operations 
> to be done on a single interface, ie. wlan0 (or whatever is specified on 
> the command line) and no P2P_DEVICE is to be created. Or should it 
> change the interface from the command line as P2P group interface.

I don't think I'd do either of those. Not creating P2P_DEVICE will
simply not work with drivers expecting it, and changing iftype to/from
P2P-Device isn't supported since it would delete/create the netdev.

I don't really see much choice but reject (or ignore) this option for
drivers using P2P_DEVICE. Why would anyone *really* want P2P operation
on wlan0 when another interface can be used?

johannes

