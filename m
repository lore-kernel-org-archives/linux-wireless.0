Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:50543 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbZJ2Vdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 17:33:41 -0400
Received: by iwn10 with SMTP id 10so1701418iwn.4
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2009 14:33:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256851738.3865.149.camel@johannes.local>
References: <20091028183726.GA4952@tux> <1256761485.4237.260.camel@johannes.local>
	<43e72e890910291355l5fc4ec2ctb9a777b6e8b07baa@mail.gmail.com>
	<43e72e890910291419j7feb7a3dg33cd5b02e064eeee@mail.gmail.com>
	<1256851738.3865.149.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 29 Oct 2009 14:33:26 -0700
Message-ID: <43e72e890910291433k62e9a3a7oa15d8cc8f175bf93@mail.gmail.com>
Subject: Re: odd state reached when AP deauths you after assoc
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 29, 2009 at 2:28 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-10-29 at 14:19 -0700, Luis R. Rodriguez wrote:
>> On Thu, Oct 29, 2009 at 1:55 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>> > On Wed, Oct 28, 2009 at 1:24 PM, Johannes Berg
>> > <johannes@sipsolutions.net> wrote:
>> >> On Wed, 2009-10-28 at 11:37 -0700, Luis R. Rodriguez wrote:
>> >>> I ran into this when ath5k with wpa_supplicant with config file with
>> >>> a wrong password against a Cisco AP. It seems the Cisco AP auths you
>> >>> and lets you assoc but later it deauths you -- I guess after it
>> >>> determines you are auth credentials failed. When this happens I get:
>> >>>
>> >>> mcgrof@tux ~ $ iw dev wlan0 link
>> >>> Authenticated with 00:0b:85:5b:8d:6c (on wlan0)
>> >>> Not connected.
>> >>
>> >> I'm guessing that you're using -Dnl80211. You need this patch, or
>> >> equivalent:
>> >> http://johannes.sipsolutions.net/patches/hostap/all/2009-10-26-12%3a59/deauth-on-disassoc.patch
>> >
>> > Indeed, it fixes my woes, thanks.
>>
>> Well almost, after a while of being connected it then does this:
>>
>> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
>> CTRL-EVENT-SCAN-RESULTS
>> Trying to authenticate with 00:0b:85:5b:8d:6c (SSID='ATH-GLOBAL' freq=2462 MHz)
>> Trying to associate with 00:0b:85:5b:8d:6c (SSID='ATH-GLOBAL' freq=2462 MHz)
>> Associated with 00:0b:85:5b:8d:6c
>> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
>> CTRL-EVENT-SCAN-RESULTS
>> Trying to authenticate with 00:0b:85:5b:9a:bc (SSID='ATH-GLOBAL' freq=2412 MHz)
>> Trying to associate with 00:0b:85:5b:9a:bc (SSID='ATH-GLOBAL' freq=2412 MHz)
>> Associated with 00:0b:85:5b:9a:bc
>> CTRL-EVENT-EAP-STARTED EAP authentication started
>> CTRL-EVENT-EAP-STARTED EAP authentication started
>> CTRL-EVENT-EAP-METHOD EAP vendor 0 method 25 (PEAP) selected
>> OpenSSL: tls_connection_handshake - Failed to read possible
>> Application Data error:00000000:lib(0):func(0):reason(0)
>>
>> And I then end up with the same:
>>
>> >>> mcgrof@tux ~ $ iw dev wlan0 link
>> >>> Authenticated with 00:0b:85:5b:8d:6c (on wlan0)
>> >>> Not connected.
>
> Might be due to that bssid_changed check I was unsure about -- try
> removing that.

OK will do -- it took a while to trigger so will wait and see if it
happens again, and if it happens often enough I can at least confirm
it would fix it. Otherwise not sure what triggered it. I failed to
check the logs to see what disconnect event exactly triggered.

  Luis
