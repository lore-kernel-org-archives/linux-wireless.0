Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56681 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab0CYGdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 02:33:54 -0400
Received: by bwz1 with SMTP id 1so566253bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 24 Mar 2010 23:33:52 -0700 (PDT)
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: support paged rx SKBs
References: <1269399463-5244-1-git-send-email-yi.zhu@intel.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 25 Mar 2010 08:33:50 +0200
In-Reply-To: <1269399463-5244-1-git-send-email-yi.zhu@intel.com> (Zhu Yi's message of "Wed\, 24 Mar 2010 10\:57\:42 +0800")
Message-ID: <87eij8c3ld.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi <yi.zhu@intel.com> writes:

> Mac80211 drivers can now pass paged SKBs to mac80211 via
> ieee80211_rx{_irqsafe}. The implementation currently use
> skb_linearize() in a few places i.e. management frame handling,
> software decryption, defragmentation and A-MSDU process. We can
> optimize them one by one later.

I think ieee80211_rx{_irqsafe} documentation should now mention that
paged skbs are supported. Better to make this suppot explicit for the
driver authors.

-- 
Kalle Valo
