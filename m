Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38469 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab1IAQzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 12:55:12 -0400
Received: by qyk34 with SMTP id 34so1286573qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Sep 2011 09:55:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1314833554-40721-2-git-send-email-nbd@openwrt.org>
References: <1314833554-40721-1-git-send-email-nbd@openwrt.org> <1314833554-40721-2-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Thu, 1 Sep 2011 09:54:51 -0700
Message-ID: <CAB=NE6VP_+V=T=Dx0KL9Z0tDNxUW91pPkK4BzqBPwWUP-mzCwg@mail.gmail.com> (sfid-20110901_185527_688414_D7FF3733)
Subject: Re: [PATCH v11 2/4] ath9k: always call ath_reset from workqueue context
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rmanohar@qca.qualcomm.com, shafi.wireless@gmail.com,
	vthiagar@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 31, 2011 at 4:32 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> This makes it much easier to add further rework to avoid race conditions
> between reset and other work items.
> Move other functions to make ath_reset static.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>


> -void ath_hw_check(struct work_struct *work)

I see you are just shuffling this code below but its unclear if the
code is changed for the routine. To make this easier for the reviewer
or anyone who wants to look back in history can you split this into
two patches, one which moves the routines, and the other that does the
other work?

  Luis
