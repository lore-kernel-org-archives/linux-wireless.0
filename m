Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:33566 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753246AbdDGKG5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 06:06:57 -0400
Received: by mail-qt0-f177.google.com with SMTP id i34so56911272qtc.0
        for <linux-wireless@vger.kernel.org>; Fri, 07 Apr 2017 03:06:57 -0700 (PDT)
Subject: Re: [PATCH 00/10] cfg80211: support multiple scheduled scans
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1491556990-25143-1-git-send-email-arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1b388cf3-4cb4-6652-f259-c729379a104d@broadcom.com> (sfid-20170407_120701_555570_B35191EE)
Date: Fri, 7 Apr 2017 12:06:52 +0200
MIME-Version: 1.0
In-Reply-To: <1491556990-25143-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7-4-2017 11:23, Arend van Spriel wrote:
> After the RFC rounds here is multi-scheduled scan submission. What
> has been added since the RFC is support for user-space to specify a
> BSSID in the matchset (PATCH 3/10). As example this could be used for
> roaming algorithm done in user-space. The patches for scheduled scan
> notification api have been collapsed into a single patch and rtnl
> locking was needed for the cfg80211_sched_scan_results() function.
> 
> This series also adds a driver implementation for the new features.
> Not surprisingly being brcmfmac.
> 
> This series applies to master branch of the mac80211-next
> repository. However, there is a patch pending for the
> wireless-drivers-next repository [1] that may give a merge
> conflict.
> 
> [1] https://patchwork.kernel.org/patch/9666945/

Hi Johannes, Kalle,

So in this patch the following hunk is removed:

@@ -3333,8 +3342,6 @@ static int brcmf_start_internal_escan(struct
brcmf_if *ifp,
 		goto out_err;
 	}

-	netinfo_start = brcmf_get_netinfo_array(pfn_result);
-
 	for (i = 0; i < result_count; i++) {
 		netinfo = &netinfo_start[i];
 		if (!netinfo) {

And in this series patch 8/10 adds the following:

@@ -3332,6 +3349,7 @@ static int brcmf_start_internal_escan(struct
brcmf_if *ifp,

 	netinfo_start = brcmf_get_netinfo_array(pfn_result);

+	bucket_map = 0;
 	for (i = 0; i < result_count; i++) {
 		netinfo = &netinfo_start[i];
 		if (!netinfo) {

So I guess that would cause a merge conflict, right?

Regards,
Arend

> Arend van Spriel (10):
>   nl80211: add request id in scheduled scan event messages
>   nl80211: allow multiple active scheduled scan requests
>   nl80211: add support for BSSIDs in scheduled scan matchsets
>   cfg80211: add request id parameter to .sched_scan_stop() signature
>   cfg80211: add request id to cfg80211_sched_scan_*() api
>   brcmfmac: add firmware feature detection for gscan feature
>   brcmfmac: move scheduled scan wiphy param setting to pno module
>   brcmfmac: add support multi-scheduled scan
>   brcmfmac: add mutex to protect pno requests
>   brcmfmac: add scheduled scan support for specified BSSIDs
> 
>  drivers/net/wireless/ath/ath6kl/cfg80211.c         |   6 +-
>  drivers/net/wireless/ath/ath6kl/wmi.c              |   2 +-
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  93 +++--
>  .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   8 +-
>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   1 +
>  .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |   2 +
>  .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  22 +-
>  .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   4 +-
>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  75 ++++
>  .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 460 ++++++++++++++++++---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/pno.h |  55 ++-
>  drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   2 +-
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  10 +-
>  drivers/net/wireless/marvell/mwifiex/main.c        |   2 +-
>  drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   2 +-
>  drivers/net/wireless/marvell/mwifiex/sta_event.c   |   2 +-
>  drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |   2 +-
>  drivers/net/wireless/ti/wlcore/main.c              |   2 +-
>  include/net/cfg80211.h                             |  40 +-
>  include/uapi/linux/nl80211.h                       |  14 +-
>  net/mac80211/cfg.c                                 |   3 +-
>  net/mac80211/pm.c                                  |   2 +-
>  net/mac80211/scan.c                                |   4 +-
>  net/mac80211/util.c                                |   2 +-
>  net/wireless/core.c                                |  27 +-
>  net/wireless/core.h                                |  11 +-
>  net/wireless/nl80211.c                             | 116 ++++--
>  net/wireless/nl80211.h                             |   3 +-
>  net/wireless/rdev-ops.h                            |   8 +-
>  net/wireless/scan.c                                | 146 +++++--
>  net/wireless/trace.h                               |  54 ++-
>  31 files changed, 945 insertions(+), 235 deletions(-)
> 
