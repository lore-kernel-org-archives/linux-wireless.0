Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43524 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbZEKWQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 18:16:56 -0400
Received: by fxm2 with SMTP id 2so2988984fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 11 May 2009 15:16:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242050962.29777.12.camel@johannes.local>
References: <1242042898.18637.0.camel@johannes.local>
	 <1242049846.28322.12.camel@localhost.localdomain>
	 <1242050962.29777.12.camel@johannes.local>
Date: Mon, 11 May 2009 23:16:55 +0100
Message-ID: <3ace41890905111516m2d5f9f70k83edbdef1ca6e2b8@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: implement wext key handling
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	Samuel Ortiz <sameo@linux.intel.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 11, 2009 at 3:09 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-05-11 at 09:50 -0400, Dan Williams wrote:
>
>> I modified the meaning of RESTRICTED/OPEN a few years ago to control=
 the
>> WEP auth mode, for a few reasons... =A0First, some fullmac drivers a=
lready
>> used it to mean WEP auth mode. =A0Second, there was no other mechani=
sm to
>> control WEP auth mode at the time, and there were a lot of Shared Ke=
y
>> installations around. =A0Third, WE-18/WPA was nowhere near being lan=
ded,
>> and it was only supported by one driver (hostap), and it was the onl=
y
>> thing that would plausibly support WEP auth mode via SIWAUTH. =A0Fou=
rth,
>> only hostap and maybe airo really implemented the refuse-non-encoded
>> anyway.
>
> But didn't update the header file ;)
>
>> TBH, SK is nice because it tells you that the WEP key is wrong
>> *immediately*, and the only reason NM doesn't use SK by default (and
>> then fall back to OS) like the original Mac Airport drivers did is t=
hat
>> WEXT simply cannot return reliable association error information.
>
> Hah. Well, we could have that now, but I suspect SK is no longer comm=
on
> enough to put a lot of work into it.
>
>> But in the end, we still need a mechanism with WEXT to be able to se=
t SK
>> auth when associating.
>
> We still have that, with WE18, in IW_AUTH_80211_AUTH_ALG. And mac8021=
1
> never actually supported _setting_ the WEP auth mechanism with
> RESTRICTED/OPEN, only _getting_ that information.
>
> johannes
>
>

Argh, is this the reason why compat-wireless(wireless-testing?) today
doesn't quite work any more?
NetworkManager no longer wants to work, with this message in syslog:

localhost NetworkManager: <WARN>  nm_device_wifi_disable_encryption():
error setting key for device wlan2: Invalid argument

and trying to do it by hand give this error:

#iwconfig wlan2 key restrict <key>
Error for wireless request "Set Encode" (8B2A) :
    SET failed on device wlan2 ; Invalid argument.

This is v2.6.30-rc5-23297-gbf2c6a3 ; the last time I had a working
compat-wireless was only a few days (<5) ago.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
