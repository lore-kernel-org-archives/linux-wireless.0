Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:62792 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZJ2Uzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 16:55:46 -0400
Received: by iwn10 with SMTP id 10so1676846iwn.4
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2009 13:55:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256761485.4237.260.camel@johannes.local>
References: <20091028183726.GA4952@tux> <1256761485.4237.260.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 29 Oct 2009 13:55:30 -0700
Message-ID: <43e72e890910291355l5fc4ec2ctb9a777b6e8b07baa@mail.gmail.com>
Subject: Re: odd state reached when AP deauths you after assoc
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2009 at 1:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-10-28 at 11:37 -0700, Luis R. Rodriguez wrote:
>> I ran into this when ath5k with wpa_supplicant with config file with
>> a wrong password against a Cisco AP. It seems the Cisco AP auths you
>> and lets you assoc but later it deauths you -- I guess after it
>> determines you are auth credentials failed. When this happens I get:
>>
>> mcgrof@tux ~ $ iw dev wlan0 link
>> Authenticated with 00:0b:85:5b:8d:6c (on wlan0)
>> Not connected.
>
> I'm guessing that you're using -Dnl80211. You need this patch, or
> equivalent:
> http://johannes.sipsolutions.net/patches/hostap/all/2009-10-26-12%3a59/deauth-on-disassoc.patch

Indeed, it fixes my woes, thanks.

  Luis
