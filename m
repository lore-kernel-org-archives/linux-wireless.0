Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:34231 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbcC2FiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 01:38:09 -0400
Date: Tue, 29 Mar 2016 16:31:03 +1100
From: James Cameron <quozl@laptop.org>
To: Wei-Ning Huang <wnhuang@chromium.org>
Cc: linux-wireless@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>, snanda@google.com,
	kvalo@codeaurora.org, netdev@vger.kernel.org
Subject: Re: [PATCH] mwifiex: add __GFP_REPEAT to skb allocation call
Message-ID: <20160329053103.GH32709@us.netrek.org> (sfid-20160329_073829_250481_879626C0)
References: <1459226840-36287-1-git-send-email-wnhuang@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459226840-36287-1-git-send-email-wnhuang@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 29, 2016 at 12:47:20PM +0800, Wei-Ning Huang wrote:
> "single skb allocation failure" happens when system is under heavy
> memory pressure.  Add __GFP_REPEAT to skb allocation call so kernel
> attempts to reclaim pages and retry the allocation.

Oh, that's interesting, we're back to this symptom again.

Nice to see this fix.

Heavy memory pressure on 3.5 caused dev_alloc_skb failure in this
driver.  Tracked at OLPC as #12694.

-- 
James Cameron
http://quozl.netrek.org/
