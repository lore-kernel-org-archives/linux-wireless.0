Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:51499 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaAMJvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 04:51:33 -0500
Received: by mail-bk0-f48.google.com with SMTP id r7so2344334bkg.21
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 01:51:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADnKcViYW_iXJYokjiDnC+MjR4xw-gn0ZPOcf-CVgROsXxtm5A@mail.gmail.com>
References: <1388390871-3932-1-git-send-email-marek.puzyniak@tieto.com>
	<CAEFj987Rxv9azS4EmW47a5guhVT-JijXsxSOgcGfvgwLkB9tEg@mail.gmail.com>
	<CADnKcViXui6jCsBxgbYh5A2R4ra+p3YxBP-Om1cT5GaYjjAFPw@mail.gmail.com>
	<CAEFj985kz+5DWx=hvDu=w=BEud0fJGbYMpUT939xVPbvFbXFPw@mail.gmail.com>
	<CADnKcViYW_iXJYokjiDnC+MjR4xw-gn0ZPOcf-CVgROsXxtm5A@mail.gmail.com>
Date: Mon, 13 Jan 2014 17:51:32 +0800
Message-ID: <CAEFj985LQAdQiBf4mQ6Ka54y-A_JitpHWeXXZMNj0AEtnX89Vw@mail.gmail.com> (sfid-20140113_105138_286051_F2BA5BFA)
Subject: Re: [PATCH] ath10k: disable STA KICKOUT in FW
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: ath10k@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unfortunately, I have tried your mentioned firmware, but I am still
getting the WMI_PEER_STA_KICKOUT_EVENTID.

[  159.020000] ath10k: wmi pdev set param 13 value 0
.....
[  181.380000] ath10k: wmi peer assoc vdev 0 addr 04:f0:21:0c:a5:44
[  182.000000] ath10k: wmi event debug mesg len 44
[  182.040000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  183.040000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  184.040000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  185.040000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  185.580000] ath10k: wmi mgmt tx skb 86845f00 len 176 ftype 00 stype 50
[  185.580000] ath10k: wmi mgmt tx skb 86846180 len 176 ftype 00 stype 50
[  186.040000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  187.040000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  188.040000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  189.040000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  190.040000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  191.040000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  192.040000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  193.040000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  194.050000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
[  195.050000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID

# ethtool -i wlan0
driver: ath10k_pci
version: 3.3.8
firmware-version: 10.1.467-1

Am I miss out something?

----
Chun-Yeow


On Mon, Jan 13, 2014 at 4:40 PM, Marek Puzyniak
<marek.puzyniak@tieto.com> wrote:
> On 9 January 2014 10:09, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>> Hi, Marek
> Hi,
>>
>> Do you mind to share which firmware that you are using?
>
> I am using FW from:
> https://github.com/kvalo/ath10k-firmware/blob/master/ap/firmware-2.bin_10.1.467-1
>
>> I have tried your patch and this is set accordingly in an the AP (set
>> param 13). But once the associated STA is leaving,
>> WMI_PEER_STA_KICKOUT_EVENTID is still received.
>>
>> [  145.060000] ath10k: wmi pdev set param 13 value 0
>> .......
>> [  148.560000] ath10k: wmi vdev id 0x0 set param 8 value 1
>> [  148.560000] ath10k: wmi peer create vdev_id 0 peer_addr 04:f0:21:0c:a5:44
>> [  148.560000] ath10k: wmi peer assoc vdev 0 addr 04:f0:21:0c:a5:44
>> [  149.040000] ath10k: wmi event debug mesg len 44
>> [  209.090000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
>> [  210.090000] ath10k: WMI_PEER_STA_KICKOUT_EVENTID
>>
>> FYI, I am using firmware version 999.999.0.636
>>
>> ethtool -i wlan0
>> driver: ath10k_pci
>> firmware-version: 999.999.0.636
>>
>> Thanks
>>
>> Regards,
>> Chun-Yeow
> Marek
>>
>>
>> On Wed, Jan 8, 2014 at 6:40 PM, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
>>> On 2 January 2014 13:41, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>>>>
>>>> On Dec 30, 2013 4:08 PM, "Marek Puzyniak" <marek.puzyniak@tieto.com> wrote:
>>>>>
>>>>> Currently ath10k is not using STA KICKOUT firmware functionality.
>>>>> In order to avoid unwanted FW events this functionality should be
>>>>> disabled when not used.
>>>>
>>>> What are unwanted FW events?
>>>
>>> WMI_PEER_STA_KICKOUT_EVENT which indicates lack of activity from
>>> associated STA for specified period of time.
>>>
>>>>
>>>> ----
>>>> Chun-Yeow
>>> Marek
>>>>
>>>>> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
>>>>> ---
>>>>>  drivers/net/wireless/ath/ath10k/mac.c | 9 +++++++++
>>>>>  1 file changed, 9 insertions(+)
>>>>>
>>>>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
>>>>> b/drivers/net/wireless/ath/ath10k/mac.c
>>>>> index 5b45f3a..93416ab 100644
>>>>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>>>>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>>>>> @@ -2292,11 +2292,20 @@ static int ath10k_add_interface(struct
>>>>> ieee80211_hw *hw,
>>>>>         }
>>>>>
>>>>>         if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
>>>>> +               u32 param_id;
>>>>> +
>>>>>                 ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr);
>>>>>                 if (ret) {
>>>>>                         ath10k_warn("Failed to create peer for AP: %d\n",
>>>>> ret);
>>>>>                         goto err_vdev_delete;
>>>>>                 }
>>>>> +
>>>>> +               param_id = ar->wmi.pdev_param->sta_kickout_th;
>>>>> +
>>>>> +               /* Disable STA KICKOUT functionality in FW */
>>>>> +               ret = ath10k_wmi_pdev_set_param(ar, param_id, 0);
>>>>> +               if (ret)
>>>>> +                       ath10k_warn("Failed to disable STA KICKOUT\n");
>>>>>         }
>>>>>
>>>>>         if (arvif->vdev_type == WMI_VDEV_TYPE_STA) {
>>>>> --
>>>>> 1.8.1.2
>>>>>
>>>>>
>>>>> _______________________________________________
>>>>> ath10k mailing list
>>>>> ath10k@lists.infradead.org
>>>>> http://lists.infradead.org/mailman/listinfo/ath10k
