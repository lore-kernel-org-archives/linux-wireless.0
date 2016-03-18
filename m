Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbcCRKzs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 06:55:48 -0400
Date: Fri, 18 Mar 2016 11:53:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sara Sharon <sarasharon1@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>
Subject: Re: [PATCH MOREWORK 18/19] iwl4965: Fix more memory leaks in
 __il4965_up()
Message-ID: <20160318105329.GE24990@redhat.com> (sfid-20160318_115551_207611_F1B5C960)
References: <cover.1458262312.git.julian.calaby@gmail.com>
 <6bec5a9b55f13d40c2803f0fa60173451d5ea14a.1458262312.git.julian.calaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6bec5a9b55f13d40c2803f0fa60173451d5ea14a.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2016 at 01:29:11PM +1100, Julian Calaby wrote:
> In some of the non-success return paths, the memory allocated by
> iwl4965_sta_alloc_lq() in iwl4965_alloc_bcast_station() is not freed.
> 
> In particular:
>  - if the card isn't ready after il4965_prepare_card_hw()
>  - if the card is hardware-rfkilled
> 
> In the hardware rfkilled path, the driver enables the rfkill
> interrupt. When the card is unrfkilled and this interrupt is raised
> we end up calling il4965_bg_restart() which calls __il4965_up() which
> calls iwl4965_alloc_bcast_station() again.
> 
> Suggested-by: Jia-Ju Bai <baijiaju1990@163.com>
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
> 
> ---
> 
> This is only compile tested as I don't have compatible hardware. I also
> don't know the driver enough to know that this is truly correct - however
> it looks right and I stand by my analysis.
> 
> Could someone else please review this?

I have similar objection like on previous patch "iwl4965: Fix a memory
leak in error handling code of __il4965_up" . Next week I will try 
test that on the HW and see how it's going. For now  this look for me,
like different fix should be prepared.

Thanks
Stanislaw
