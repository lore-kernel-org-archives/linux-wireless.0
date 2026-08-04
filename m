Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0782D3E92A5
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 01:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785808474; cv=none; b=kn05Om4Z+5uP0nIcA+9MRpJkMEfnRniYETinqI/8yzlaGzLf5so5+DQLHYXG9UIkyKEaGOoQdxsKMjGBxfr5CMOEQSl//uV6A4gACPY7UfLZKND+CNhGOJYCSGDD14soB1qRg4HH7WlQ5cDMv6dwy7M6GK2Js9msj/X3O0AahZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785808474; c=relaxed/simple;
	bh=Idn1ASSDik/BWcPOLKXUiFGllsVH+/LJEH76WUGVg8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iT4RlwaFbZUQzgF89bfpq925NnWzniS951XHZfURdYSRyXFSlaAohCQJ3d813e29aybMrky7Hcd6FHYIIUhb2G7g9nBCL8Mc0pygsgy4EvjdYv7UhJEa4AtrLQ9+okljkKiE89NZTwqeIVRvJ4jYZcYeL8XpWuDNn99X57qV9Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ii5AY+6+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=G2yimf7T; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ii5AY+6+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="G2yimf7T"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67418GXc2591537
	for <linux-wireless@vger.kernel.org>; Tue, 4 Aug 2026 01:54:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LUEy0cjUlzfhynWbUMKECXl1y7KPhgauLKPMLM6KqrU=; b=Ii5AY+6+kRWqoKal
	H/U5WlppEhtnMQ5hjI27ls/r0sZUs7LPNMR9AVQr03kl/Qy6OTY6paignb4YGZTl
	O34fg1/Elc19rZBV0HCjvuNNVoxOME4kJQhWhXuyCTcNeg0T99ztKhsmA3cUe7HT
	YIR8XIg4ZOt8iE+1omVXVqskL1Az6aKpRNHj5U3JuplcndSufyAGqEfEX5jRi2+u
	5g50yD8n3jiaWZMBY7E50SY9WRpEba1+aI2/gNxRndG43tmDieRtfF6+es66Fwl+
	WzH0yyhJ4J/rZW9z2lyacEhxi7K8g8z5PZkhFScWhLYAGVZWtS0yNubLXASLbklr
	bFhWMQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fu3vs0jas-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 01:54:30 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-84a251c2e3eso614218b3a.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 18:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785808470; x=1786413270; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LUEy0cjUlzfhynWbUMKECXl1y7KPhgauLKPMLM6KqrU=;
        b=G2yimf7TpULbW/lKBLFO2/P6YSn8oqzs6i/om+UI5sL3tt1V8U4saK6R/bHYxqQjsA
         GtRRsJCUr/3v2L4N+kxgP/cZjrGQNm9W6MxLEJfZpAZrLS148J591luOPZmTTfP+DU9K
         HIttuMe3FGyKDdeQYC3AxOxWUGQgw/f9WuoCyqKudWZxsaypsMgUbKiRrUs44fwcsUsx
         Tc+Zk3GFMjkhUU87dN4itWz91Maq+2VfVWbg4wMurP8togR7hWSYnDzBlSwf7/TSQvoI
         Uv2XFuwhB7C6d0SwPZzp78o+LDgTbTfQLJvliuK4IXMpGzzoHcKWh94CKTEF+H+dCdQk
         n6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785808470; x=1786413270;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LUEy0cjUlzfhynWbUMKECXl1y7KPhgauLKPMLM6KqrU=;
        b=Hth4WheBQ34yv/7D9QzVh+Hrd7Omfgx1z75vwTZ+I+AzjQt1ttQzrhF2wfU3om7OCM
         O6x16nAk8aivwSLM86xr4uO6nOvkBrvIZIKm8EfTUG9oGdb/iQe6ljKjkHmvOD+cjej5
         oFBImfzR4Yfn76XgUjplX8pgoCzpDMLAdlSeDqjdhDLFkoysvbq6AZRHTKCmothWIi7a
         k3/Uy9KHo49DMGKowma1k2BZiKWNY9W7sQgXlA+dffgT6FRbw6X7cHJxXqA2RD3Z8tel
         GjAdD0e1/zT+yIGO6kgvhWTWpF/jZEX+I4/x3SgLSLqZ5EPaAKxI/4kBOFLSzdKe1tFC
         Yt5g==
