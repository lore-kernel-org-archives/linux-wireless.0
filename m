Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:63454 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3FJCmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 22:42:08 -0400
Received: by mail-bk0-f52.google.com with SMTP id d7so2648584bkh.11
        for <linux-wireless@vger.kernel.org>; Sun, 09 Jun 2013 19:42:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370301943-13867-2-git-send-email-thomas@cozybit.com>
References: <1370301943-13867-1-git-send-email-thomas@cozybit.com> <1370301943-13867-2-git-send-email-thomas@cozybit.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Sun, 9 Jun 2013 19:41:46 -0700
Message-ID: <CAG6hwVPbc=-airtoDSMmhzYQ+X64Qv42F+mnEQ5vbHjxC5wCew@mail.gmail.com> (sfid-20130610_044213_347557_BBF719EC)
Subject: Re: [PATCH 2/2] mac80211: update mesh beacon on workqueue
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 3, 2013 at 4:25 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
> Fixes yet another deadlock on calling sta_info_flush()
> with the sdata_lock() held. Should make it easier to
> reason about locking in the future, since the sdata_lock()
> is now held on all mesh work.
>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---

[...]

> +static void mesh_bss_info_changed(struct ieee80211_sub_if_data *sdata)
> +{
> +       struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
> +#define TEST_CHANGED_BIT(bit) \
> +       test_and_clear_bit(bit, &ifmsh->mbss_changed)
> +
> +       u32 changed = TEST_CHANGED_BIT(BSS_CHANGED_BEACON) |
> +                     TEST_CHANGED_BIT(BSS_CHANGED_HT) |
> +                     TEST_CHANGED_BIT(BSS_CHANGED_BASIC_RATES) |
> +                     TEST_CHANGED_BIT(BSS_CHANGED_BEACON_INT);
> +#undef TEST_CHANGED_BIT

Uhhh we should read all the bits here. Will fix and resubmit as v2.

--
Thomas
