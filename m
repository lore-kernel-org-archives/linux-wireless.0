Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358AbZJMLvz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 07:51:55 -0400
Date: Tue, 13 Oct 2009 13:51:11 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V3] iwlwifi: use paged Rx
Message-ID: <20091013115110.GA2639@dhcp-lab-161.englab.brq.redhat.com>
References: <1255079985-17282-1-git-send-email-yi.zhu@intel.com> <20091012142002.GA2687@dhcp-lab-161.englab.brq.redhat.com> <1255421948.3719.363.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1255421948.3719.363.camel@debian>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 13, 2009 at 04:19:08PM +0800, Zhu Yi wrote:
> > > Finally, mac80211 doesn't support paged Rx yet. So we linearize the skb
> > > for all the management frames and software decryption or defragmentation
> > > required data frames before handed to mac80211. For all the other frames,
> > > we __pskb_pull_tail 64 bytes in the linear area of the skb for mac80211
> > > to handle them properly.
> > 
> > This seems to be big overhead, but since there is no way to avoid it ...
> 
> Which case? The linear one is the same as the current implementation.

Considering swcrypt for example. This patch make things worse as we still
need to do the same skb allocation as before, plus additional pages allocation,
plus additional memcpy. No ?

Cheers
Stanislaw
