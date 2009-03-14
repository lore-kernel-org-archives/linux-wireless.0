Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:56124 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbZCNTdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 15:33:12 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1105729wfa.4
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2009 12:33:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49BBFB78.6070708@nokia.com>
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171431.11126.51242.stgit@tikku>
	 <1237051084.5235.97.camel@johannes.local> <49BBFB78.6070708@nokia.com>
Date: Sat, 14 Mar 2009 12:33:10 -0700
Message-ID: <43e72e890903141233i506328fbwc927d3d3ec06bdc9@mail.gmail.com> (sfid-20090314_203317_862323_C78C4C67)
Subject: Re: [RFC PATCH v2 1/4] mac80211: decrease execution of the associated
	timer
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 14, 2009 at 11:46 AM, Kalle Valo <kalle.valo@nokia.com> wro=
te:
> Johannes Berg wrote:
>>
>> On Sat, 2009-03-14 at 19:14 +0200, Kalle Valo wrote:
>>
>>> +void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ieee80211_hdr *hdr)
>>> +{
>>> + =C2=A0 =C2=A0 =C2=A0 /* timer triggers only when there is no unic=
ast traffic */
>>> + =C2=A0 =C2=A0 =C2=A0 if (!is_multicast_ether_addr(hdr->addr1))
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mod_timer(&sdata=
->u.mgd.timer,
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 jiffies + IEEE80211_MONITORING_INTERVAL);
>>> +}
>>
>> Do we really need the multicast check? The frame will be coming from=
 the
>> AP in managed mode in both cases, so why regard the data path as idl=
e
>> when we're receiving multicast traffic?
>
> It seems that I had a good vacation because I can't remember anymore =
why I
> added the check :D Too bad that even the comment I wrote was next to
> useless.
>
> I'll remove the multicast check because I don't see the point for it.=
 And if
> in case I finally recall the reason I'll definitely add a better comm=
ent.
>
> Thanks for all the review!

If that's the case better just remove a whole routine just for that.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
