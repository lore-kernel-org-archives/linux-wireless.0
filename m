Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48500 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZGTV3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 17:29:00 -0400
Message-ID: <4A64E199.70501@gmail.com>
Date: Mon, 20 Jul 2009 23:28:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Kalle Valo <kalle.valo@iki.fi>
CC: linville@tuxdriver.com, luciano.coelho@nokia.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wireless: wl12xx, fix lock imbalance
References: <1247603833-10862-1-git-send-email-jirislaby@gmail.com> <87eish56zj.fsf@litku.valot.fi>
In-Reply-To: <87eish56zj.fsf@litku.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/16/2009 11:09 AM, Kalle Valo wrote:
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>> ---
>>  drivers/net/wireless/wl12xx/main.c |    2 +-
> 
> Unfortunately this won't apply to wireless-testing because main.c is
> renamed to wl1251_main.c.
> Can you respin the patch or do you want me to
> do it? I'm sending other wl12xx patches anyway and it's easy for me to
> rebase this one at the same time.

It seems to be fixed now. But currently I'm confused by wl1251_plt_start
and wl1251_plt_stop. They take a lock but doesn't unlock it at all.
Neither their callies. Is it hidden somewhere deeper?
