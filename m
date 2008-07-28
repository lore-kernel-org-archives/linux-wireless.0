Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [66.209.47.173] ([66.209.47.173]:59250 "EHLO mythtv.ewol.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752835AbYG1KZm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 06:25:42 -0400
Message-ID: <488D9E79.8050408@cortland.com> (sfid-20080728_122546_840137_51FD7C0F)
Date: Mon, 28 Jul 2008 06:24:57 -0400
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
MIME-Version: 1.0
To: YanBo <dreamfly281@gmail.com>
CC: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [ath5k-devel] [PATCH] ath5k: add Mesh Point support
References: <487fa7a8.14da600a.1aae.48b1@mx.google.com> <1197ff4c0807280209x754f3a15j9dca3e60e99c69cb@mail.gmail.com>
In-Reply-To: <1197ff4c0807280209x754f3a15j9dca3e60e99c69cb@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040500050305000303090707"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040500050305000303090707
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

YanBo wrote:
> On Fri, Jul 18, 2008 at 4:12 AM, Andrey Yurovsky <andrey@cozybit.com> wrote:
>   
>> This enables draft-802.11s Mesh Point operation.  For that we need mesh
>> beaconing.  Tested with AR5212/AR5213 PCI card against Zydas and b43 mesh
>> nodes.
>>
>> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
>> ---
>> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
>> index 217d506..6d9f4e1 100644
>> --- a/drivers/net/wireless/ath5k/base.c
>> +++ b/drivers/net/wireless/ath5k/base.c
>> @@ -1425,7 +1425,8 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
>>        ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
>>        if (ret)
>>                return ret;
>> -       if (sc->opmode == IEEE80211_IF_TYPE_AP) {
>> +       if (sc->opmode == IEEE80211_IF_TYPE_AP ||
>> +               sc->opmode == IEEE80211_IF_TYPE_MESH_POINT) {
>>                /*
>>                 * Always burst out beacon and CAB traffic
>>                 * (aifs = cwmin = cwmax = 0)
>> @@ -2911,6 +2912,7 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
>>        if (sc->opmode != IEEE80211_IF_TYPE_STA)
>>                rfilt |= AR5K_RX_FILTER_PROBEREQ;
>>        if (sc->opmode != IEEE80211_IF_TYPE_AP &&
>> +               sc->opmode != IEEE80211_IF_TYPE_MESH_POINT &&
>>                test_bit(ATH_STAT_PROMISC, sc->status))
>>                rfilt |= AR5K_RX_FILTER_PROM;
>>        if (sc->opmode == IEEE80211_IF_TYPE_STA ||
>> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
>> index c6d12c5..8854820 100644
>> --- a/drivers/net/wireless/ath5k/hw.c
>> +++ b/drivers/net/wireless/ath5k/hw.c
>> @@ -2326,6 +2326,7 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah)
>>                break;
>>
>>        case IEEE80211_IF_TYPE_AP:
>> +       case IEEE80211_IF_TYPE_MESH_POINT:
>>                pcu_reg |= AR5K_STA_ID1_AP | AR5K_STA_ID1_RTS_DEF_ANTENNA |
>>                        (ah->ah_version == AR5K_AR5210 ?
>>                                AR5K_STA_ID1_NO_PSPOLL : 0);
>>
>>
>>     
>
> Hi Andrey
>
> commands:
>
> iw dev wmaster0 interface add mesh type mp mesh_id 12345
> iwconfig mesh channel 1
> ifconfig mesh 192.168.3.80/192.168.3.81
>
> but there is no  beacon was send from any of them, after input "iw dev
> mesh station dump"
> it also no station was found,(PS:the two PC are very close), ping each
> other also no response.
>
>   

I've been looking at this too. After the "revamp beacon configuration" 
patch, mesh no longer send beacons. If I revert it, beacons reappear and 
my two stations are found. I'm using both a b43 & zd1211rw.

I believe the problem is in mac80211. It appears that the call to 
ieee80211_if_config that was previously in ieee80211_open never made it 
to the new start_mesh routine in the revision. The attached patch seems 
to revive beacons and both stations are now found. I'm not familiar with 
the code and wouldn't call this a fix.

BTW: the Wireshark patch for mesh frames at open80211s.org is outdated. 
The header length is now 6 and the ie codes have changed. I'll post a 
new patch back there. Also, only madwifi and b43 drivers return all 
frames when in monitor mode. The ath5k driver doesn't. It sure would be 
nice if it did.

Steve


--------------040500050305000303090707
Content-Type: text/plain;
 name="start_mesh.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="start_mesh.patch"

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9tbG1lLmMgYi9uZXQvbWFjODAyMTEvbWxtZS5j
CmluZGV4IDhmNTEzNzUuLjEwZjVkNmEgMTAwNjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS9tbG1l
LmMKKysrIGIvbmV0L21hYzgwMjExL21sbWUuYwpAQCAtMzMwMCw2ICszMzAwLDcgQEAgdm9p
ZCBpZWVlODAyMTFfc3RhcnRfbWVzaChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQogewogCXN0
cnVjdCBpZWVlODAyMTFfaWZfc3RhICppZnN0YTsKIAlzdHJ1Y3QgaWVlZTgwMjExX3N1Yl9p
Zl9kYXRhICpzZGF0YSA9IElFRUU4MDIxMV9ERVZfVE9fU1VCX0lGKGRldik7CisJaWVlZTgw
MjExX2lmX2NvbmZpZyhzZGF0YSwgSUVFRTgwMjExX0lGQ0NfQkVBQ09OKTsKIAlpZnN0YSA9
ICZzZGF0YS0+dS5zdGE7CiAJaWZzdGEtPnN0YXRlID0gSUVFRTgwMjExX01FU0hfVVA7CiAJ
aWVlZTgwMjExX3N0YV90aW1lcigodW5zaWduZWQgbG9uZylzZGF0YSk7Cg==
--------------040500050305000303090707--