X-Forwarded-Encrypted: i=1; AHgh+RoKj4NgB/GWnkwXlXHUknbUGBONrgBo/jVsPJUbTiQU79sx7VMxrLxyal211biKXvAZ8HSkCQcwV/8XhYew2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YydKR/PzXtOZkBhggBztb40DxhQGbecDqLxjQxU/fg387FM87rU
	Rtj0kABHa5Jf5mIVrjAiw01LfI20TjO8VUTbkk53hbutlDaDk41aalbShufwqzRssTAE5EUh/+I
	lExNdYlqqJapdJ7HulCG4ShR1mcl0mfvxDqzysKhuSRnvsQ/Gp+Ye7NiebITpomFmgpLOLg==
X-Gm-Gg: AR+sD11mgPdnugcqhEEy/d9qCXXwu52wlH5aUhmZd7j7/+eNFJNCYU8COIUoJKZCUeY
	QSEc0dHQIrWOZYND9XNHEAURjwdVldwE1tPks24Lw1DiTni5UJcK7+OgqWbwP7D4q81Qb1w7xkU
	3Uyr0gdA/b6UcvNeeUj1DYfRDOymORdmkFz2GdnjREPreVgXviGAju3JWQoxI2CGJCS3oAALmni
	vVn3hWyq+mDET+TNPwuFY8YW5Dd1KNqStE2eCBc5TspwW4gLisTwM9qUqv3NLUIQpC8o5yXXwvH
	Nsfu2d8mzcsl0QJRHaD2DwmbmJZaeDh+dRyTIcSau7AgFWN52ZpeggWWc3hjFDWnJPbF/8iJEm4
	O1khGLlBWwqIt1z6L1KlwExmS8xsTooThItit3Kc8Ub1/gdT4e9fXOYxQ/TZl
X-Received: by 2002:a05:6a21:3946:b0:3c3:8315:80b6 with SMTP id adf61e73a8af0-3cb6ca55e77mr1849422637.32.1785808469436;
        Mon, 03 Aug 2026 18:54:29 -0700 (PDT)
X-Received: by 2002:a05:6a21:3946:b0:3c3:8315:80b6 with SMTP id adf61e73a8af0-3cb6ca55e77mr1849393637.32.1785808468792;
        Mon, 03 Aug 2026 18:54:28 -0700 (PDT)
Received: from [192.168.1.20] (103.sub-97-215-187.myvzw.com. [97.215.187.103])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e1886e7sm48334237eec.26.2026.08.03.18.54.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 18:54:28 -0700 (PDT)
Message-ID: <734a86b7-ccfd-4742-8bd8-a23db7751f77@oss.qualcomm.com>
Date: Mon, 3 Aug 2026 18:54:26 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2 0/8] Adding NO_STA flag and reworking RX
 link resolution
To: Benjamin Berg <benjamin@sipsolutions.net>, linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
References: <20260803123004.281626-10-benjamin@sipsolutions.net>
Content-Language: en-US
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
In-Reply-To: <20260803123004.281626-10-benjamin@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDAxMiBTYWx0ZWRfX5lARHx0DdyUV
 QIsz+30WwX3ieBaEc/M5hQfUwRZj7eOQ6lZzxZIvEGT0qf8mEr+lebJlWLMVSr2kx1tOomloXtd
 ySKA+6TbsCxP4PGRjgLSziEAhIru7MDT10y+1WdGq4GlSiLYRvdpim4435pFExaJ2MvaAbbBk3h
 znYK8xHXZVugCvKu1Ar3Y4sf9sx5TI8yaFLAQeB9F+eItPZOlFYyXB77RBaoK/G6ACCWvH0V5+A
 LurPKkMhYZiMFV4At9RvXt7QXEx5ppeMYby1HRP/NXaXHwViJftQK3fMQNM/cR0E5XXMrHWMWLc
 9SftftcIVr7O5cAW+7EozYfMa7QiX32+//kmsFvJYGCXMIz2UR/LqPeVhGDEaLYRrUqIvm/XiXo
 aLIrk7S24cGGb+UHnTZ+boJ2OM8f4YB1YsxaBSWosCjHG2LJc+7+EnO4Xl1R2xyjCPd2FID+Wbd
 T1q1CMusbpaOUNhsSBA==
