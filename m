Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:4066 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZCXU60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 16:58:26 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2737853yxl.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 13:58:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237928031.4320.133.camel@johannes.local>
References: <c03d7e680903240959s51aa4864uaad281bd7487e823@mail.gmail.com>
	 <871vsmrekh.fsf@litku.valot.fi>
	 <c03d7e680903241348x27363902m764c25a9a439d419@mail.gmail.com>
	 <1237928031.4320.133.camel@johannes.local>
Date: Tue, 24 Mar 2009 16:58:23 -0400
Message-ID: <c03d7e680903241358ya809dabhcc75eeca14782ff3@mail.gmail.com> (sfid-20090324_215827_803135_B1863E1C)
Subject: Re: Adhoc-demo support in mac80211
From: ming li <mingli@cs.umass.edu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, I have to disable beaconing. Is there any easy way to disable
them? Will this confuse the state machine in mac80211?

BTW, even if you do "iwconfig wlan0 ap..." the IBSS domain still might
split when the link loss rate is high, right?

On Tue, Mar 24, 2009 at 4:53 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-03-24 at 16:48 -0400, ming li wrote:
>
>> The adhoc-demo mode is also called pseudo-adhoc mode. It is simply t=
he
>> ad-hoc mode without control pkts. It does not probe for or associate
>> to adjacent adhoc networks. The user has to set all the nodes to the
>> same channel manually. The good thing of adhoc-demo is that it does
>> not have the beaconing overhead or the IBSS merging/splitting proble=
m.
>
> Do you really need to disable beaconing, or would it be sufficient fo=
r
> you to just fix the BSSID and the channel? You can do those two alrea=
dy
> easily, something like
> =A0 =A0 =A0 =A0iwconfig wlan0 ap ...
> =A0 =A0 =A0 =A0iwconfig wlan0 channel ...
>
> johannes
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
