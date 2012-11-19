Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:63092 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2KSV0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 16:26:43 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so3722305iay.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 13:26:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353343170-26516-10-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com> <1353343170-26516-10-git-send-email-eliad@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 19 Nov 2012 23:26:27 +0200
Message-ID: <CA+XVXfdRhHKhDcfReYuv8ncnkgG=Msr1eqh63rx08vTO5epLSQ@mail.gmail.com> (sfid-20121119_222646_202073_C42E3B15)
Subject: Re: [PATCH 09/15] wlcore: remove channel handling from op_config
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 6:39 PM, Eliad Peller <eliad@wizery.com> wrote:
> After setting the channel on chanctx callbacks, we
> no longer need to handle channel change notifications
> on op_config.
>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
[...]
> -       /*
> -        * mac80211 will go to idle nearly immediately after transmitting some
> -        * frames, such as the deauth. To make sure those frames reach the air,
> -        * wait here until the TX queue is fully flushed.
> -        */
> -       if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) ||
> -           ((changed & IEEE80211_CONF_CHANGE_IDLE) &&
> -            (conf->flags & IEEE80211_CONF_IDLE)))
> -               wl1271_tx_flush(wl);

This flush (and the comment above) is also a good reason for flushing
tx during wlcore_op_unassign_vif_chanctx...