X-Proofpoint-ORIG-GUID: tvH3dp-iY1ep-4VgR-vGcZ9N6bUFnz59
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDAxMiBTYWx0ZWRfX5nhqSX4c6MEQ
 SRxwsYKdc/HpQVopXYDD9RfJWl6BkRO01jnGT0YbL8SRvqg3rAQ9fHYsmPdEVEp/FSzrvqUV4HL
 fldiZBvcalCyQIHXn0jSusjM7UFchSs=
X-Authority-Analysis: v=2.4 cv=EK82FVZC c=1 sm=1 tr=0 ts=6a714656 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=UaEkX0D7FlC0tWE/LoNF7Q==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=QyXUC8HyAAAA:8 a=AA_DFYPPtyhcjXPAZc8A:9 a=skAyjDnhcBd8wg6s:21
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: tvH3dp-iY1ep-4VgR-vGcZ9N6bUFnz59
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_01,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608040012

On 8/3/2026 5:30 AM, Benjamin Berg wrote:
> From: Benjamin Berg <benjamin.berg@intel.com>
> 
> Hi,
> 
> This patchset refactors the RX link resolution a bit to fix some issues
> where mac80211 might accept frames on the wrong link and incorrectly
> translate the address. It also adds a new NL80211_ATTR_FRAME_CMD_NO_STA
> flag so that userspace can know whether address translation was done by
> the kernel on RX and can also prevent address translation for management
> frames during TX.
> 
> This together should be enough to fix the existing issues in hostapd
> where stations that are still associated try to authenticate again but
> hostapd for example ends up sending the frame to an old link address.
> 
> Benjamin
> 
> v2:
>  * Remove unused variable in rtw89
> 
> Changes in v1:
>  * Add NAN_DATA interface handling
>  * Handle NO_STA flag correctly for NAN
>  * Fixed forwarding of station parameter
>  * Rebase and other small fixes
> 
> Changes in RFCv2:
>  * Port other drivers to new API (untested)
>  * Fix a checkpatch warning
> 
> Benjamin Berg (8):
>   wifi: iwlwifi: use link_sta internally to the driver
>   wifi: mac80211: change public RX API to use link stations
>   wifi: mac80211: refactor RX link_id and station handling
>   wifi: mac80211: rework RX packet handling
>   wifi: cfg80211: add attribute for TX/RX denoting there is no station
>   wifi: mac80211: report to cfg80211 when no STA is known for a frame
>   wifi: mac80211: pass station to ieee80211_tx_skb_tid
>   wifi: mac80211: pass error station if non-STA transmit was requested
> 
>  drivers/net/wireless/ath/ath11k/dp_rx.c       |   2 +-
>  drivers/net/wireless/ath/ath12k/dp_mon.c      |   2 -
>  drivers/net/wireless/ath/ath12k/dp_rx.c       |  20 +-
>  drivers/net/wireless/ath/ath12k/hw.h          |  20 +-
>  drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c |  20 +-
>  drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h |  12 +-
>  drivers/net/wireless/ath/ath12k/wifi7/hw.c    |   6 +-
>  drivers/net/wireless/ath/ath12k/wmi.c         |   6 -
>  drivers/net/wireless/intel/iwlwifi/mld/agg.c  |  17 +-
>  drivers/net/wireless/intel/iwlwifi/mld/agg.h  |   4 +-
>  drivers/net/wireless/intel/iwlwifi/mld/rx.c   |  50 +-
>  drivers/net/wireless/intel/iwlwifi/mld/rx.h   |   2 +-
>  .../wireless/intel/iwlwifi/mld/tests/agg.c    |   7 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |   2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |   6 +-
>  drivers/net/wireless/mediatek/mt76/mac80211.c |  22 +-
>  drivers/net/wireless/realtek/rtw89/core.c     |   7 -
>  .../wireless/virtual/mac80211_hwsim_main.c    |   3 -
>  include/net/cfg80211.h                        |   4 +
>  include/net/mac80211.h                        |  25 +-
>  include/uapi/linux/nl80211.h                  |   7 +
>  net/mac80211/agg-tx.c                         |   4 +-
>  net/mac80211/ap.c                             |   3 -
>  net/mac80211/ht.c                             |   2 +-
>  net/mac80211/ieee80211_i.h                    |  11 +-
>  net/mac80211/iface.c                          |   7 +-
>  net/mac80211/mlme.c                           |  10 +-
>  net/mac80211/offchannel.c                     |  13 +-
>  net/mac80211/rx.c                             | 447 ++++++++++--------
>  net/mac80211/scan.c                           |  10 +-
>  net/mac80211/tdls.c                           |   2 +-
>  net/mac80211/tx.c                             |  10 +-
>  net/wireless/nl80211.c                        |   8 +-
>  33 files changed, 413 insertions(+), 358 deletions(-)
> 

