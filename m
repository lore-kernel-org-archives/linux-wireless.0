Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59710 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLPLKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2014 06:10:18 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so17170289wgh.31
        for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2014 03:10:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418719980-19753-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1418719980-19753-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Tue, 16 Dec 2014 19:10:16 +0800
Message-ID: <CAEFj986SVguSMp=oQ3aNKAv+nZkcYiVSiPupLj8Y6=57YVrSmQ@mail.gmail.com> (sfid-20141216_121023_354221_2EE1CB95)
Subject: Re: [PATCH 1/2] ath10k: fix low TX rates when IBSS and HT
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Janusz

I have applied the three patches and tested with firmware
999.999.0.636 but not working.

Any advice what's wrong?

---
ChunYeow

Some of my dmesg:
[  640.450000] ath10k_pci 0000:00:00.0: wmi pdev set param 3 value 34
[  640.450000] ath10k_pci 0000:00:00.0: wmi pdev set param 4 value 34
[  640.450000] ath10k_pci 0000:00:00.0: wmi pdev set wmm params
[  640.450000] ath10k_pci 0000:00:00.0: wmi pdev set wmm params
[  640.450000] ath10k_pci 0000:00:00.0: wmi pdev set wmm params
[  640.450000] ath10k_pci 0000:00:00.0: wmi pdev set wmm params
[  640.450000] ath10k_pci 0000:00:00.0: wmi peer create vdev_id 0
peer_addr 04:f0:21:0c:a5:1c
[  640.450000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 16 value 0
[  640.450000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 3 value 100
[  640.450000] ath10k_pci 0000:00:00.0: mac vdev 0 beacon_interval 100
[  640.450000] ath10k_pci 0000:00:00.0: vdev 0 set beacon tx mode to staggered
[  640.450000] ath10k_pci 0000:00:00.0: wmi pdev set param 7 value 0
[  640.450000] ath10k_pci 0000:00:00.0: mac vdev 0 start center_freq
5180 phymode 11na-ht20
[  640.450000] ath10k_pci 0000:00:00.0: wmi vdev start id 0x0 flags:
0x0, freq 5180, mode 4, ch_flags: 0x4000000, max_power: 34
[  640.460000] ath10k_pci 0000:00:00.0: WMI_VDEV_START_RESP_EVENTID
[  640.460000] ath10k_pci 0000:00:00.0: wmi mgmt vdev up id 0x0 assoc
id 0 bssid 52:8d:75:e5:00:52
[  640.460000] ath10k_pci 0000:00:00.0: mac vdev 0 up
[  640.460000] ath10k_pci 0000:00:00.0: mac vdev 0 cts_prot 0
[  640.460000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 44 value 0
[  640.460000] ath10k_pci 0000:00:00.0: WMI_TBTTOFFSET_UPDATE_EVENTID
[  640.460000] ath10k_pci 0000:00:00.0: mac vdev 0 slot_time 2
[  640.460000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 7 value 2
[  640.460000] ath10k_pci 0000:00:00.0: mac vdev 0 preamble 1n
[  640.460000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 8 value 1
[  640.460000] ath10k_pci 0000:00:00.0: mac vdev 0 peer create
04:f0:21:0c:a5:43 (new sta) sta 1 / 16 peer 2 / 24
[  640.460000] ath10k_pci 0000:00:00.0: wmi peer create vdev_id 0
peer_addr 04:f0:21:0c:a5:43
[  640.460000] IPv6: ADDRCONF(NETDEV_CHANGE): mesh0: link becomes ready
[  640.470000] ath10k_pci 0000:00:00.0: mac sta 04:f0:21:0c:a5:43 associated
[  640.470000] ath10k_pci 0000:00:00.0: mac peer 04:f0:21:0c:a5:43 qos 0
[  640.470000] ath10k_pci 0000:00:00.0: mac peer 04:f0:21:0c:a5:43 phymode 11a
[  640.470000] ath10k_pci 0000:00:00.0: wmi peer assoc vdev 0 addr
04:f0:21:0c:a5:43 (new)
[  640.470000] ath10k_pci 0000:00:00.0: wmi vdev 0 peer
0x04:f0:21:0c:a5:43 set param 5 value 1
[  640.470000] ath10k_pci 0000:00:00.0: wmi vdev id 0x0 set param 44 value 33
[  640.470000] ath10k_pci 0000:00:00.0: mac monitor recalc started? 0 should? 0
[  640.540000] ath10k_pci 0000:00:00.0: mac sta rc update for
04:f0:21:0c:a5:43 changed 00000004 bw 0 nss 1 smps 2
[  640.540000] ath10k_pci 0000:00:00.0: mac sta rc update for
04:f0:21:0c:a5:43 changed 00000008 bw 0 nss 3 smps 2
[  640.540000] ath10k_pci 0000:00:00.0: mac update sta 04:f0:21:0c:a5:43 nss 3
[  640.540000] ath10k_pci 0000:00:00.0: wmi vdev 0 peer
0x04:f0:21:0c:a5:43 set param 5 value 3
[  640.540000] ath10k_pci 0000:00:00.0: mac update sta
04:f0:21:0c:a5:43 supp rates/nss
[  640.540000] ath10k_pci 0000:00:00.0: mac ht peer 04:f0:21:0c:a5:43
mcs cnt 24 nss 3
[  640.540000] ath10k_pci 0000:00:00.0: mac peer 04:f0:21:0c:a5:43 qos 0
[  640.540000] ath10k_pci 0000:00:00.0: mac peer 04:f0:21:0c:a5:43
phymode 11na-ht20
[  640.540000] ath10k_pci 0000:00:00.0: wmi peer assoc vdev 0 addr
04:f0:21:0c:a5:43 (reassociate)
[  640.540000] ath10k_pci 0000:00:00.0: wmi vdev 0 peer
0x04:f0:21:0c:a5:43 set param 5 value 3
[  640.560000] ath10k_pci 0000:00:00.0: wmi event debug mesg len 460
[  641.400000] ath10k_pci 0000:00:00.0: rx skb 86be4b40 len 148 peer
04:f0:21:0c:a5:43  mcast sn 2  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[  642.170000] ath10k_pci 0000:00:00.0: mac monitor recalc started? 0 should? 0
[  642.400000] ath10k_pci 0000:00:00.0: rx skb 86b49b40 len 108 peer
04:f0:21:0c:a5:43  mcast sn 3  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[  651.560000] ath10k_pci 0000:00:00.0: wmi event debug mesg len 28
[ 1740.540000] ath10k_pci 0000:00:00.0: rx skb 86af8540 len 60 peer
04:f0:21:0c:a5:43  mcast sn 4  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[ 1740.540000] ath10k_pci 0000:00:00.0: rx skb 86967600 len 116 peer
04:f0:21:0c:a5:43  ucast sn 0  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[ 1741.550000] ath10k_pci 0000:00:00.0: rx skb 86967000 len 116 peer
04:f0:21:0c:a5:43  ucast sn 1  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[ 1742.550000] ath10k_pci 0000:00:00.0: rx skb 86b8acc0 len 116 peer
04:f0:21:0c:a5:43  ucast sn 2  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[ 1743.550000] ath10k_pci 0000:00:00.0: rx skb 86a7a600 len 116 peer
04:f0:21:0c:a5:43  ucast sn 3  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[ 1746.560000] ath10k_pci 0000:00:00.0: rx skb 86a79cc0 len 60 peer
04:f0:21:0c:a5:43  ucast sn 4  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[ 1752.410000] ath10k_pci 0000:00:00.0: rx skb 86a9d540 len 116 peer
04:f0:21:0c:a5:43  ucast sn 5  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[ 1753.410000] ath10k_pci 0000:00:00.0: rx skb 86a7c6c0 len 116 peer
04:f0:21:0c:a5:43  ucast sn 6  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[ 1754.410000] ath10k_pci 0000:00:00.0: rx skb 86a7f6c0 len 116 peer
04:f0:21:0c:a5:43  ucast sn 7  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[ 1755.420000] ath10k_pci 0000:00:00.0: rx skb 86afc240 len 116 peer
04:f0:21:0c:a5:43  ucast sn 8  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[ 1756.420000] ath10k_pci 0000:00:00.0: rx skb 86a7d480 len 116 peer
04:f0:21:0c:a5:43  ucast sn 9  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0
[ 1757.420000] ath10k_pci 0000:00:00.0: rx skb 86af0180 len 116 peer
04:f0:21:0c:a5:43  ucast sn 10  rate_idx 0 vht_nss 0 freq 5180 band 1
flag 0x200000 fcs-err 0 mic-err 0 amsdu-more 0


On Tue, Dec 16, 2014 at 4:52 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> This fix TX problem when IBSS used in HT mode.
> Before we used 6Mbps all the time for TX direction.
>
> Reported-by: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 5475f0f..c9e7995 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -1411,9 +1411,16 @@ static void ath10k_peer_assoc_h_qos(struct ath10k *ar,
>                 if (vif->bss_conf.qos)
>                         arg->peer_flags |= WMI_PEER_QOS;
>                 break;
> +       case WMI_VDEV_TYPE_IBSS:
> +               if (sta->wme)
> +                       arg->peer_flags |= WMI_PEER_QOS;
> +               break;
>         default:
>                 break;
>         }
> +
> +       ath10k_dbg(ar, ATH10K_DBG_MAC, "mac peer %pM qos %d\n",
> +                  sta->addr, !!(arg->peer_flags & WMI_PEER_QOS));
>  }
>
>  static void ath10k_peer_assoc_h_phymode(struct ath10k *ar,
> --
> 1.9.1
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
