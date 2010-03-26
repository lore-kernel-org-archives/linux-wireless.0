Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16241 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab0CZD5M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 23:57:12 -0400
Subject: Re: [PATCH 1/2] mac80211: support paged rx SKBs
From: Zhu Yi <yi.zhu@intel.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87eij8c3ld.fsf@purkki.valot.fi>
References: <1269399463-5244-1-git-send-email-yi.zhu@intel.com>
	 <87eij8c3ld.fsf@purkki.valot.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 11:57:57 +0800
Message-ID: <1269575877.4043.203.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-25 at 14:33 +0800, Kalle Valo wrote:
> Zhu Yi <yi.zhu@intel.com> writes:
> 
> > Mac80211 drivers can now pass paged SKBs to mac80211 via
> > ieee80211_rx{_irqsafe}. The implementation currently use
> > skb_linearize() in a few places i.e. management frame handling,
> > software decryption, defragmentation and A-MSDU process. We can
> > optimize them one by one later.
> 
> I think ieee80211_rx{_irqsafe} documentation should now mention that
> paged skbs are supported. Better to make this suppot explicit for the
> driver authors.

Good idea it should be documented somewhere (after the patch is
accepted). Maybe the developer wiki page? For the code itself, I think
Linux drivers can always assume the network stacks support paged
buffers. In case some stack doesn't support paged buffer, it should do
skb_linearize() itself in the very beginning of its rcv handling (e.g.
sctp_rcv, tipc_recv_msg, etc).

Thanks,
-yi

