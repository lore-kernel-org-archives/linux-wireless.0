Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab0CXM6G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 08:58:06 -0400
Date: Wed, 24 Mar 2010 14:00:34 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH 1/2] mac80211: support paged rx SKBs
Message-ID: <20100324140034.6a6d91c9@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1269399463-5244-1-git-send-email-yi.zhu@intel.com>
References: <1269399463-5244-1-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 24 Mar 2010 10:57:42 +0800
Zhu Yi <yi.zhu@intel.com> wrote:

> Mac80211 drivers can now pass paged SKBs to mac80211 via
> ieee80211_rx{_irqsafe}. The implementation currently use
> skb_linearize() in a few places i.e. management frame handling,
> software decryption, defragmentation and A-MSDU process. 

What benefits this gives? Only driver which need non linear skbs
is iwliwifi and nicely handle that by itself. I do not see any 
other potential users for that. Can we wait for some other
users before put that feature into mac stack?

Stanislaw

