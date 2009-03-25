Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:62133 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbZCYPiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 11:38:15 -0400
Received: by bwz17 with SMTP id 17so94384bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 08:38:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1ba2fa240902151240v3bbe2885l4ef4d90e5d78b0a7@mail.gmail.com>
References: <20090213105306.GA18754@jm.kir.nu>
	 <1234522804.4219.13.camel@johannes.local>
	 <20090213111523.GA22438@jm.kir.nu>
	 <1ba2fa240902150509i5df08adcg214901548d3cd538@mail.gmail.com>
	 <20090215154408.GA6845@jm.kir.nu>
	 <1ba2fa240902151240v3bbe2885l4ef4d90e5d78b0a7@mail.gmail.com>
Date: Wed, 25 Mar 2009 17:38:11 +0200
Message-ID: <1ba2fa240903250838qab8acb1v3abffe06c5384d13@mail.gmail.com> (sfid-20090325_163817_490991_59134859)
Subject: Re: [PATCH] nl80211: Optional IEs into scan request
From: Tomas Winkler <tomasw@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 15, 2009 at 10:40 PM, Tomas Winkler <tomasw@gmail.com> wrot=
e:
> On Sun, Feb 15, 2009 at 5:44 PM, Jouni Malinen <j@w1.fi> wrote:
>> On Sun, Feb 15, 2009 at 03:09:15PM +0200, Tomas Winkler wrote:
>>> Status questions
>>> What is the version of wpa_supplicant that supports WPS. =C2=A0Is w=
ext
>>> covered with IWEVGENIE?
>>
>> wpa_supplicant 0.6.7 and newer has support for WPS, but there are so=
me
>> bug fixes since then, so 0.6.8 is likely a better starting point. we=
xt
>> works for most parts, but there is no support for adding WPS IE into
>> Probe Request with it (cfg80211/nl80211 needed for this). Anyway, th=
at
>> part of the protocol is optional, so it should not cause major probl=
ems.

After reading the WPS spec again and specifically the section 10.3
that talks about PBC, it looks like for PBC you will need to have the
WPS IE in the Probe request for it to function correctly. So it
doesn't look optional to mee

The WPS IE in the Probe Request will indicate that the device is in
PBC mode. The WPS IE is also used for Registrars to see if multiple
requests were received within the PBC Monitor time.

Am I missing something ?

Quoting:
'
The Enrollee performs this scan by sending out probe requests with a
Device Password ID indicating that
the Enrollee is in PBC mode and receiving probe responses indicating a
Selected Registrar with a PBC
Device Password ID. During this scan, the Enrollee MUST abort its
connection attempt and signal a
=E2=80=9Csession overlap=E2=80=9D error to the user if it discovers mor=
e than one
Registrar in PBC mode.
=E2=80=A6..
The button press or equivalent trigger event on the Registrar causes
it to first check whether more than
one Enrollee PBC probe request has been received by the Registrar. The
Registrar must examine whether
such a request has been received within 120 seconds prior to the PBC
button press on the Registrar. This
window is called the PBC Monitor Time. If more than one Enrollee PBC
probe request has been received
within the Monitor Time interval, the Registrar MUST signal a session
overlap=E2=80=9D error
'

Thanks
Tomas
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
