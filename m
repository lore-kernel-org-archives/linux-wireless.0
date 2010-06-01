Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60377 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab0FAN30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 09:29:26 -0400
Received: by wyi11 with SMTP id 11so959283wyi.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 06:29:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274739877.19662.39.camel@localhost.localdomain>
References: <AANLkTinMa92irnw8fH8PPO6egbAVDFWBg4pCPp3dInwd@mail.gmail.com>
	<1274387415.1422.33.camel@localhost.localdomain>
	<AANLkTilXnak_JDwWcx7ZqwNGEax89_Qj1YcFIH5VtecY@mail.gmail.com>
	<1274739877.19662.39.camel@localhost.localdomain>
Date: Tue, 1 Jun 2010 09:29:18 -0400
Message-ID: <AANLkTimdDehMCo2cmEsgq2dDqDyjxYWrIQdw96EPXJrC@mail.gmail.com>
Subject: Re: How the mac80211 handle "\0" essid?
From: leo liang <leoliang9@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for the answer.

On Mon, May 24, 2010 at 6:24 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Fri, 2010-05-21 at 14:05 -0400, leo liang wrote:
>> On Thu, May 20, 2010 at 4:30 PM, Dan Williams <dcbw@redhat.com> wrote:
>> > On Thu, 2010-05-20 at 15:40 -0400, leo liang wrote:
>> >> Hi,
>> >>
>> >> Does any one know that if the application send "\0" as essid to
>> >> mac80211, how it handle this case?
>> >
>> > What are you trying to do?  Are you trying to work with a hidden AP, or
>> > do something else?
>>
>> I want to hide the associated AP name.  Or disassociate and do not let
>> the interface connect to any AP.
>
> "I want to hide the associated AP name"
>
> What do you mean by this?  Do you mean make 'iwconfig' or some other
> program not report the currently associated AP name?  Or do you mean
> something else?
>
> "Or disassociate and do not let..."
>
> For complete disassociation, you don't need to send an empty BSSID when
> using nl80211, just send the disassociate command using nl80211 (in
> code) or the 'iw' command.  When using WEXT (which is the older
> predecessor of nl80211) you need to send a random SSID (ie, 32 random
> ascii characters for example) not including \0.  That should cause
> devices to disassociate from the AP and not attempt to reconnect to it
> until you send a new, valid SSID.
>
>> >
>> > An SSID is simply a 32-byte array; the protocol and the stack don't care
>> > what's in that array.  So while you can't use command-line tools like
>> > 'iwconfig' to send an SSID containing a \0, you can use netlink or
>> > wpa_supplicant's nl80211 driver to do so.
>>
>> I checked "iwconfig" source code, if you run "iwconfig wlan0 essid
>> off", it will set the first char as "\0".
>
> Right, iwconfig is pretty old and does not correctly handle empty
> BSSIDs.  Don't depend on the iwconfig behavior.
>
> Dan
>
>> >
>> > But in the end, if you're trying to associate with an AP that has an
>> > SSID of only '\0', that AP is likely broken or trying to hide it's SSID,
>> > and you should be using the real SSID of that AP instead of '\0'.
>> >
>> > Dan
>> >
>> >
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
