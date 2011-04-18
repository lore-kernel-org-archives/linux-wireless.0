Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47382 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1DRH3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 03:29:30 -0400
Received: by vws1 with SMTP id 1so3278500vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 00:29:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110415163443.GH23532@jm.kir.nu>
References: <BANLkTimEipE8q-ehYFrXpVqHRSHrCcZxXw@mail.gmail.com>
	<20110415163443.GH23532@jm.kir.nu>
Date: Mon, 18 Apr 2011 09:29:29 +0200
Message-ID: <BANLkTikM0p1aJA2DsS2-pCi2O80rwtTmqQ@mail.gmail.com>
Subject: Re: WPA2 Access Point (HostAPD) authentication with Samsung Galaxy
 Tab fails.
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: hostap@lists.shmoo.com, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Apr 15, 2011 at 6:34 PM, Jouni Malinen <j@w1.fi> wrote:
> On Fri, Apr 15, 2011 at 12:54:28PM +0200, Juan Carlos Garza wrote:
>> I am having trouble to authenticate a Samsung Galaxy Tab with an AP on
>> a rt3070 usb device. The specifics follow...
>
>> However, I am trying to authenticate with a Samsung Galaxy Tab with
>> Android 2.2 on it, and I get the following log:
>
>> mgmt::auth
>> authentication: STA=bc:47:60:93:74:bd auth_alg=0 auth_transaction=1
>> wlan0: STA bc:47:60:93:74:bd IEEE 802.11: authentication OK (open system)
>> authentication reply: STA=bc:47:60:93:74:bd auth_alg=0
>> mgmt::assoc_req
>> association request: STA=bc:47:60:93:74:bd capab_info=0x431 listen_interval=10
>> unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
>>   new AID 2
>> HT: STA bc:47:60:93:74:bd HT Capabilities Info: 0x182c
>> wlan0: STA bc:47:60:93:74:bd IEEE 802.11: association OK (aid 2)
>> mgmt::auth cb
>> wlan0: STA bc:47:60:93:74:bd IEEE 802.11: authenticated
>
> Huh... That rt3070 device or driver sure takes long to deliver the TX
> status information.
>
>> Data/PS-poll frame from not associated STA bc:47:60:93:74:bd
>> mgmt::assoc_resp cb
>
> And since the station you are using here seems to send some Data frames
> quickly after the association, it happens to hit a race condition
> between the association response TX status callback and first Data frame
> being received. This in turn makes hostapd disassociate the station
> since from its view point, the station tried to send a Data frame while
> it had not yet completed association.
>
> You can now find a workaround for this in the current development branch
> for hostapd:
> http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=commitdiff;h=b8281964afb1df98135418fc22a9fa240968d100


Thanks a lot, I am currently testing the patched 0.7.3 and now
authentications are successful.

>
> --
> Jouni Malinen                                            PGP id EFC895FA
>

Regards,
Juan Carlos Garza Fernández
