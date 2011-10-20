Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32844 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1JTTR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 15:17:29 -0400
Received: by qabj40 with SMTP id j40so2449207qab.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 12:17:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319135679-6740-1-git-send-email-thomas@cozybit.com>
References: <1319135679-6740-1-git-send-email-thomas@cozybit.com>
Date: Thu, 20 Oct 2011 14:17:28 -0500
Message-ID: <CAP7cwtsB0jckz_WVFJuibKiewuOQZ_BMHTHBDfCTMNt_ge9buw@mail.gmail.com> (sfid-20111020_211733_441908_CA487AC0)
Subject: Re: [PATCH v2 0/6] HT support for mesh
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

how does this relate to Alex HT patches? Alex's patch addresses IBSS
but there seems to be some overlaps between Mesh/IBSS HT patches.
thanks,

On Thu, Oct 20, 2011 at 1:34 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
> This patchset adds basic HT support for mesh nodes. We avoid the question of
> how to negotiate channel types, by simply disallowing peering with mismatched
> HT modes. Needs the mesh fixes posted earlier today for patch context.
>
> Many thanks to Luis Rodriguez for his assistance, and Ashok Nagarajan for
> co-authoring this patchset.
>
> v2:
>        Remove outdated BA comments (Christian)
>
> Alexander Simon (1):
>  mac80211: Add HT helper functions
>
> Thomas Pedersen (5):
>  mac80211: add HT IEs to mesh frames
>  mac80211: set HT capabilities for mesh peer
>  mac80211: allow frame aggregation for mesh
>  mac80211: add WMM IE to mesh frames
>  mac80211: check mesh peer's WMM parameters
>
>  include/linux/ieee80211.h  |   26 ++++++
>  include/net/mac80211.h     |    4 +
>  net/mac80211/agg-rx.c      |    3 +-
>  net/mac80211/agg-tx.c      |   10 +--
>  net/mac80211/ht.c          |    3 +-
>  net/mac80211/ieee80211_i.h |    8 ++
>  net/mac80211/mesh.c        |   75 ++++++++++++++--
>  net/mac80211/mesh.h        |    4 +
>  net/mac80211/mesh_plink.c  |   24 +++++-
>  net/mac80211/rx.c          |    7 +--
>  net/mac80211/tx.c          |    6 ++
>  net/mac80211/util.c        |  208 ++++++++++++++++++++++++++++++++++++++++----
>  net/mac80211/work.c        |   29 +------
>  13 files changed, 336 insertions(+), 71 deletions(-)
>
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
