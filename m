Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933122AbcKPQRC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 11:17:02 -0500
Date: Wed, 16 Nov 2016 17:12:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org,
        kvalo@codeaurora.org
Subject: Re: [PATCH] rt2x00: Fix incorrect usage of CONFIG_RT2X00_LIB_USB
Message-ID: <20161116161251.GA29605@redhat.com> (sfid-20161116_171711_238447_65BE23DE)
References: <1479312114-9389-1-git-send-email-vishalthanki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479312114-9389-1-git-send-email-vishalthanki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2016 at 05:01:54PM +0100, Vishal Thanki wrote:
> In device removal routine, usage of "#ifdef CONFIG_RT2X00_LIB_USB"
> will not cover the case when it is configured as module. This will
> omit the entire if-block which does cleanup of URBs and cancellation
> of pending work. Changing the #ifdef to #if IS_ENABLED() to fix it.
> 
> Signed-off-by: Vishal Thanki <vishalthanki@gmail.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
