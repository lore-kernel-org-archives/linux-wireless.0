Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0042.outbound.protection.outlook.com ([104.47.1.42]:27829
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754841AbeA2U0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jan 2018 15:26:52 -0500
Subject: Re: [PATCH v3] mac80211: mesh: fix wrong mesh TTL offset calculation
To: kbuild test robot <lkp@intel.com>
References: <8582518b7f032acfa598faf7d26c765b09149e90.1516842930.git.peter.oh@bowerswilkins.com>
 <201801280437.OtqScEom%fengguang.wu@intel.com>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, johannes.berg@intel.com
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <b08b5134-5902-f099-0a9f-0f95a291315b@bowerswilkins.com> (sfid-20180129_212752_419971_D4D418B6)
Date: Mon, 29 Jan 2018 12:26:26 -0800
MIME-Version: 1.0
In-Reply-To: <201801280437.OtqScEom%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have patch v4 which fixes the warning, so we can ignore this warning I 
believe.

Thanks,
Peter
On 01/27/2018 01:00 PM, kbuild test robot wrote:
> Hi Peter,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on mac80211-next/master]
> [also build test ERROR on v4.15-rc9 next-20180126]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/peter-oh-bowerswilkins-com/mac80211-mesh-fix-wrong-mesh-TTL-offset-calculation/20180128-042444
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
> config: i386-randconfig-x070-201804 (attached as .config)
> compiler: gcc-7 (Debian 7.2.0-12) 7.2.1 20171025
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=i386
>
> All errors (new ones prefixed by >>):
>
>     net//mac80211/mesh.c: In function 'mesh_fwd_csa_frame':
>>> net//mac80211/mesh.c:1271:40: error: decrement of member 'mesh_ttl' in read-only object
>       elems->mesh_chansw_params_ie->mesh_ttl--;
>                                             ^~
>>> net//mac80211/mesh.c:1272:43: error: assignment of member 'mesh_flags' in read-only object
>       elems->mesh_chansw_params_ie->mesh_flags &=
>                                                ^~
>
> vim +/mesh_ttl +1271 net//mac80211/mesh.c
>
>    1256	
>    1257	static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
>    1258				       struct ieee80211_mgmt *mgmt, size_t len,
>    1259				       struct ieee802_11_elems *elems)
>    1260	{
>    1261		struct ieee80211_mgmt *mgmt_fwd;
>    1262		struct sk_buff *skb;
>    1263		struct ieee80211_local *local = sdata->local;
>    1264	
>    1265		skb = dev_alloc_skb(local->tx_headroom + len);
>    1266		if (!skb)
>    1267			return -ENOMEM;
>    1268		skb_reserve(skb, local->tx_headroom);
>    1269		mgmt_fwd = skb_put(skb, len);
>    1270	
>> 1271		elems->mesh_chansw_params_ie->mesh_ttl--;
>> 1272		elems->mesh_chansw_params_ie->mesh_flags &=
>    1273			~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
>    1274	
>    1275		memcpy(mgmt_fwd, mgmt, len);
>    1276		eth_broadcast_addr(mgmt_fwd->da);
>    1277		memcpy(mgmt_fwd->sa, sdata->vif.addr, ETH_ALEN);
>    1278		memcpy(mgmt_fwd->bssid, sdata->vif.addr, ETH_ALEN);
>    1279	
>    1280		ieee80211_tx_skb(sdata, skb);
>    1281		return 0;
>    1282	}
>    1283	
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
