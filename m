Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53382 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934024Ab0EUSFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 14:05:15 -0400
Received: by wyb29 with SMTP id 29so82317wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 May 2010 11:05:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274387415.1422.33.camel@localhost.localdomain>
References: <AANLkTinMa92irnw8fH8PPO6egbAVDFWBg4pCPp3dInwd@mail.gmail.com>
	 <1274387415.1422.33.camel@localhost.localdomain>
Date: Fri, 21 May 2010 14:05:12 -0400
Message-ID: <AANLkTilXnak_JDwWcx7ZqwNGEax89_Qj1YcFIH5VtecY@mail.gmail.com>
Subject: Re: How the mac80211 handle "\0" essid?
From: leo liang <leoliang9@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 20, 2010 at 4:30 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Thu, 2010-05-20 at 15:40 -0400, leo liang wrote:
>> Hi,
>>
>> Does any one know that if the application send "\0" as essid to
>> mac80211, how it handle this case?
>
> What are you trying to do?  Are you trying to work with a hidden AP, or
> do something else?

I want to hide the associated AP name.  Or disassociate and do not let
the interface connect to any AP.
>
> An SSID is simply a 32-byte array; the protocol and the stack don't care
> what's in that array.  So while you can't use command-line tools like
> 'iwconfig' to send an SSID containing a \0, you can use netlink or
> wpa_supplicant's nl80211 driver to do so.

I checked "iwconfig" source code, if you run "iwconfig wlan0 essid
off", it will set the first char as "\0".

>
> But in the end, if you're trying to associate with an AP that has an
> SSID of only '\0', that AP is likely broken or trying to hide it's SSID,
> and you should be using the real SSID of that AP instead of '\0'.
>
> Dan
>
>
>
