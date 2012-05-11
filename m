Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33857 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759925Ab2EKQxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 12:53:24 -0400
Received: by qcro28 with SMTP id o28so2148666qcr.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2012 09:53:23 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1336665952-24363-5-git-send-email-johannes@sipsolutions.net>
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
	<1336665952-24363-5-git-send-email-johannes@sipsolutions.net>
Date: Fri, 11 May 2012 18:53:23 +0200
Message-ID: <CA+icZUUuuwT6MP=nyuP1wnY4iGdwFACBTwtCbvURS=U8ctEtEg@mail.gmail.com> (sfid-20120511_185327_654387_5F47D475)
Subject: Re: [PATCH 4/4] iwlwifi: do not send lq cmd when station add fails
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2012 at 6:05 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
>
> When adding a station fails in
> iwl_restore_stations, the driver treats it
> like a successful station add and sends a
> link quality command, when it it shouldn't.
>
> This patch fixes one of the potential
> sources for kernel warnings like this one:
>
> WARNING: at drivers/net/wireless/iwlwifi/iwl-agn-sta.c:905 iwl_send_lq_cmd+0x130/0x217 [iwlwifi]()
> Hardware name: 3323A2G
> Modules linked in: ...
> Pid: 17359, comm: kworker/u:2 Tainted: G           O 3.3.0-wl+ #1
> Call Trace:
>  [<ffffffff81039620>] warn_slowpath_common+0x7e/0x96
>  [<ffffffff8103964d>] warn_slowpath_null+0x15/0x17
>  [<ffffffffa02a9f0b>] iwl_send_lq_cmd+0x130/0x217 [iwlwifi]
>  [<ffffffffa02aa1fb>] iwl_restore_stations+0x209/0x289 [iwlwifi]
>  [<ffffffffa02b07c2>] iwlagn_commit_rxon+0x602/0x7bd [iwlwifi]
>  [<ffffffffa02b111f>] iwlagn_bss_info_changed+0x247/0x31a [iwlwifi]
>  [<ffffffffa0861437>] ieee80211_bss_info_change_notify+0x1a5/0x1ba [mac80211]
>  [<ffffffffa088afad>] ieee80211_destroy_auth_data+0x4b/0x70 [mac80211]
>  [<ffffffffa088df26>] ieee80211_sta_work+0xb5/0x954 [mac80211]
>
> Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
> Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
