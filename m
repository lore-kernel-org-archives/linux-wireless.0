Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34775 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbcF3Jqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 05:46:36 -0400
Received: by mail-oi0-f66.google.com with SMTP id s17so6536741oih.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2016 02:46:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <10cf2879532349d29143ecbac3b459b7@SC-EXCH04.marvell.com>
References: <1466050770-21789-1-git-send-email-prasunmaiti87@gmail.com>
 <CAEO8o4=k2y4RBDFJ8RH9RF1xobWKW-zZobRFvrn8Hp8MB=L9AA@mail.gmail.com> <10cf2879532349d29143ecbac3b459b7@SC-EXCH04.marvell.com>
From: Prasun Maiti <prasunmaiti87@gmail.com>
Date: Thu, 30 Jun 2016 14:09:15 +0530
Message-ID: <CAEO8o4=_L6oYeTXMv3KYbBbhSsG3aHNhm9tqC0anVy=vfR35-A@mail.gmail.com> (sfid-20160630_114640_372765_3C68B33F)
Subject: Re: [PATCH] mwifiex: Fixed endianness for event TLV type TLV_BTCOEX_WL_SCANTIME
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 30, 2016 at 1:05 PM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Prasun,
>
>> From: Prasun Maiti [mailto:prasunmaiti87@gmail.com]
>> Sent: Friday, June 24, 2016 12:27 PM
>> To: Amitkumar Karwar; Nishant Sarmukadam; Kalle Valo
>> Cc: Linux Wireless; Linux Next; Linux Kernel
>> Subject: Re: [PATCH] mwifiex: Fixed endianness for event TLV type
>> TLV_BTCOEX_WL_SCANTIME
>>
>> On Thu, Jun 16, 2016 at 9:49 AM, Prasun Maiti <prasunmaiti87@gmail.com>
>> wrote:
>> > The two members min_scan_time and max_scan_time of structure
>> > "mwifiex_ie_types_btcoex_scan_time" are of two bytes each. The values
>> > are assigned directtly from firmware without endian conversion
>> handling.
>> > So, wrong datas will get saved in big-endian systems.
>> >
>> > This patch converts the values into cpu's byte order before assigning
>> > them into the local members.
>> >
>> > Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
>> > ---
>> >  drivers/net/wireless/marvell/mwifiex/sta_event.c | 4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c
>> > b/drivers/net/wireless/marvell/mwifiex/sta_event.c
>> > index 0104108..7dff452 100644
>> > --- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
>> > +++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
>> > @@ -474,8 +474,8 @@ void
>> mwifiex_bt_coex_wlan_param_update_event(struct mwifiex_private *priv,
>> >                         scantlv =
>> >                             (struct mwifiex_ie_types_btcoex_scan_time
>> *)tlv;
>> >                         adapter->coex_scan = scantlv->coex_scan;
>> > -                       adapter->coex_min_scan_time = scantlv-
>> >min_scan_time;
>> > -                       adapter->coex_max_scan_time = scantlv-
>> >max_scan_time;
>> > +                       adapter->coex_min_scan_time =
>> le16_to_cpu(scantlv->min_scan_time);
>> > +                       adapter->coex_max_scan_time =
>> > + le16_to_cpu(scantlv->max_scan_time);
>> >                         break;
>> >
>> >                 default:
>> > --
>> > 1.9.1
>> >
>
> Along with this change, you need to define these elements as __le16 in scan_tlv structure. Ensure that sparse compilation is passed with your final patch.
>

Hi Amitkumar,

Thanks for your suggestion.
I have added this in scan_tlv structure to fix the sparse compilation
warnings. Updated patch v2 is sent.
Please verify this.

-- 
Thanks,
Prasun
