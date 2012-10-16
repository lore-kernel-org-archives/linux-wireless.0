Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4024 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab2JPNAn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 09:00:43 -0400
Message-ID: <507D5A51.3040400@broadcom.com> (sfid-20121016_150047_006017_7317413A)
Date: Tue, 16 Oct 2012 15:00:01 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "David Shwatrz" <dshwatrz@gmail.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: Question about ieee802_1d_to_ac
References: <CAJJAcodOQY6PDp6d=jG30u_7B30G3j8xOrtLQVmEJ4TDYjh_xQ@mail.gmail.com>
In-Reply-To: <CAJJAcodOQY6PDp6d=jG30u_7B30G3j8xOrtLQVmEJ4TDYjh_xQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/16/2012 10:04 AM, David Shwatrz wrote:
> Hello,
>
> I see in net/mac80211/wme.c:
> ...
> const int ieee802_1d_to_ac[8] = {
> 	IEEE80211_AC_BE,
> 	IEEE80211_AC_BK,
> 	IEEE80211_AC_BK,
> 	IEEE80211_AC_BE,
> 	IEEE80211_AC_VI,
> 	IEEE80211_AC_VI,
> 	IEEE80211_AC_VO,
> 	IEEE80211_AC_VO
> };
> ...

This is the correct mapping if you want to trust the IEEE802.11e 
standard (Table 20i).

Gr. AvS

> As I understand, this values stand for queues for different types of traffic:
> IEEE80211_AC_BE is  best-effort traffic ,
> IEEE80211_AC_BK is background traffic ,
> IEEE80211_AC_VI is video traffic,
> IEEE80211_AC_VO is voice traffic.
>
> We see that entries 6,7 are  voice and entries 4,5 are video.
> Is it not an error that entries 2,3 differ ? and also 0,1 ?
>
> shouldn't it be:
> const int ieee802_1d_to_ac[8] = {
> 	IEEE80211_AC_BE,
> 	IEEE80211_AC_BE,
> 	IEEE80211_AC_BK,
> 	IEEE80211_AC_BK,
>
>
> Regards,
> D Shwartz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


