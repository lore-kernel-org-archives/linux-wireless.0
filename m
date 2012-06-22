Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-4.exch022.serverdata.net ([206.225.164.187]:2883 "EHLO
	HUB022-nj-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757420Ab2FVDGs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 23:06:48 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v3] cfg80211/mac80211: 802.11ac changes
Date: Fri, 22 Jun 2012 03:06:46 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3D6F@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120622_050652_619728_5C5475F4)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3CE8@mbx022-e1-nj-10.exch022.domain.local>
 <1340302471.4489.43.camel@jlt3.sipsolutions.net>
 <4FE36942.1090801@broadcom.com>
 <1340303967.4489.44.camel@jlt3.sipsolutions.net>,<4FE36FC1.2020702@broadcom.com>
In-Reply-To: <4FE36FC1.2020702@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

________________________________________
From: Arend van Spriel [arend@broadcom.com]
Sent: Friday, June 22, 2012 12:32 AM
To: Johannes Berg
Cc: Mahesh Palivela; linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: [RFC v3] cfg80211/mac80211: 802.11ac changes

On 06/21/2012 08:39 PM, Johannes Berg wrote:
> On Thu, 2012-06-21 at 20:34 +0200, Arend van Spriel wrote:
>> On 06/21/2012 08:14 PM, Johannes Berg wrote:
>>> On Thu, 2012-06-21 at 16:51 +0000, Mahesh Palivela wrote:
>>>
>>>> +/* 802.11ac VHT Capabilities */
>>>> +#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991                0x00000001
>>>> +#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454               0x00000002
>>>
>>> I have a feeling there should be a value for 3895, since this isn't
>>> really a bitfield only (it doesn't make sense to set both of these, in
>>> fact 3 is reserved)
>>
>> These are matching the values specified for the VHP Capability Info IE.
>> 3895 is specified as 0. Value 3 is reserved because it is not to be
>> regarded as a bit field.
>
> Right, but I think it'd make more sense to actually have the 3895 value
> as a constant here so you're not tempted to think that you could set

[MP] Should I declare another constant for this?
+#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895   0

Understood. I though you were suggesting

+/* 802.11ac VHT Capabilities */
+#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895   1
+#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991   2
+#define IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454  3

for internal use. I agree adding 0 value for 3895 clarifies that it is
not a bitfield.

> both bits? anyway ... I hope whoever adds VHT to their driver knows what
> they're doing so it doesn't matter much :)

I hope so too :-p

> johannes
>
>


Gr. AvS

