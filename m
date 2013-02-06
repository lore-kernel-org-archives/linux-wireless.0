Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63549 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab3BFI0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 03:26:38 -0500
Received: by mail-wg0-f51.google.com with SMTP id 8so888964wgl.30
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 00:26:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360137925-14264-1-git-send-email-thomas@cozybit.com>
References: <1360137925-14264-1-git-send-email-thomas@cozybit.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 6 Feb 2013 00:26:17 -0800
Message-ID: <CAG6hwVMTsgr7KBNadQ1dewaQTn5cDKiaLNsGF9ZP2S+xAMOfqQ@mail.gmail.com> (sfid-20130206_092641_887458_CE67F0E7)
Subject: Re: [PATCH] mac80211: fix mesh sta teardown
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 6, 2013 at 12:05 AM, Thomas Pedersen <thomas@cozybit.com> wrote:
> The patch "mac80211: clean up mesh sta allocation warning"
> moved some mesh initialization into a path which is only
> called when the kernel handles peering. This causes a hang
> when mac80211 tries to clean up a userspace-allocated
> station entry and delete a timer which has never been
> initialized.
>
> To avoid this, only do any mesh sta peering teardown if
> the kernel is actually handling it.

Wait, this would also apply to the del_timer_sync() in
mesh_plink_quiesce() then. v2 will add this check to that function.

-- 
Thomas
