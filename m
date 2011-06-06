Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1FFJcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:32:46 -0400
Subject: Re: problems with hwcrypt
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>
In-Reply-To: <4DE9EF9A.1030803@01019freenet.de> (sfid-20110604_104050_418138_29821500)
References: <4DE9EF9A.1030803@01019freenet.de>
	 (sfid-20110604_104050_418138_29821500)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 11:32:41 +0200
Message-ID: <1307352761.3894.0.camel@jlt3.sipsolutions.net> (sfid-20110606_113251_361248_F38ADCCE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-06-04 at 10:40 +0200, Andreas Hartmann wrote:

> Jun  4 09:44:52 pc kernel: [ 8517.220574] ------------[ cut here
> ]------------
> Jun  4 09:44:52 pc kernel: [ 8517.220595] WARNING: at
> /raid/home/andreas/tttt/compat-wireless-2011-05-31/net/mac80211/wpa.c:397 ccmp_encrypt_skb+0xc4/0x1f0

This is to blame on

commit aac6af5534fade2b18682a0b9efad1a6c04c34c6
Author: Yogesh Ashok Powar <yogeshp@marvell.com>
Date:   Wed Apr 27 18:40:29 2011 +0530

    mac80211: Skip tailroom reservation for full HW-crypto devices


John, please revert this for 3.0, Yogesh, please fix the races before
you resubmit.

johannes