My review agent had some comments. Since it is late in my day I'm just going
to throw them over the fence so you can look at them.

In my workflow I have one agent perform a code review and then have another
agent try to refute the findings. I'm passing on the ones that were confirmed
(not refuted).


  Bug 1 — Patch 2/8 — drivers/net/wireless/ath/ath12k/dp_rx.c (OOB + skipped
  link 0)

  Confirmed in git show c95532877bc5. The call site does:
  u8 link_id = ath12k_hw_get_rx_link_id(dp->hw_params, peer, rxcb, status);
  if (link_id > 0)
      link_pubsta = rcu_dereference(pubsta->link[link_id]);

  ath12k_hw_get_rx_link_id() is declared int in hw.h and returns -1 on no-ops.
  Storing -1 into u8 gives 255. The guard 255 > 0 is true, causing
  pubsta->link[255] — an out-of-bounds access (ieee80211_sta.link[] is
  IEEE80211_MLD_MAX_NUM_LINKS wide). Additionally > 0 drops the valid link-0
  case.

  Fix:
  int link_id = ath12k_hw_get_rx_link_id(...);
  if (link_id >= 0)
      link_pubsta = rcu_dereference(pubsta->link[link_id]);

  ---
  Bug 2 — Patch 3/8 — net/mac80211/rx.c, ieee80211_rx_data_set_sta() (negative
  array index)

  Confirmed in git show 004192addab3. Inside the link_id < 0 branch:
  if (ieee80211_vif_is_mld(&rx->sdata->vif) && sta && !sta->sta.valid_links) {
      rx->link = rcu_dereference(rx->sdata->link[sta->deflink.link_id]);
      rx->link_sta = rcu_dereference(rx->sta->link[link_id]);  /* BUG: link_id
  is negative */
  }

  link_id < 0 (typically -1) used to index a fixed-size array is undefined
  behaviour / memory corruption. The non-MLO station intent is clearly to use
  the deflink.

  Fix:
  rx->link_sta = &sta->deflink;

  ---
  Bug 3 — Patch 8/8 — net/mac80211/offchannel.c, ieee80211_mgmt_tx() (inverted
  ternary)

  Confirmed in git show 022fe418cbd0. sta is initialised to NULL at function
  entry. When params->no_sta=true, the if (!params->no_sta) block is skipped, so
  sta is still NULL at the ieee80211_tx_skb_tid call:

  ieee80211_tx_skb_tid(sdata, skb,
                       params->no_sta ? sta : ERR_PTR(-ENOENT),
                       7, link_id);

  - no_sta=true → passes NULL (which means "do station lookup") — wrong
  - no_sta=false → passes ERR_PTR(-ENOENT) (which means "suppress lookup") —
  wrong

  Fix:
  ieee80211_tx_skb_tid(sdata, skb,
                       params->no_sta ? ERR_PTR(-ENOENT) : NULL,
                       7, link_id);


