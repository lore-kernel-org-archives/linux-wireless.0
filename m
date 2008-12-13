Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:38382 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYLMAUO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 19:20:14 -0500
Received: by ug-out-1314.google.com with SMTP id 39so11926ugf.37
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 16:20:12 -0800 (PST)
Message-ID: <4942FFB8.4060608@gmail.com> (sfid-20081213_012027_275766_F422B4D8)
Date: Fri, 12 Dec 2008 19:20:08 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?UTF-8?B?U3RlZmFuaWsgR8OhYm9y?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 0/3] cfg80211, mac80211: Introduce radiotap flags for	finer
 userspace control of injection
References: <69e28c910812121432k1e8732bcma77e489d247ecdf4@mail.gmail.com>	 (sfid-20081212_233239_864570_76D3B7E9) <1229121467.3565.2.camel@johannes.berg>
In-Reply-To: <1229121467.3565.2.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2008-12-12 at 23:32 +0100, Stefanik G=C3=A1bor wrote:
>  =20
>> Userspace packet injector applications might want to transmit packet=
s
>> that are, by design, not supposed to be acked. In other cases, an
>> injector application may need to control the sequence number of the
>> packets it transmits. Introduce 2 new flags in the "TX flags" Radiot=
ap
>> fields, controlling these 2 behaviors.
>>
>> The new fields are as follows:
>>
>>  * IEEE80211_RADIOTAP_TX_FLAGS
>>
>>    IEEE80211_RADIOTAP_F_TX_NO_ACK: Transmit the packet once with no =
waiting for
>> 				   an ACK and no retrying if no ACK received
>>    IEEE80211_RADIOTAP_F_TX_NO_SEQ: Use the sequence number already p=
resent in
>> 				   the 802.11 header, do not generate a new one
>> 				   in the driver/stack. Useful when injecting
>> 				   fragments with the same sequence number.
>>    =20
>
> Umm, these aren't really defined by radiotap yet. Does all of this ha=
ve
> to be NOW?
>
>  =20
Is there a compelling reason to prohibit progress?

--Rick
> johannes
>  =20

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
