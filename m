Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:42329 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbZAJMGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 07:06:25 -0500
Received: by fk-out-0910.google.com with SMTP id 18so4984017fkq.5
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jan 2009 04:06:22 -0800 (PST)
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<Luis.Rodriguez@atheros.com>, <Jouni.Malinen@atheros.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath9k: Fix basic connectivity issue
References: <1231587429-23989-1-git-send-email-vasanth@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 10 Jan 2009 14:06:19 +0200
In-Reply-To: <1231587429-23989-1-git-send-email-vasanth@atheros.com> (Vasanthakumar Thiagarajan's message of "Sat\, 10 Jan 2009 17\:07\:09 +0530")
Message-ID: <87sknrjrgk.fsf@litku.valot.fi> (sfid-20090110_130629_406033_1793BD38)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vasanth@atheros.com> writes:

> This patch temporarily fixes a regression introduced by BT
> coexistence support. There is an instability in connection when BT
> coexistence is enabled on some h/w. This interim fix introduces a
> module parameter for BT coexistence configuration.
>

[...]

> +static int btcoex_enable;
> +module_param(btcoex_enable, bool, 0);
> +MODULE_PARM_DESC(btcoex_enable, "Enable Bluetooth coexistence support");

Somehow I guessed that this was coming :) I still think that a proper
nl80211 interface for this is in order.

-- 
Kalle Valo