The full set of comments from the first agent follows:

## Per-Patch Analysis

### Patch 1/8 — wifi: iwlwifi: use link_sta internally
**Verdict: Reviewed-by, no issues**

Clean mechanical refactor converting `ieee80211_sta *sta` →
`ieee80211_link_sta *link_sta` inside the iwlwifi/mld driver. The
`link_sta->link_id` replacement for `rx_status->link_id` in
`iwl_mld_rx_mgmt_prot` is strictly better — it removes the fallback-to-zero
path when `link_valid` was false. KUnit test update (`&sta->deflink`) is correct.

---

### Patch 2/8 — wifi: mac80211: change public RX API to use link stations
**Verdict: NEEDS FIX — two bugs in ath12k**

The API change itself is well-designed. The FIXME emulation block is
acceptable as a transitional measure. However, the ath12k `dp_rx.c` adaptation
has a pair of related bugs:

**Bug 1: Type mismatch causes out-of-bounds array access**

```c
/* ath12k/dp_rx.c, ath12k_dp_rx_deliver_msdu() */
u8 link_id =
    ath12k_hw_get_rx_link_id(dp->hw_params, peer, rxcb, status);

if (link_id > 0)
    link_pubsta = rcu_dereference(pubsta->link[link_id]);
```

`ath12k_hw_get_rx_link_id()` returns `int` with `-1` as the failure sentinel.
Storing that into `u8` gives `255` (wrap). The check `255 > 0` is true, so the
code then dereferences `pubsta->link[255]` — a massive out-of-bounds access.
`ieee80211_sta.link[]` is only `IEEE80211_MLD_MAX_NUM_LINKS` entries wide.

**Bug 2: Valid link ID 0 is silently dropped**

MLO link IDs start at 0. The check `> 0` skips link 0, leaving `link_pubsta`
as NULL for a valid link-0 frame. It should be `>= 0`.

**Fix:**
```c
int link_id =
    ath12k_hw_get_rx_link_id(dp->hw_params, peer, rxcb, status);

if (link_id >= 0)
    link_pubsta = rcu_dereference(pubsta->link[link_id]);
```

The `wifi7/dp_rx.c` `get_link_id_*` implementations returning `int` are
correct. The bug is purely at the call site.

---

### Patch 3/8 — wifi: mac80211: refactor RX link_id and station handling
**Verdict: NEEDS FIX — negative array index**

The removal of `link_valid` and making `link_id` mac80211-internal is the
right direction. Most of the changes are clean. However, there is a negative
array index bug introduced in `ieee80211_rx_data_set_sta()`:

```c
if (link_id < 0) {
    if (ieee80211_vif_is_mld(&rx->sdata->vif) &&
        sta && !sta->sta.valid_links) {
        rx->link =
            rcu_dereference(rx->sdata->link[sta->deflink.link_id]);
        rx->link_sta = rcu_dereference(rx->sta->link[link_id]);  /* BUG */
    } else {
        rx->link = &rx->sdata->deflink;
    }
}
```

`link_id < 0` (e.g., `-1`) and `rx->sta->link` is a fixed-size array. Indexing
with a negative value is undefined behaviour and will corrupt memory or crash.
The intent here is clearly to set `link_sta` for a non-MLO station
(`!sta->sta.valid_links`), so the fix is:

```c
rx->link_sta = &sta->deflink;
```

or equivalently `rcu_dereference(rx->sta->link[sta->deflink.link_id])`.

Other changes in this patch worth noting:

- `scan.c`: Removing the `link_valid` guard and using `rx_status->link_id`
unconditionally is valid because by the time scan processing is invoked,
mac80211's internal rx path has already written `link_id` into the status.
- `iface.c` / `mlme.c`: Same reasoning applies — safe after patch 4 guarantees
`link_id` is always set.
- `ieee80211_rx_is_valid_sta_link_id()` fix for non-MLO stations is correct.

