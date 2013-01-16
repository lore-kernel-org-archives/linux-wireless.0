Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:51260 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759043Ab3APJto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 04:49:44 -0500
Received: by mail-la0-f46.google.com with SMTP id fq13so1131606lab.5
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2013 01:49:43 -0800 (PST)
Message-ID: <50F677B4.7040609@cozybit.com> (sfid-20130116_114554_819120_D972F8D6)
Date: Wed, 16 Jan 2013 10:49:40 +0100
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Subject: Re: [PATCHv2 0/6] mesh power save - basics
References: <1357571093-12868-1-git-send-email-marco@cozybit.com>
In-Reply-To: <1357571093-12868-1-git-send-email-marco@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I just checked back on the status of my patches and see no further 
comments while they are not applied yet. Is there anything odd about them?

Regards,
Marco


On 01/07/2013 04:04 PM, Marco Porsch wrote:
> Commits #5 and #6 cover the basic subset of functions, that each mesh node
> must support to communicate in the presence of power saving nodes.
> The current patchset does not implement any actual power savings yet (no
> hardware configuration, no doze state).
>
> Mesh powersave is different from client mode powersave in the sense that
> 1) there is not just a singular power mode towards the access point, but a
>     link-specific power mode towards each peer instead
> 2) peers also maintain a power mode towards us (the local STA)
> 3) each node has to buffer frames towards power saving neighbors
>
> changes since PATCHv1:
> - explicitly clear QoS control field in mps_qos_null_get
> - beautify FILL_IN_MESH_PARAM_IF_SET macro
>
> Marco Porsch (6):
>    nl80211: add range checks to mesh parameters
>    mac80211: update mesh peer link counter during userspace peering
>    mac80211: move add_tim to subfunction
>    {cfg,nl,mac}80211: set beacon interval and DTIM period on mesh join
>    {cfg,nl}80211: mesh power mode primitives and userspace access
>    mac80211: mesh power save basics
>
>   include/linux/ieee80211.h     |   17 ++
>   include/net/cfg80211.h        |   25 ++
>   include/uapi/linux/nl80211.h  |   47 +++
>   net/mac80211/Kconfig          |   11 +
>   net/mac80211/Makefile         |    3 +-
>   net/mac80211/cfg.c            |   54 +++-
>   net/mac80211/debug.h          |   10 +
>   net/mac80211/debugfs_netdev.c |    5 +
>   net/mac80211/debugfs_sta.c    |    5 +-
>   net/mac80211/ieee80211_i.h    |    7 +
>   net/mac80211/mesh.c           |   37 ++-
>   net/mac80211/mesh.h           |   35 ++-
>   net/mac80211/mesh_hwmp.c      |    7 +
>   net/mac80211/mesh_pathtbl.c   |    1 +
>   net/mac80211/mesh_plink.c     |   35 ++-
>   net/mac80211/mesh_ps.c        |  640 +++++++++++++++++++++++++++++++++++++++++
>   net/mac80211/rx.c             |    7 +
>   net/mac80211/sta_info.c       |   18 +-
>   net/mac80211/sta_info.h       |   17 ++
>   net/mac80211/status.c         |    5 +
>   net/mac80211/tx.c             |   81 ++++--
>   net/mac80211/util.c           |    4 +
>   net/mac80211/wme.c            |   13 +-
>   net/wireless/mesh.c           |    8 +
>   net/wireless/nl80211.c        |  137 ++++++---
>   25 files changed, 1137 insertions(+), 92 deletions(-)
>   create mode 100644 net/mac80211/mesh_ps.c
>

