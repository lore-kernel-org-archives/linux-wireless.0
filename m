Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45778 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1BNWfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 17:35:16 -0500
Received: by bwz15 with SMTP id 15so5988568bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 14:35:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297685761.3785.38.camel@jlt3.sipsolutions.net>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	<1297619803-2832-3-git-send-email-njs@pobox.com>
	<1297685761.3785.38.camel@jlt3.sipsolutions.net>
Date: Mon, 14 Feb 2011 14:35:13 -0800
Message-ID: <AANLkTikmsizzK1J=uf4Rp9fkmDdJQ_oKfZV-jUz2sJ18@mail.gmail.com>
Subject: Re: [PATCH 2/5] iwlwifi: Convert the tx queue high_mark to an atomic_t
From: Nathaniel Smith <njs@pobox.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 4:16 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2011-02-13 at 09:56 -0800, Nathaniel J. Smith wrote:
>> This patch should cause no behavioral change whatsoever.
>
> Right -- but it makes the TX path quite a bit more expensive on some
> architectures. Why is this necessary? There should be locking in most
> places already, and where not it should be easy to move this under the
> existing lock.

Yes, I suspect we could use the priv->lock for this purpose (at the
expense of adding a lock/unlock on the TX notification path), but I'd
like some confirmation from someone more familiar with the code before
trying. high_mark is read from all over the place, and was previously
read-only, so it really needs someone who understands this driver's
locking "big picture" to check correctness.

In particular, is it safe to acquire priv->lock from inside
{iwl3945,iwlagn}_tx_queue_reclaim? Or can they be called on a path
where the that lock is already held?

-- Nathaniel
