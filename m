Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33521 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbbE0SeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 14:34:05 -0400
Received: by lbcue7 with SMTP id ue7so13432508lbc.0
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2015 11:34:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432742132.15971.29.camel@redhat.com>
References: <55605637.1080503@gmail.com>
	<CANUX_P0OzQ45pChQxc-9WVK=7_qh6M4CcE28U6pnu5RbH-qNuQ@mail.gmail.com>
	<55650565.6020303@gmail.com>
	<1432742132.15971.29.camel@redhat.com>
Date: Wed, 27 May 2015 21:34:04 +0300
Message-ID: <CANUX_P1FohPUd4+9znUorjZi7Js=xJiX4T=G9JA504-NdgUHZQ@mail.gmail.com> (sfid-20150527_203410_133048_4E2ECA40)
Subject: Re: packet loss, disconnects and possible bug in iwlwifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Nick Dimov <dimovnike@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2015 at 6:55 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Wed, 2015-05-27 at 02:44 +0300, Nick Dimov wrote:
>> Hello,
>> thank you for your response. I attach the full syslog since the last
>> boot which contains some disconnects. I enabled debug mode for
>> wpa_supplicant with -dd option (let me know if you need anything else).
>>
>> I also tried connecting directly, i.e. without NetworkManager but
>> manually with wpa_supplicant and I still get disconnects, howvever
>> wpa_supplicant gives different logs with different drivers. Please, see
>> the file wifi.log (you can see there the driver i used in
>> wpa_supplicant, that log doesn't have the debug activated but let me
>> know if you need that too)
>
> So if NM isn't involved in your later runs (and it's not, looking at the
> logs), then I'm not sure what the issue could be except something in the
> driver.
>
> mai 27 02:31:54 nick-G55VW wpa_supplicant[1565]: nl80211: Event message
> available
> mai 27 02:31:54 nick-G55VW wpa_supplicant[1565]: nl80211: Drv Event 20
> (NL80211_CMD_DEL_STATION) received for wlan5
> mai 27 02:31:54 nick-G55VW wpa_supplicant[1565]: nl80211: Delete station
> d8:50:e6:da:1d:b4
> mai 27 02:31:54 nick-G55VW kernel: wlan5: deauthenticating from
> d8:50:e6:da:1d:b4 by local choice (Reason: 3=DEAUTH_LEAVING)
>
> I don't see anything interesting around those lines, so I guess its up
> to Emmanuel now...  the tracing he requests would be good to get.
>

I suspect a regulatory problem. This is why I asked what was the
channel used on 2.4GHz. On 5.2GHz we have seen bugs happening because
of the regulatory database being ancient on Ubuntu. 2.4GHz should rule
these problems out, unless we are talking about channel 12 and up or
something like that.
