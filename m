Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.eu2.fugro.com ([46.34.88.152]:35273 "EHLO
        smtp.eu2.fugro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbdAIJHh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 04:07:37 -0500
From: "Stam, Michel [FINT]" <m.stam@fugro.com>
To: Antonio Quartulli <a@unstable.cc>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Antonio Quartulli" <antonio@open-mesh.com>
Subject: RE: [ath9k-devel] [NOT FOR MERGE] ath9k: work around key cache
        corruption
Date: Mon, 9 Jan 2017 08:57:31 +0000
Message-ID: <c8cf3cb978484560befe95900095eff1@nldataex02.ad.fugro.com> (sfid-20170109_100741_740493_A4974F14)
References: <20161018083552.28592-1-a@unstable.cc>
 <20161022134222.GQ12558@prodigo.lan>
In-Reply-To: <20161022134222.GQ12558@prodigo.lan>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Antonio,

Actually, I fixed the usage of mac80211 internals in one of my patches by iterating through the mac80211 cache entries (there's a function for that). This did have some locking issues afaik, but it made the key cache corruption occur less frequently.

So it may solve a key cache corruption problem, but it does not completely solve the particular problem that we are experiencing. Hence, I cannot say whether this patch would do anything useful (no test situation here). Since it is not a complete solution, it may warrant further looking into.

Please also take a look here:
https://github.com/cozybit/authsae/issues/42


Kind regards,

Michel Stam

-----Original Message-----
From: ath9k-devel-bounces@lists.ath9k.org [mailto:ath9k-devel-bounces@lists.ath9k.org] On Behalf Of Antonio Quartulli
Sent: Saturday, October 22, 2016 15:42 PM
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org; Antonio Quartulli
Subject: Re: [ath9k-devel] [NOT FOR MERGE] ath9k: work around key cache corruption

Hello,

I am trying to understand what's required by this patch to be merged upstream.
Sven Eckelmann commented in another email by saying:

"The patch itself has (at least) one big problem. It is using some mac80211
internals in ath_key_config_iter to make sure that the uploaded keys were
actually programmed in the hardware. Without this check the keys could end up
in the lower slots and thus break all connections."


Does anybody else have any other additional comment?
(Please keep me in CC as I am not registered to the ath9k ML).

Cheers,

On Tue, Oct 18, 2016 at 04:35:52PM +0800, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> This patch was crafted long time ago to work around a key cache
> corruption problem on ath9k chipsets.
> 
> The workaround consists in periodically triggering a worker that
> uploads all the keys to the HW cache. The worker is triggered also
> when the vif detects 21 undecryptable packets.
> 
> 
> This patch is based on top compat-wireless-2015-10-26.
> 
> 
> I was asked to release this code to the public and, since it is
> GPL, I am now doing it.
> 
> 
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>

-- 
Antonio Quartulli
