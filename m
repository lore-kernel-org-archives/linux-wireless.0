Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38662 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161222AbcFMTae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 15:30:34 -0400
Received: by mail-wm0-f41.google.com with SMTP id m124so93380563wme.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2016 12:30:33 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: rework function picking free BSS index
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1464219876-13776-1-git-send-email-zajec5@gmail.com>
 <5759C09F.7020704@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Franky Lin <franky.lin@broadcom.com>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<brcm80211-dev-list@broadcom.com>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <575F09D7.6030505@broadcom.com> (sfid-20160613_213058_923516_3F8F2618)
Date: Mon, 13 Jun 2016 21:30:31 +0200
MIME-Version: 1.0
In-Reply-To: <5759C09F.7020704@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09-06-16 21:16, Arend van Spriel wrote:
> On 26-05-16 01:44, Rafał Miłecki wrote:
>> The old implementation was overcomplicated and slightly bugged in some
>> corner cases.
>>

[...]

>> New code is simpler, placed in file where it's really used, handles
>> running out of free BSS-es and allows using 4 interfaces at the same
>> time. It also looks for the first free BSS instead of one after the last
>> in use. It works well with current driver (which doesn't allow deleting
>> interfaces) and should be future proof (if we ever allow deleting).
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 17 ++++++++++++++-
>>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 24 ----------------------
>>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  1 -
>>  3 files changed, 16 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> index 3d09d23..d00eef8 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> @@ -541,6 +541,21 @@ brcmf_cfg80211_update_proto_addr_mode(struct wireless_dev *wdev)
>>  						ADDR_INDIRECT);
>>  }
>>  
>> +static int brcmf_get_first_free_bsscfgidx(struct brcmf_pub *drvr)
>> +{
>> +	int bsscfgidx;
>> +
>> +	for (bsscfgidx = 0; bsscfgidx < BRCMF_MAX_IFS; bsscfgidx++) {
>> +		/* bsscfgidx 1 is reserved for legacy P2P */
> 
> Hi Rafał,
> 
> A bit late as the patch is already applied, but this reserved index is
> no longer needed as we removed all trickery that was build on the
> assumption that the P2P_DEVICE interface was always in bsscfgidx 1.
> Hence this could be removed.

I tested STA on bsscfgidx=0, AP on bsscfgidx=1, and P2P_DEV on
bsscfgidx=2. P2P discovery on P2P_DEV interface works as expected so we
can indeed drop the 'bsscfgidx 1 is reserved' statement. I want to
verify on an older device before creating a patch.

Regards,
Arend

> Regards,
> Arend
> 
>> +		if (bsscfgidx == 1)
>> +			continue;
>> +		if (!drvr->iflist[bsscfgidx])
>> +			return bsscfgidx;
>> +	}
>> +
>> +	return -ENOMEM;
>> +}
>> +
>>  static int brcmf_cfg80211_request_ap_if(struct brcmf_if *ifp)
>>  {
>>  	struct brcmf_mbss_ssid_le mbss_ssid_le;
>> @@ -548,7 +563,7 @@ static int brcmf_cfg80211_request_ap_if(struct brcmf_if *ifp)
>>  	int err;
>>  
>>  	memset(&mbss_ssid_le, 0, sizeof(mbss_ssid_le));
>> -	bsscfgidx = brcmf_get_next_free_bsscfgidx(ifp->drvr);
>> +	bsscfgidx = brcmf_get_first_free_bsscfgidx(ifp->drvr);
>>  	if (bsscfgidx < 0)
>>  		return bsscfgidx;
>>  
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> index b590499..6a76480 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>> @@ -753,30 +753,6 @@ void brcmf_remove_interface(struct brcmf_if *ifp)
>>  	brcmf_del_if(ifp->drvr, ifp->bsscfgidx);
>>  }
>>  
>> -int brcmf_get_next_free_bsscfgidx(struct brcmf_pub *drvr)
>> -{
>> -	int ifidx;
>> -	int bsscfgidx;
>> -	bool available;
>> -	int highest;
>> -
>> -	available = false;
>> -	bsscfgidx = 2;
>> -	highest = 2;
>> -	for (ifidx = 0; ifidx < BRCMF_MAX_IFS; ifidx++) {
>> -		if (drvr->iflist[ifidx]) {
>> -			if (drvr->iflist[ifidx]->bsscfgidx == bsscfgidx)
>> -				bsscfgidx = highest + 1;
>> -			else if (drvr->iflist[ifidx]->bsscfgidx > highest)
>> -				highest = drvr->iflist[ifidx]->bsscfgidx;
>> -		} else {
>> -			available = true;
>> -		}
>> -	}
>> -
>> -	return available ? bsscfgidx : -ENOMEM;
>> -}
>> -
>>  #ifdef CONFIG_INET
>>  #define ARPOL_MAX_ENTRIES	8
>>  static int brcmf_inetaddr_changed(struct notifier_block *nb,
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
>> index 647d3cc..2a075c5 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
>> @@ -217,7 +217,6 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
>>  struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
>>  			      bool is_p2pdev, char *name, u8 *mac_addr);
>>  void brcmf_remove_interface(struct brcmf_if *ifp);
>> -int brcmf_get_next_free_bsscfgidx(struct brcmf_pub *drvr);
>>  void brcmf_txflowblock_if(struct brcmf_if *ifp,
>>  			  enum brcmf_netif_stop_reason reason, bool state);
>>  void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
>>
