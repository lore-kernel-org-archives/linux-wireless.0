Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57252 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759307AbeD0V5m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Apr 2018 17:57:42 -0400
Subject: Re: [PATCH v2] ath10k: fix crash in recent 3.5.3 9984 firmware due
 wrong handling of peer_bw_rxnss_override parameter
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20180426092848.23069-1-s.gottschall@dd-wrt.com>
 <f288f18c-684d-2ff9-5739-648e8e716653@candelatech.com>
 <db214e94-1052-d6fa-744a-7c8ebcc84aee@dd-wrt.com>
 <96d512b3-3261-c6cf-e0eb-a9f5fe91f3b8@candelatech.com>
 <8263a720-07a2-dc5d-f8fc-2153574cbafc@dd-wrt.com>
 <96f0393e-6bab-d397-d2b6-4538da7fc275@candelatech.com>
 <f410c1d7-6b19-032d-7f03-6cb1d52f6956@dd-wrt.com>
Cc: kvalo@codeaurora.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <ebaf2806-a63b-5611-41f4-817b1f471fd1@candelatech.com> (sfid-20180427_235746_029999_A86762D2)
Date: Fri, 27 Apr 2018 14:57:39 -0700
MIME-Version: 1.0
In-Reply-To: <f410c1d7-6b19-032d-7f03-6cb1d52f6956@dd-wrt.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/27/2018 11:54 AM, Sebastian Gottschall wrote:
> Am 27.04.2018 um 18:07 schrieb Ben Greear:
>> On 04/26/2018 09:40 PM, Sebastian Gottschall wrote:
>>> Am 26.04.2018 um 22:35 schrieb Ben Greear:
>>>> On 04/26/2018 01:21 PM, Sebastian Gottschall wrote:
>>>>> Am 26.04.2018 um 17:30 schrieb Ben Greear:
>>>>>> On 04/26/2018 02:28 AM, s.gottschall@dd-wrt.com wrote:
>>>>>>> From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>>>>>>>
>>>>>>> current handling of peer_bw_rxnss_override parameter is based on guessing the VHT160/8080 capability by rx rate. this is wrong and may lead
>>>>>>> to a non initialized peer_bw_rxnss_override parameter which is required since VHT160 operation mode only supports 2x2 chainmasks in addition the original
>>>>>>> code
>>>>>>> initialized the parameter with wrong masked values.
>>>>>>> This patch uses the peer phymode and peer nss information for correct initialisation of the peer_bw_rxnss_override parameter.
>>>>>>> if this peer information is not available, we initialize the parameter by minimum nss which is suggested by QCA as temporary workaround according
>>>>>>> to the QCA sourcecodes.
>>>>>>>
>>>>>>> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>>>>>>>
>>>>>>> v2: remove debug messages
>>>>>>> ---
>>>>>>>  drivers/net/wireless/ath/ath10k/mac.c | 36 +++++++++++++++++++----------------
>>>>>>>  drivers/net/wireless/ath/ath10k/wmi.c |  4 +---
>>>>>>>  drivers/net/wireless/ath/ath10k/wmi.h | 14 +++++++++++++-
>>>>>>>  3 files changed, 34 insertions(+), 20 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>>>>>>> index 5be6386ede8f..df79af89ee71 100644
>>>>>>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>>>>>>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>>>>>>> @@ -2505,8 +2505,9 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
>>>>>>>      if (sta->bandwidth == IEEE80211_STA_RX_BW_80)
>>>>>>>          arg->peer_flags |= ar->wmi.peer_flags->bw80;
>>>>>>>
>>>>>>> -    if (sta->bandwidth == IEEE80211_STA_RX_BW_160)
>>>>>>> +    if (sta->bandwidth == IEEE80211_STA_RX_BW_160) {
>>>>>>>          arg->peer_flags |= ar->wmi.peer_flags->bw160;
>>>>>>> +    }
>>>>>>>
>>>>>>>      /* Calculate peer NSS capability from VHT capabilities if STA
>>>>>>>       * supports VHT.
>>>>>>> @@ -2529,22 +2530,25 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
>>>>>>>      arg->peer_vht_rates.tx_mcs_set = ath10k_peer_assoc_h_vht_limit(
>>>>>>>          __le16_to_cpu(vht_cap->vht_mcs.tx_mcs_map), vht_mcs_mask);
>>>>>>>
>>>>>>> -    ath10k_dbg(ar, ATH10K_DBG_MAC, "mac vht peer %pM max_mpdu %d flags 0x%x\n",
>>>>>>> -           sta->addr, arg->peer_max_mpdu, arg->peer_flags);
>>>>>>> +    if (arg->peer_num_spatial_streams && (arg->peer_phymode == MODE_11AC_VHT160 || arg->peer_phymode == MODE_11AC_VHT80_80)) {
>>>>>>> +        arg->peer_bw_rxnss_override = BW_NSS_FWCONF_160(arg->peer_num_spatial_streams);
>>>>>>> +    }
>>>>>>
>>>>>> So, an 80Mhz peer could be 4x4 and could connect to a VHT-160 AP. From what I can tell,
>>>>>> the VHT-160 AP can talk 4x4 @ 80Mhz to the peer in this case, but if peer is VHT-160,
>>>>>> then of course it can only talk at 2x2.
>>>>>>
>>>>>> So, I don't think you can just look at the peer_num_spatial_streams here.
>>>>> no? rxnss_override is only taked if peer phymode is vht160 or vht80_80. vht80 is not considered in that code PEER phy_mode, not HOST phy_mode
>>>>> this parameter is a assoc per peer parameter as far as i can say here.
>>>>> consider that the firmware will accept anything except 0 for peer_bw_rxnss_override in vht160 operation mode
>>>>> if a peer is 80 mhz, the code will be skipped here.
>>>>
>>>> From what I can tell, this feature is supposed to configure the rate-ctrl in the firmware to know that
>>>> it can only send 1x1 or 2x2 when sending at 160Mhz, but that it can send at higher NSS if it sends
>>>> at 80Mhz or lower.
>>> right. but thats exactly what it should does in case that a peer is connecting with vht160 / 80_80
>>> and the peer itself does also send his own nss capabilities which is used if available. if not ,it uses the fallback.
>>>>
>>>> If a 2x2 peer connects to the AP, will it have peer_num_spatial_streams set to 2?
>>> yes. i had some debug code in my initial early versions. the peer does transmit his own nss capabilities.
>>>> If so,
>>>> then your code will configure the peer_bw_rxnss_override to indicate it can send at 160Mhz
>>>> 2x2 as well, right?  And if so, then that is incorrect.
>>> no. since nss_override is only set if peer phymode is 160 mhz as well
>>
>> The peer can run at 2x2 80Mhz and 1x1 160Mhz at the same time, so it can advertise
>> 2x2 nss and phy-mode of 160Mhz when associating to the 160Mhz AP, but the peer can only do 1x1 at 160Mhz.  There
>> is no standard way I know of for the peer to tell you specifically that it can only do
>> 1x1 at 160Mhz and also 2x2 at 80Mhz in this case.
> per specification the peer is able to provide max nss to the ap. the rx_nss property is calculated
> from the mcs rateset provided by the peer by mac80211. this is mcs set provided on on assoc is mandatory.
> so there is a way the peer can tell you what it supports and this is what is used.
> if a peer does not provide the mcs rateset (which i have seen for a single marvell client)
> the fallback mechanism will still work, but just with 1x1. the problem is anything else will crash the firmware.
> we have to deal with that.
>
> That is why this rxnns_override exists, to hack around this problem.
>
> i dont think so, because its not just a hack. without providing that parameter the firmware will crash.
> so its a always required parameter and not just a hack. for sure the firmware can handle it by itself, just someone
> at qca should start to work on it.
> but again. my implementation is correct from the information i have out of the qca propertiery wireless driver sources
>>
>> Your patch is going to break in this case as far as I can tell.
> no it isnt. my tests with various different clients from different vendors shows that its working. with 2x2 and 1x1.
> its all well detected by the code and configured as expected
> consider that this patch fixes a CRASH. accept that. it wont break. it repairs.

I did some testing with the patch below.

The CHAIMASK_ERR is a debug log from FW that I added to help make sure the patch is
acting as desired.  The first hex is an identifier, second is the value passed in,
third is phymode, 4th is the tx-chain-mask for 160Mhz frames.

On station side, when associating a 4x4 9984 station to 9984 configured for nss4, 160Mhz, I see:
[86376.620303] ath10k_pci 0000:04:00.0: NIC rx-max-rate: 1560 calculated-max: 1560 rxnss_override: 0x80000009  nss160: 2  spatial-streams: 4
   ath10k-fw: ts: 15229 args: 4 RATE_CTRL(19) vid: 255       CHAINMASK_ERR(03)  0x000000af 0x80000009 0x0000000f 0x00000003

On station side, when associating a 4x4 9984 station with chain-mask of 0x3 (2x2) to 9984 configured for nss4, 160Mhz, I see:

[86147.569319] ath10k_pci 0000:04:00.0: NIC rx-max-rate: 1560 calculated-max: 780 rxnss_override: 0x80000000  nss160: 1  spatial-streams: 2
ath10k-fw: ts: 6807 args: 4 RATE_CTRL(19) vid: 255       CHAINMASK_ERR(03)  0x000000af 0x80000000 0x0000000f 0x00000001


On AP side, when associating a 4x4 9984 station to 9984 configured for 160Mhz, I see:

[11167.635324] ath10k_pci 0000:04:00.0: NIC rx-max-rate: 1560 calculated-max: 1560 rxnss_override: 0x80000009  nss160: 2  spatial-streams: 4
   ath10k-fw: ts: 72917 args: 4 RATE_CTRL(19) vid: 255       CHAINMASK_ERR(03)  0x000000af 0x80000009 0x0000000f 0x00000003

On AP side, when associating a 4x4 9984 station with chain-mask of 0x3 (2x2) to 9984 configured for nss4, 160Mhz, I see:

[11422.887181] ath10k_pci 0000:04:00.0: NIC rx-max-rate: 1560 calculated-max: 780 rxnss_override: 0x80000000  nss160: 1  spatial-streams: 2
   ath10k-fw: ts: 334266 args: 4 RATE_CTRL(19) vid: 255       CHAINMASK_ERR(03)  0x000000af 0x80000000 0x0000000f 0x00000001

On AP side, when associating a 4x4 9984 station configured for 80Mhz instead of 160,
then logging from firmware indicates full 4x4 rates are supported for 80Mhz and below,
and the rxnss_override does not have the (1<<31) bit set:

   ath10k-fw: ts: 519211 args: 4 RATE_CTRL(19) vid: 255       CHAINMASK_ERR(03)  0x000000af 0x00000000 0x0000000a 0x00000001


So, I think this might be a better fix for this problem (included inline for discussion,
probably white-space damaged by email client:


diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e1ad983..8bce916 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2860,18 +2860,39 @@ static void ath10k_peer_assoc_h_vht(struct ath10k *ar,
  		   arg->peer_vht_rates.rx_max_rate, arg->peer_vht_rates.rx_mcs_set,
  		   arg->peer_vht_rates.tx_max_rate, arg->peer_vht_rates.tx_mcs_set);

-	if (arg->peer_vht_rates.rx_max_rate &&
-	    (sta->vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK)) {
-		switch (arg->peer_vht_rates.rx_max_rate) {
+	if (arg->peer_phymode == MODE_11AC_VHT80_80 ||
+	    arg->peer_phymode == MODE_11AC_VHT160) {
+		int nss160;
+		int rx = arg->peer_vht_rates.rx_max_rate;
+		/* Deal with cases where chainmask has been decreased.
+		 * All known chips that support 160Mhz can do only 1/2 of
+		 * the available chains at 160Mhz.
+		 */
+		rx = min((int)(arg->peer_num_spatial_streams * 390), rx);
+
+		switch (rx) {
+			/* When a NIC shows up that can do 4x4 at 160Mhz, its
+			 * max-rate should be higher, and we can set nss160
+			 * to 4 here.
+			 */
  		case 1560:
  			/* Must be 2x2 at 160Mhz is all it can do. */
-			arg->peer_bw_rxnss_override = 2;
+			nss160 = 2;
  			break;
-		case 780:
-			/* Can only do 1x1 at 160Mhz (Long Guard Interval) */
-			arg->peer_bw_rxnss_override = 1;
+		default:
+			/* Assume we can only do 1x1 at 160Mhz */
+			nss160 = 1;
  			break;
  		}
