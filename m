Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:6121 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYGGNCm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 09:02:42 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1002989ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 06:02:34 -0700 (PDT)
Message-ID: <1ba2fa240807070602jec0e924t9928ac9ffabb68a@mail.gmail.com> (sfid-20080707_150245_727587_18B959C6)
Date: Mon, 7 Jul 2008 16:02:28 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [PATCH 1/1] mac80211: Fix ieee80211_rx_reorder_ampdu: ignore QoS null packets
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <69e28c910807070537u194703a0i26d210c53436d6c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215433936-5241-1-git-send-email-tomas.winkler@intel.com>
	 <69e28c910807070537u194703a0i26d210c53436d6c2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 7, 2008 at 3:37 PM, Stefanik G=E1bor <netrolller.3d@gmail.c=
om> wrote:
> On Mon, Jul 7, 2008 at 2:32 PM, Tomas Winkler <tomas.winkler@intel.co=
m> wrote:
>> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>
>> This patch fixes the check at the entrance to ieee80211_rx_reorder_a=
mpdu.
>> This check has been broken by 511fe3f3c4ba0b5b77421336f64a19b6cd00e6=
5f
>> 'mac80211: rx.c use new helpers'
>>
>> Letting QoS NULL packet in ieee80211_rx_reorder_ampdu led to packet =
loss in
>> RX.
>>
>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> ---
>>  include/linux/ieee80211.h |   11 +++++++++++
>>  net/mac80211/rx.c         |    2 +-
>>  2 files changed, 12 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
>> index aa603c3..3865d4c 100644
>> --- a/include/linux/ieee80211.h
>> +++ b/include/linux/ieee80211.h
>> @@ -460,6 +460,17 @@ static inline int ieee80211_is_nullfunc(__le16 =
fc)
>>               cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NUL=
LFUNC);
>>  }
>>
>> +/**
>> + * ieee80211_is_nullfunc - check if FTYPE=3DIEEE80211_FTYPE_DATA an=
d
>
> Was this intended to be "ieee80211_is_qos_nullfunc - check..."?
Thanks. V2 was posted.
Tomas
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
