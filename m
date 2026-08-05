Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BFC3F86F9;
	Wed,  5 Aug 2026 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785937800; cv=none; b=p7lli82A8RIb899frvhLvQgDmIL2f+wuCSzxkSz+YtrmudUA6XL9i3r5qI+A3kOvpVrAa62AlYO2/V2de+d/EQhhTgXalEDvie1VHjyib6yI2Nny0ZZdLmH5ig5iKtSnjdh9dm6XyFdqyNY6WbSfmpSwqwJyhMxisK3rMa1/Pvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785937800; c=relaxed/simple;
	bh=oYZA6O6ABqqtt+4Vxbq33FYmueYagyh9fNV/oC1cxH8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwf0qDVt0NMxj2/NtoId05Wn0rBUKZbZvWeKP2VvVjoNh41O8OI2nO/SZjVNV3UIfHU7NcltR7estffwvCv3cp24CQ3ND/Z06s85SMa0kNIr2qfOM4gbCJ6mlPwl+bnl7UPa2n6L2OJdFT+Pch83L1oxc241CcgMGCFyfaTuUEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=PRblGVt5; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="PRblGVt5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1785937798; x=1817473798;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oYZA6O6ABqqtt+4Vxbq33FYmueYagyh9fNV/oC1cxH8=;
  b=PRblGVt5yS0J6pJh2w/ZxID570af4HYresOF0EyLnrYPMXMNqSgLg5U2
   GO0x0f1pArRr1ca93NHBQHUG/IDTJmZ6nHWjkGSYpj1LtF3gk6eM4Y7oj
   iWkFGlj5LUnbis00u3tG5As0HV76RcCS7tr88dXHJwuwI6ldPB5t4Go+8
   k=;
X-CSE-ConnectionGUID: MrYkGO72TI2//qzcuDquqg==
X-CSE-MsgGUID: xHNBtmQMS+m78+I0OrnGfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="140786238"
X-IronPort-AV: E=Sophos;i="6.25,206,1779141600"; 
   d="scan'208";a="140786238"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE822.infineon.com) ([172.23.29.53])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 15:49:50 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 5 Aug
 2026 15:49:50 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 5 Aug 2026 15:49:48 +0200
Date: Wed, 5 Aug 2026 13:49:40 +0000
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: Shivesh <chanelshivesh@gmail.com>
CC: <arend.vanspriel@broadcom.com>, <linux-wireless@vger.kernel.org>,
	<brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>,
	<linux-kernel@vger.kernel.org>, <wlan-kernel-dev-list@infineon.com>
Subject: Re: [PATCH v4 4/8] wifi: brcmfmac: cfg80211: implement PMKID_V2 and
 fix brcmf_delay busy-wait
Message-ID: <anM_dGEcPO1kvxL9@ISCN5CG54722ST.infineon.com>
References: <20260731160646.3812-1-chanelshivesh@gmail.com>
 <20260731160646.3812-5-chanelshivesh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260731160646.3812-5-chanelshivesh@gmail.com>
X-ClientProxiedBy: MUCSE814.infineon.com (172.23.29.40) To
 MUCSE827.infineon.com (172.23.29.20)

