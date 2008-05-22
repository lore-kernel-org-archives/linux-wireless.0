Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:45083 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYEVTTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 15:19:35 -0400
Received: by el-out-1112.google.com with SMTP id s27so147559ele.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 12:19:34 -0700 (PDT)
Message-ID: <1ba2fa240805221219i36f7889cs439802c60a54dcb2@mail.gmail.com> (sfid-20080522_211938_715330_42C3ED61)
Date: Thu, 22 May 2008 22:19:33 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: JMF <tolas_feup@hotmail.com>
Subject: Re: [PATCH] mac80211: do not alter injected seq numbers
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20080522T185920-107@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47FAB829.9010304@latinsud.com> <200804081025.39645.mb@bu3sch.de>
	 <loom.20080522T171937-155@post.gmane.org>
	 <69e28c910805221115g6290e5e9nef4444efca07aea@mail.gmail.com>
	 <69e28c910805221121v1a34901co35ec41bff41bd1ec@mail.gmail.com>
	 <1211481278.3698.58.camel@johannes.berg>
	 <loom.20080522T185920-107@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2008 at 10:09 PM, JMF <tolas_feup@hotmail.com> wrote:
> Johannes Berg <johannes@...> writes:
>
>>
>> > >> This does not work, since we use injection for other types of
>> > >>  frames. For example management frames from hostapd. We don't want
>> > >>  (and can't) make hostapd keep track of sequence numbers.
>> > >> You'll have to contact radiotap people and add a flag for this.
>> > >>  This would also solve the hardware counter problem then.
>>
>> > The flag is IEEE80211_TX_INJECTED. Here is a new patch, for the
>> > current wireless-testing:
>
>
> Are you really sure the flag is IEEE80211_TX_INJECTED?
> For the current (today, 22 May) wireless-testing, it seems it's been
>  renamed to IEEE80211_TX_CTL_INJECTED. Also, not tx->flags anymore, but
>  info->flags instead.
> Can you confirm that?
>
>
> I was going to say something else, but I saw another post by Johannes... Strange
> that hostapd uses injection in monitor mode interfaces, I thought it would be
> only  AP mode interfaces.
> And it is also strange that iwlwifi developers wanted to disallow injection in
> monitor mode, with hostapd apparently needing it!

On behalf of iwlwifi, this is legacy behavior that wasn't treated for
a,b,c reasons.
There used to be management interface that was used by hostapd and
monitor interface was used for sniffing.  So with wanting or not
wanting it is actually all around.

Tomas

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
