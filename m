Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:54482 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752208Ab1HTPGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Aug 2011 11:06:24 -0400
Date: Sat, 20 Aug 2011 08:06:11 -0700
From: Jouni Malinen <j@w1.fi>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Mark mandatory rates as basic
Message-ID: <20110820150611.GA11915@jm.kir.nu> (sfid-20110820_170629_240055_3F56ED39)
References: <1313841275-7868-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1313841275-7868-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 20, 2011 at 05:24:35PM +0530, Rajkumar Manoharan wrote:
> Currently mac80211 announces a supported rate set with
> no basic rates. This patch marks the mandatory rates as
> basic while constructing supported rate element.

Why would you want to do that? I did not check the mesh use case but
neither Probe Request nor (Re)Association Request frames use the 0x80
flag in the rates - the basic rate set comes from the AP, not the non-AP
STA.. For mesh, I think that only Mesh Peering Open and Mesh Peering
Confirm frames indicate basic rate set, so the first patch of the patch
may or may not be correct depending on whether it applies only to those
frames.

-- 
Jouni Malinen                                            PGP id EFC895FA
