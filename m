Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47373 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2KSTQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 14:16:31 -0500
Date: Mon, 19 Nov 2012 13:16:25 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>
Subject: Re: [PATCH v2 05/22] brcmsmac: Use IEEE 802.11 AC levels for pktq
 precedence levels
Message-ID: <20121119191625.GA20301@thinkpad-t410> (sfid-20121119_201634_970663_F4B2A6D4)
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-6-git-send-email-seth.forshee@canonical.com>
 <50AA7D7C.8020208@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50AA7D7C.8020208@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 07:42:04PM +0100, Arend van Spriel wrote:
> On 11/15/2012 03:07 PM, Seth Forshee wrote:
> >The mac80211 tx queues and brcmsmac DMA fifos both map directly to AC
> >levels. Therefore it's much more straightforward to queue tx frames and
> >choose the tx fifo based on the mac80211 queue instead of mapping 802.1D
> >priority tags to precedence levels then back to AC levels. mac80211
> >already maps the 802.1D levels to the appropriate AC levels and queues
> >management frames at the maximum priority, so the results should be
> >identical.
> >
> >One functional change resulting from this patch is that AMPDU retries no
> >longer get a priority boost to queue them ahead of packets with the same
> 
> True. I believe the statement actually applies to any retry include
> non-AMPDU.

I don't see that non-AMPDU frames are ever requeued after failed tx. Am
I overlooking soemthing?

Seth

