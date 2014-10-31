Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:10455 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934AbaJaOSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 10:18:30 -0400
Message-ID: <54539A33.6000001@broadcom.com> (sfid-20141031_151833_290838_F7682806)
Date: Fri, 31 Oct 2014 15:18:27 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-wireless@vger.kernel.org>, <brcm80211-dev-list@broadcom.com>
Subject: Re: brcm80211: use endian annotation for pmk related structure
References: <20141031125136.GA17467@mwanda>
In-Reply-To: <20141031125136.GA17467@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/14 13:51, Dan Carpenter wrote:
> Hello Arend van Spriel,
>
> The patch 40c8e95af02d: "brcm80211: use endian annotation for pmk
> related structure" from Oct 12, 2011, leads to the following static
> checker warning:
>
> 	drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c:2965 brcmf_cfg80211_set_pmksa()
> 	warn: can 'pmkid_len' be negative?
>
> drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
>    2950  brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
>    2951                           struct cfg80211_pmksa *pmksa)
>    2952  {
>    2953          struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
>    2954          struct brcmf_if *ifp = netdev_priv(ndev);
>    2955          struct pmkid_list *pmkids =&cfg->pmk_list->pmkids;
>    2956          s32 err = 0;
>    2957          int i;
>    2958          int pmkid_len;
>    2959
>    2960          brcmf_dbg(TRACE, "Enter\n");
>    2961          if (!check_vif_up(ifp->vif))
>    2962                  return -EIO;
>    2963
>    2964          pmkid_len = le32_to_cpu(pmkids->npmkid);
>
> The thinking behind this check is that endian data is less trust worthy
> than cpu data.  But probably this comes from the hardware so it's fine?
>
> Anyway, let's assume pmkid_len = -1.
>
>    2965          for (i = 0; i<  pmkid_len; i++)
>    2966                  if (!memcmp(pmksa->bssid, pmkids->pmkid[i].BSSID, ETH_ALEN))
>    2967                          break;
>
> We don't enter this loop.
>
>    2968          if (i<  WL_NUM_PMKIDS_MAX) {
>
> Zero is less than WL_NUM_PMKIDS_MAX.
>
>    2969                  memcpy(pmkids->pmkid[i].BSSID, pmksa->bssid, ETH_ALEN);
>    2970                  memcpy(pmkids->pmkid[i].PMKID, pmksa->pmkid, WLAN_PMKID_LEN);
>    2971                  if (i == pmkid_len) {
>                              ^^^^^^^^^^^^^^
> This is false.
>
>    2972                          pmkid_len++;
>    2973                          pmkids->npmkid = cpu_to_le32(pmkid_len);
>    2974                  }
>    2975          } else
>    2976                  err = -EINVAL;
>    2977
>    2978          brcmf_dbg(CONN, "set_pmksa,IW_PMKSA_ADD - PMKID: %pM =\n",
>    2979                    pmkids->pmkid[pmkid_len].BSSID);
>                            ^^^^^^^^^^^^^^^^^^^^^^^
> Underflow.
>
>    2980          for (i = 0; i<  WLAN_PMKID_LEN; i++)
>    2981                  brcmf_dbg(CONN, "%02x\n", pmkids->pmkid[pmkid_len].PMKID[i]);
>                                                    ^^^^^^^^^^^^^^^^^^^^^^^^
> Underflow.
>
>    2982
>    2983          err = brcmf_update_pmklist(ndev, cfg->pmk_list, err);
>    2984
>    2985          brcmf_dbg(TRACE, "Exit\n");
>    2986          return err;
>    2987  }

Hi Dan,

Understood. Not sure what the motivation is to mistrust endian more. 
Simply because there could be conversion errors? Anyway, the main 
question is whether pmkid_len is always between 0 and WLAN_PMKID_LEN. As 
far as I know it is. We could 1) add additional checks here, 2) make 
pmkid_len of u32 type, or 3) just mention the (sure) assumption in a 
comment. I would prefer option 2) or 3).

Regards,
Arend
