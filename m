Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731Ab0D3SIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 14:08:44 -0400
Subject: Re: [PATCH] mac80211: fix paged defragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1272488362-14603-1-git-send-email-abhijeet.kolekar@intel.com>
References: <1272488362-14603-1-git-send-email-abhijeet.kolekar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Apr 2010 08:37:19 +0200
Message-ID: <1272523039.3736.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-04-28 at 13:59 -0700, Abhijeet Kolekar wrote:
> Fix the bug at
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2194
> 
> Paged RX skb patch broke the fragmentation while checking the sequnce
> control bit in headers. Instead of doing linearization of all the frames
> to check seq_ctrl bit just copy the bits.

Just FYI, we're discussing this patch still and Zhu Yi found that most
likely this won't actually fix it since the seq_ctrl should already be
part of the linear data. Instead the real problem seems to be a missing
reload of the hdr variable after linearizing.

johannes

