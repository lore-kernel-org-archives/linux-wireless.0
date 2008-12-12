Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:39551 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbYLLWke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:40:34 -0500
Received: by wa-out-1112.google.com with SMTP id v27so797676wah.21
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 14:40:33 -0800 (PST)
Message-ID: <69e28c910812121440j6e010ac0j6e08cd6a53f58bcb@mail.gmail.com> (sfid-20081212_234038_830004_C1D87925)
Date: Fri, 12 Dec 2008 23:40:33 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC 0/3] cfg80211, mac80211: Introduce radiotap flags for finer userspace control of injection
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1229121467.3565.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910812121432k1e8732bcma77e489d247ecdf4@mail.gmail.com>
	 <1229121467.3565.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 12, 2008 at 11:37 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-12-12 at 23:32 +0100, Stefanik G=E1bor wrote:
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
>>                                  an ACK and no retrying if no ACK re=
ceived
>>    IEEE80211_RADIOTAP_F_TX_NO_SEQ: Use the sequence number already p=
resent in
>>                                  the 802.11 header, do not generate =
a new one
>>                                  in the driver/stack. Useful when in=
jecting
>>                                  fragments with the same sequence nu=
mber.
>
> Umm, these aren't really defined by radiotap yet. Does all of this ha=
ve
> to be NOW?
>
> johannes
>

No, that's why I submitted it as an RFC.

By the way, what is the preferred method of contacting the Radiotap
staff now that the mailing list seems to be permanently down?

--G=E1bor

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
