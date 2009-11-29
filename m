Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f215.google.com ([209.85.219.215]:63643 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZK2UQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 15:16:23 -0500
Received: by ewy7 with SMTP id 7so3726297ewy.28
        for <linux-wireless@vger.kernel.org>; Sun, 29 Nov 2009 12:16:29 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: annotate sleeping driver ops
References: <1259439566-26397-1-git-send-email-kalle.valo@iki.fi>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 29 Nov 2009 22:16:27 +0200
In-Reply-To: <1259439566-26397-1-git-send-email-kalle.valo@iki.fi> (Kalle Valo's message of "Sat\, 28 Nov 2009 22\:19\:26 +0200")
Message-ID: <87ws196q90.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@iki.fi> writes:

> To make it easier to notice cases of calling sleeping ops in atomic context,
> annotate driver-ops.h with appropiate might_sleep() calls. At the same time,
> also document in mac80211.h the op functions with missing contexts.
>
> mac80211 doesn't seem to use get_tx_stats anywhere currently. Just to be on
> the safe side, I documented it to be atomic, but hopefully the op can be
> removed in the future.
>
> Compile-tested only.

FWIW, I tested the patch with wl1251 and iwl3945 and no warnings visible.

-- 
Kalle Valo
