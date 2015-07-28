Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13970 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbbG1SMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 14:12:52 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>
Subject: Re: [RFC 02/10] mac80211: allow to transmit A-MSDU within A-MPDU
Date: Tue, 28 Jul 2015 18:12:44 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E7DA16C@hasmsx107.ger.corp.intel.com> (sfid-20150728_201259_731093_37D9D50E)
References: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com>
 <1437421384-19884-3-git-send-email-emmanuel.grumbach@intel.com>
 <CABPxzYKKCLDaoAyE0VR66ynAxnm9Ob5m6T0ADbH415J6-i=6WA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32E7D9B01@hasmsx107.ger.corp.intel.com>
 <0BA3FCBA62E2DC44AF3030971E174FB32E7DA09A@hasmsx107.ger.corp.intel.com>
 <CABPxzYKAdM95FFrUb-z620eX5+m9HDBXHABsb-x1AvChB0awgg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/28/2015 08:27 PM, Krishna Chaitanya wrote:
> On Tue, Jul 28, 2015 at 10:42 PM, Grumbach, Emmanuel
> <emmanuel.grumbach@intel.com> wrote:
>>
>> On 07/28/2015 02:35 PM, Grumbach, Emmanuel wrote:
>>>> On Tue, Jul 21, 2015 at 1:12 AM, Emmanuel Grumbach
>>>> <emmanuel.grumbach@intel.com> wrote:
>>>>> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c index
>>>>> c8ba2e7..a758eb84 100644
>>>>> --- a/net/mac80211/agg-tx.c
>>>>> +++ b/net/mac80211/agg-tx.c
>>>>> @@ -97,7 +97,8 @@ static void ieee80211_send_addba_request(struct
>>>> ieee80211_sub_if_data *sdata,
>>>>>         mgmt->u.action.u.addba_req.action_code =
>>>>> WLAN_ACTION_ADDBA_REQ;
>>>>>
>>>>>         mgmt->u.action.u.addba_req.dialog_token = dialog_token;
>>>>> -       capab = (u16)(1 << 1);          /* bit 1 aggregation policy */
>>>>> +       capab = (u16)(1 << 0);          /* bit 0 A-MSDU support */
>>>> Shouldn't this be based on HW capability? We can add couple of more _HW_
>>>> flags for TX and RX and populate this based on that?
>>> Why?
>>> What will happen if we ask for A-MSDU inside A-MPDU and we won't do A-MSDU?
>>> Worst case, the AP will deny this and will clear that bit in its response.
>> I feel that my response was accurate, but the wording wasn't precise enough.
>> We have two possibilities:
>> 1) the AP does support A-MSDU in A-MPDU
>> 2) the AP does not support A-MSDU in A-MPDU
>>
>> In the first case, the AP will reply with that bit set and the client
>> can choose to send A-MSDU or not. I don't think that the AP needs to
>> allocate anything special to support A-MSDU in A-MPDU, so it is free to ask.
> AP needs to allocate large RX buffers to accomodate AMSDU + AMPDU, no?
>> In the second case, the AP will reply with that same bit clear in the
>> AddBA response, and mac0211 / driver will know not to send A-MSDU in
>> A-MPDU (which the driver doesn't support in the case you were describing
>> - so this is a no-op).
>> The only concern you may have is about APs that would decline the AddBA
>> request because of that bit. That doesn't seem to happen since a lot of
>> vendors use A-MSDU in A-MPDU.
> I understand from AP point of view, but what about the local HW? Don't we need
> HW support to handle this A-MSDU in AMPDU? (or) the driver should handle this
> support in ampdu_action based on the amsdu flag?
>
Depends on the HW design. But even if a device does not support it, then
nothing bad will happen. mac80211 will request A-MSDU in A-MDPU and that
specific device simply won't ever use that capability.