+
+		arg->peer_bw_rxnss_override = ((nss160 - 1) | /* 160Mhz nss */
+					       ((nss160 - 1) << 3) | /* 80+80 nss */
+					       BIT(PEER_BW_RXNSS_OVERRIDE_OFFSET));
+
+		ath10k_warn(ar, "NIC rx-max-rate: %d calculated-max: %d rxnss_override: 0x%x  nss160: %d  spatial-streams: %d\n",
+			    arg->peer_vht_rates.rx_max_rate, rx,
+			    arg->peer_bw_rxnss_override, nss160,
+			    arg->peer_num_spatial_streams);
  	}
  }

@@ -3115,9 +3136,9 @@ static int ath10k_peer_assoc_prepare(struct ath10k *ar,
  	ath10k_peer_assoc_h_crypto(ar, vif, sta, arg);
  	ath10k_peer_assoc_h_rates(ar, vif, sta, arg);
  	ath10k_peer_assoc_h_ht(ar, vif, sta, arg);
+	ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);
  	ath10k_peer_assoc_h_vht(ar, vif, sta, arg);
  	ath10k_peer_assoc_h_qos(ar, vif, sta, arg);
-	ath10k_peer_assoc_h_phymode(ar, vif, sta, arg);

  	ath10k_peer_assoc_h_rate_overrides(ar, vif, sta, arg);


diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 8eeeab0..365d509 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -7442,12 +7442,8 @@ ath10k_wmi_peer_assoc_fill_10_4(struct ath10k *ar, void *buf,
  	struct wmi_10_4_peer_assoc_complete_cmd *cmd = buf;

  	ath10k_wmi_peer_assoc_fill_10_2(ar, buf, arg);
-	if (arg->peer_bw_rxnss_override)
-		cmd->peer_bw_rxnss_override =
-			__cpu_to_le32((arg->peer_bw_rxnss_override - 1) |
-				      BIT(PEER_BW_RXNSS_OVERRIDE_OFFSET));
-	else
-		cmd->peer_bw_rxnss_override = 0;
+
+	cmd->peer_bw_rxnss_override = __cpu_to_le32(arg->peer_bw_rxnss_override);
  }

  static int



Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
