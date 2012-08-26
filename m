Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56720 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2HZIgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 04:36:36 -0400
Received: by obbuo13 with SMTP id uo13so6647238obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Aug 2012 01:36:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345969836.3622.4.camel@jlt4.sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	<1345800585.4503.8.camel@jlt3.sipsolutions.net>
	<CAB3XZEcnVxiBkSz4ZMYSqWF55BYBcDgF7tZsRRXoD91unVrAww@mail.gmail.com>
	<1345968623.3622.3.camel@jlt4.sipsolutions.net>
	<CAB3XZEfTEz5U0Tu7H-S0ZzDZvUMBdfMgjx6+oS3yF+LaudznjA@mail.gmail.com>
	<1345969836.3622.4.camel@jlt4.sipsolutions.net>
Date: Sun, 26 Aug 2012 11:36:35 +0300
Message-ID: <CAB3XZEf-pVXEC+QF61ZNHjt=XSkyGPdNG6egjVoJ-MVymTye=w@mail.gmail.com> (sfid-20120826_103737_546147_B1D1B332)
Subject: Re: [RFC 00/20] mac80211: multi-channel work
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 26, 2012 at 11:30 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2012-08-26 at 11:28 +0300, Eliad Peller wrote:
>
>> >> this scenario (deauth after disassoc) also sounds pretty unlikely...
>> >
>> > It seems that it happens when you ask the supplicant to "disconnect" via
>> > the CLI.
>> >
>> at least in my setup issuing a "disconnect" via the CLI ends only with
>> a deauth (as the respective code in wpa_supplicant/ctrl_iface.c seems
>> to call only wpa_supplicant_deauthenticate())
>
> Hm. Maybe it was removing the interface then, or something. I don't
> remember, but Ilan said he had a way to trigger this.
>
> In any case, it seems we should handle it in some way?
>
well, it sounds rare enough to me.
maybe we can/should just drop it in this case (if there is no channel
context attached)?

Eliad.
