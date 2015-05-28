Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35810 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbbE1Auj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 20:50:39 -0400
Received: by wgme6 with SMTP id e6so23156888wgm.2
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2015 17:50:38 -0700 (PDT)
Message-ID: <5566665B.3060703@gmail.com> (sfid-20150528_025046_231307_5E5EF551)
Date: Thu, 28 May 2015 03:50:35 +0300
From: Nick Dimov <dimovnike@gmail.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: packet loss, disconnects and possible bug in iwlwifi
References: <55605637.1080503@gmail.com>		<CANUX_P0OzQ45pChQxc-9WVK=7_qh6M4CcE28U6pnu5RbH-qNuQ@mail.gmail.com>		<55650565.6020303@gmail.com>	<1432742132.15971.29.camel@redhat.com>	 <CANUX_P1FohPUd4+9znUorjZi7Js=xJiX4T=G9JA504-NdgUHZQ@mail.gmail.com>	 <55661EFC.30606@gmail.com> <1432760563.15971.37.camel@redhat.com>
In-Reply-To: <1432760563.15971.37.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
Yes,I use 5Ghz and I'm aware of dynamic rate scaling (i monitored it
with iwconfig before). It's just no matter how I load it i never shows
speeds more than 520mbps (very rarely i get 600 but it doesn't last even
1 second). I load it with iperf and the max *real* speed I get is about
240mbps in TCP mode. Under Windows 7, I can see 866mbps when there is load.

Is there a reason why it avoids speeds bigger than 520mbps? Also is it
normal to get only half of the connection speed with iperf?
Regards,
Nick.

On 28.05.2015 00:02, Dan Williams wrote:
> On Wed, 2015-05-27 at 22:46 +0300, Nick Dimov wrote:
>> Hello everyone.
>> I updated the regulatory database from here
>> https://www.kernel.org/pub/software/network/wireless-regdb/ (just copied
>> the regulatory.bin and the public key) and the problem is gone! Thank to
>> all of you and especially to Emmanuel Grumbach for suggesting this.
>>
>> Now another question - how to make it connect at 866mbps or at least
>> something close to it? Any ideas?
> iwlwifi does dynamic rate scaling, so you'll almost never see 866mbps.
> When traffic is idle it drops back to 1mbit rates and then when traffic
> starts, scales up from there.  Also, I'm pretty sure you'll never get
> 866mbps in the 2.4GHz band due to lack of bandwidth there, you'll have
> to go 5GHz for that.
>
> Use "iw dev <ifname> link" to see the current rate.
>
> Dan
>
>> Thanks you,
>> Nick.
>>
>> On 27.05.2015 21:34, Emmanuel Grumbach wrote:
>>> On Wed, May 27, 2015 at 6:55 PM, Dan Williams <dcbw@redhat.com> wrote:
>>>> On Wed, 2015-05-27 at 02:44 +0300, Nick Dimov wrote:
>>>>> Hello,
>>>>> thank you for your response. I attach the full syslog since the last
>>>>> boot which contains some disconnects. I enabled debug mode for
>>>>> wpa_supplicant with -dd option (let me know if you need anything else).
>>>>>
>>>>> I also tried connecting directly, i.e. without NetworkManager but
>>>>> manually with wpa_supplicant and I still get disconnects, howvever
>>>>> wpa_supplicant gives different logs with different drivers. Please, see
>>>>> the file wifi.log (you can see there the driver i used in
>>>>> wpa_supplicant, that log doesn't have the debug activated but let me
>>>>> know if you need that too)
>>>> So if NM isn't involved in your later runs (and it's not, looking at the
>>>> logs), then I'm not sure what the issue could be except something in the
>>>> driver.
>>>>
>>>> mai 27 02:31:54 nick-G55VW wpa_supplicant[1565]: nl80211: Event message
>>>> available
>>>> mai 27 02:31:54 nick-G55VW wpa_supplicant[1565]: nl80211: Drv Event 20
>>>> (NL80211_CMD_DEL_STATION) received for wlan5
>>>> mai 27 02:31:54 nick-G55VW wpa_supplicant[1565]: nl80211: Delete station
>>>> d8:50:e6:da:1d:b4
>>>> mai 27 02:31:54 nick-G55VW kernel: wlan5: deauthenticating from
>>>> d8:50:e6:da:1d:b4 by local choice (Reason: 3=DEAUTH_LEAVING)
>>>>
>>>> I don't see anything interesting around those lines, so I guess its up
>>>> to Emmanuel now...  the tracing he requests would be good to get.
>>>>
>>> I suspect a regulatory problem. This is why I asked what was the
>>> channel used on 2.4GHz. On 5.2GHz we have seen bugs happening because
>>> of the regulatory database being ancient on Ubuntu. 2.4GHz should rule
>>> these problems out, unless we are talking about channel 12 and up or
>>> something like that.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