On 07/31, Shivesh wrote:
> Two independent fixes:
> 
> 1. PMKID_V2 implementation
>    Firmware revision 12 introduced a versioned PMKID list (V2) with
>    FILS-specific fields: raw PMK material, SSID, and fils_cache_id.
>    The set/del/flush callbacks all contained "TODO: implement PMKID_V2"
>    placeholders and fell through to the V1 path, breaking FILS
>    fast-roaming on devices with V2-capable firmware.
> 
>    Add brcmf_pmksa_v2_op() which maintains a shadow brcmf_pmk_list_v2_le
>    in cfg80211_info and pushes the full updated list to firmware via the
>    pmkid_info iovar on every set/del/flush. The shadow counter is kept
>    in list->length between calls; the wire-format byte-length is
>    computed only at send time to avoid corrupting the shadow on the next
>    call. Dispatch V2 between the existing V3 and V1 paths.
> 
> 2. brcmf_delay() busy-wait
>    When ms < (1000/HZ), brcmf_delay() called mdelay(), which is a
>    CPU busy-wait loop. Since the function is always called in a
>    sleepable context (it falls back to msleep() for larger values),
>    the busy-wait is unnecessary and wastes CPU cycles. Replace with
>    usleep_range() for values <= 20ms.
> 
> Signed-off-by: Shivesh <chanelshivesh@gmail.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 123 ++++++++++++++++--
>  .../broadcom/brcm80211/brcmfmac/cfg80211.h    |   4 +-
>  2 files changed, 115 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index 0b55d445895f..2375c2f9d97a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -3989,12 +3989,10 @@ static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
> 
>  static __always_inline void brcmf_delay(u32 ms)
>  {
> -       if (ms < 1000 / HZ) {
> -               cond_resched();
> -               mdelay(ms);
> -       } else {
> +       if (ms <= 20)
> +               usleep_range(ms * 1000, ms * 1000 + 1000);
> +       else
>                 msleep(ms);
> -       }
>  }
> 
>  static s32 brcmf_config_wowl_pattern(struct brcmf_if *ifp, u8 cmd[4],
> @@ -4364,6 +4362,109 @@ brcmf_pmksa_v3_op(struct brcmf_if *ifp, struct cfg80211_pmksa *pmksa,
>         return ret;
>  }
> 
> +/**
> + * brcmf_pmksa_v2_op - update firmware PMKSA cache using the V2 list interface.
> + *
> + * V2 firmware (revision 12) uses a versioned flat list structure
> + * (brcmf_pmk_list_v2_le) rather than the per-entry operation model of V3.
> + * Each entry carries FILS-specific fields (raw PMK material, SSID, and
> + * fils_cache_id) in addition to the basic BSSID + PMKID pair, enabling
> + * FILS fast-roaming on devices that do not support V3.
> + *
> + * @cfg:   driver config structure holding the shadow V2 PMKSA list
> + * @ifp:   interface pointer
> + * @pmksa: the PMKSA to add/remove, or NULL for a flush
> + * @alive: true = add (set time_left to no-expiry), false = remove/flush
> + */
> +static s32
> +brcmf_pmksa_v2_op(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
> +                 struct cfg80211_pmksa *pmksa, bool alive)
> +{
> +       struct brcmf_pub *drvr = cfg->pub;
> +       struct brcmf_pmk_list_v2_le *list = &cfg->pmk_list_v2;
> +       struct brcmf_pmksa_v2 *pmk = list->pmk;
> +       u32 npmk = le16_to_cpu(list->length);
> +       u32 i;
> +
> +       /* npmk here stores the count of valid entries, repurposing the
> +        * length field of the shadow list as a counter.  We convert to
> +        * the wire format (byte length) when sending to firmware.
> +        */
> +       if (!pmksa) {
> +               /* Flush: zero the shadow list and push an empty V2 list. */
> +               memset(list, 0, sizeof(*list));
> +               goto send;
> +       }
> +
> +       if (alive) {
> +               /* Set: search for existing BSSID match first. */
> +               for (i = 0; i < npmk; i++)
> +                       if (!memcmp(pmksa->bssid, pmk[i].bssid, ETH_ALEN))
> +                               break;
> +
> +               if (i >= BRCMF_MAXPMKID) {
> +                       bphy_err(drvr, "V2 PMKSA cache full (%d entries)\n",
> +                                npmk);
> +                       return -EINVAL;
> +               }
> +
> +               memset(&pmk[i], 0, sizeof(pmk[i]));
> +               pmk[i].length = cpu_to_le16(sizeof(struct brcmf_pmksa_v2));
> +               if (pmksa->bssid)
> +                       memcpy(pmk[i].bssid, pmksa->bssid, ETH_ALEN);
> +               if (pmksa->pmkid)
> +                       memcpy(pmk[i].pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
> +               if (pmksa->pmk && pmksa->pmk_len &&
> +                   pmksa->pmk_len <= WLAN_PMK_LEN_SUITE_B_192) {
> +                       memcpy(pmk[i].pmk, pmksa->pmk, pmksa->pmk_len);
> +                       pmk[i].pmk_len = cpu_to_le16(pmksa->pmk_len);
> +               }
> +               if (pmksa->ssid && pmksa->ssid_len) {
> +                       memcpy(pmk[i].ssid.SSID, pmksa->ssid, pmksa->ssid_len);
> +                       pmk[i].ssid.SSID_len = pmksa->ssid_len;
> +               }
> +               if (pmksa->fils_cache_id)

The struct cfg80211_pmksa defined in include/net/cfg80211.h kernel header does not
have this struct member "fils_cache_id", it does have a member "cache_id" though.

I doubt whether this patchset compiles successfully. It should be "pmksa->cache_id"
not "pmksa->fils_cache_id".

> +                       pmk[i].fils_cache_id = *pmksa->fils_cache_id;

Assuming, the member name is fixed in RHS. Here 2-bytes needs to be copied as per
endinannes, not just 1-byte, because "pmksa->cache_id" is a pointer for 2-bytes
and the LHS variable "pmk[i].fils_cache_id" is also two-bytes.

And RHS is a pointer, it is worth doing a NULL check before dereferencing for copy.

> +               if (i == npmk)
> +                       npmk++;
> +       } else {
> +               /* Delete: find by BSSID and compact the list. */
> +               for (i = 0; i < npmk; i++)

It is better to add a bounds check for "nmpk" with BRCMF_MAXPMKID at the beginning
of the funciton, since it is being directly used in loop condition inside the
function.

> +                       if (!memcmp(pmksa->bssid, pmk[i].bssid, ETH_ALEN))
> +                               break;
> +
> +               if (i >= npmk) {
> +                       bphy_err(drvr, "V2 PMKSA entry not found\n");
> +                       return -EINVAL;
> +               }
> +
> +               for (; i < npmk - 1; i++)
> +                       memcpy(&pmk[i], &pmk[i + 1], sizeof(pmk[i]));
> +               memset(&pmk[npmk - 1], 0, sizeof(pmk[npmk - 1]));
> +               npmk--;
> +       }
> +
> +       /* Write the updated entry count back to shadow BEFORE we overwrite
> +        * list->length with the wire-format byte length at send:.  If we
> +        * don't do this here, the next call will read a byte-length back
> +        * as an entry count and silently corrupt the list.
> +        */
> +       list->length = cpu_to_le16(npmk);

As mentioned in the comment at the beginning of the function, here first the
"list->length" member is stored with function entry counter "npmk"...

> +send:
> +       /* Build the wire-format byte length and send the full list to firmware.
> +        * Read npmk back from the shadow (handles the flush path where npmk=0).
> +        */
> +       npmk = le16_to_cpu(list->length);
> +       list->version = cpu_to_le16(BRCMF_PMKSA_VER_2);
> +       list->length  = cpu_to_le16(offsetof(struct brcmf_pmk_list_v2_le, pmk) +
> +                                  npmk * sizeof(struct brcmf_pmksa_v2));

and then set with wire-format byte length before calling brcmf_fil_iovar_data_set().

> +       return brcmf_fil_iovar_data_set(ifp, "pmkid_info", list, sizeof(*list));

But after setting the IOVAR, "list->length" member is never restored back with the
the entry count. So in all the subsequent function calls, it reads that byte length
value back as the function entry count, corrupting the shadow list. This is exactly
the issue that a above mentioned comment claims it is addressing, but actually not.

It would be way more simpler to use "list->length" only as a wire-format byte length,
and have a dedicated entry counter variable outside the function scope.

> +}
> +
> +
>  static __used s32
>  brcmf_update_pmklist(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp)
>  {
> @@ -4402,8 +4503,8 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
> 
>         if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V3))
>                 return brcmf_pmksa_v3_op(ifp, pmksa, true);
> -
> -       /* TODO: implement PMKID_V2 */
> +       if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V2))
> +               return brcmf_pmksa_v2_op(cfg, ifp, pmksa, true);
>
>         npmk = le32_to_cpu(cfg->pmk_list.npmk);
>         for (i = 0; i < npmk; i++)
> @@ -4446,8 +4547,8 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
> 
>         if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V3))
>                 return brcmf_pmksa_v3_op(ifp, pmksa, false);
> -
> -       /* TODO: implement PMKID_V2 */
> +       if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V2))
> +               return brcmf_pmksa_v2_op(cfg, ifp, pmksa, false);
> 
>         npmk = le32_to_cpu(cfg->pmk_list.npmk);
>         for (i = 0; i < npmk; i++)
> @@ -4487,8 +4588,8 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
> 
>         if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V3))
>                 return brcmf_pmksa_v3_op(ifp, NULL, false);
> -
> -       /* TODO: implement PMKID_V2 */
> +       if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PMKID_V2))
> +               return brcmf_pmksa_v2_op(cfg, ifp, NULL, false);
> 

The new PMKID V2 flow is trying to follow the existing PMKID V3 flow which currently
has an incorrect assumption about the Firwmare vendor support. These vendor specific
PMKID V3 and V2 operations are exercised here based on the BRCM_FEAT override flags.
But the BRCMF_FEAT_PMKID_{V3/V2} flags are infact currently set in driver only based
on "wlc_ver" IOVAR major, minor numbers queried from firmware irrespective of FWVID.

It would be more appropriate to set these BRCMF_FEAT_PMKID_{V3/v2} flags only for the
respective Firmware vendors based on the FWVID. Else, there are more chances for these
firmware "wlc_ver" major minors numbers to overlap across different firmware vendors,
leading to incorrect BRCMF_FEAT flag overrides. And driver would end up doing invalid
operations on a firmware from a different vendor.

Regards,
Gokul