---

### Patch 4/8 — wifi: mac80211: rework RX packet handling
**Verdict: Reviewed-by, minor observation**

This is the most complex patch. The rewrite of
`__ieee80211_rx_handle_packet()` is well-structured. The new `rx_data_pending`
pattern correctly replaces the `prev` pointer approach with clearer semantics.
The separation of data frames (addressed to known stations) from management
frames (interface iteration) is cleaner.

The new `ieee80211_rx_data_set_link_sta()` helper is a clean abstraction; the
WARN_ON_ONCE guard and early return on missing `link` are appropriate.

One observation on the MLD "no station" fallback:

```c
if (!found)
    link = &sdata->deflink;  /* fallback if no freq match */
```

When no link matches the received frequency on an MLD VIF, the frame is still
delivered on deflink. For an AP use case where we're receiving a probe request
on a frequency not matching any active link, this silently misattributes the
frame. A FIXME comment here would be appropriate, or dropping the frame may be
more correct. The existing FIXME comment in `ieee80211_rx_for_interface` from
patch 3 suggests the author is aware of incomplete corner cases.

The `WARN_ON_ONCE(!local->emulate_chanctx && !status->freq)` strictness is
intentional and necessary — drivers that don't populate `status->freq` for
management frames will need fixing.

---

### Patch 5/8 — wifi: cfg80211: add attribute for TX/RX denoting there is no
station
**Verdict: Reviewed-by, no issues**

Minimal and clean. `NL80211_ATTR_FRAME_CMD_NO_STA` is correctly added as
`NLA_FLAG`, added to the policy table, extracted in `nl80211_tx_mgmt`, and
included in `nl80211_send_mgmt`. The dual-use (RX: "no STA found"
notification; TX: "don't use STA for address translation") is well-explained
in the kdoc.

---

### Patch 6/8 — wifi: mac80211: report to cfg80211 when no STA is known for a
frame
**Verdict: Reviewed-by, no issues**

One-liner, correct. `.no_sta = !rx->sta` accurately conveys whether mac80211
resolved a station for the frame.

---

### Patch 7/8 — wifi: mac80211: pass station to ieee80211_tx_skb_tid
**Verdict: Reviewed-by, no issues**

The three-value encoding (`NULL` = old lookup, `ERR_PTR(-ENOENT)` = suppress
lookup, valid pointer = use directly) is a clear and established kernel
pattern. Using `ERR_PTR(-ENOENT)` in `ieee80211_tx_skb_tid_band` for
off-channel TX is correct — no station resolution is needed there. The TDLS
change passing the actual `sta` is the right specific behavior.

---

### Patch 8/8 — wifi: mac80211: pass error station if non-STA transmit was
requested
**Verdict: NEEDS FIX — condition is inverted**

The intent per the commit message is: "when cfg80211 requested transmit
without a station, pass an **error station** to ieee80211_tx_skb_tid."
`ERR_PTR(-ENOENT)` = error station = suppress station lookup.

However, the actual code is:

```c
/* net/mac80211/offchannel.c */
ieee80211_tx_skb_tid(sdata, skb,
                     params->no_sta ? sta : ERR_PTR(-ENOENT),
                     7, link_id);
```

At this point, when `no_sta=true`, the earlier guard:
```c
if (!params->no_sta) {
    sta = sta_info_get_bss(sdata, mgmt->da);
    mlo_sta = sta && sta->sta.mlo;
}
```
means `sta` is `NULL`. So:
- `no_sta=true` → passes `NULL` → triggers **station lookup** inside
`ieee80211_xmit` — the opposite of the intent
- `no_sta=false` → passes `ERR_PTR(-ENOENT)` → **suppresses station lookup**
for all normal management TX — also wrong

The ternary is inverted. The fix:
```c
ieee80211_tx_skb_tid(sdata, skb,
                     params->no_sta ? ERR_PTR(-ENOENT) : NULL,
                     7, link_id);
```


