Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:65523 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbZJ2QSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 12:18:36 -0400
Received: by iwn10 with SMTP id 10so1466308iwn.4
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2009 09:18:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256760832-29063-1-git-send-email-reinette.chatre@intel.com>
References: <1256760832-29063-1-git-send-email-reinette.chatre@intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 29 Oct 2009 09:18:21 -0700
Message-ID: <43e72e890910290918v1ca66bbdk4270eabcae6f5798@mail.gmail.com>
Subject: Re: [PATCH] mac80211: make align adjustment code support paged SKB
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2009 at 1:13 PM, Reinette Chatre
<reinette.chatre@intel.com> wrote:
> From: Zhu Yi <yi.zhu@intel.com>
>
> This fixed a BUG_ON in __skb_trim() when paged rx is used in
> iwlwifi driver. Yes, the whole mac80211 stack doesn't support
> paged SKB yet. But let's start the work slowly from small
> code snippets.

So I just noticed ar9271 segments some frames upon RX. The current
implementation approach is to stitch them back together through a
newly allocated skb after all segments are received. How does iwlwifi
ues paged skbs? How do you keep track of which page is for what frame?

Can you elaborate on the planned paged skb support on mac80211 you
have. Do you have any queued up patches I can look at this point?

  Luis
