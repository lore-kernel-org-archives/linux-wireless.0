Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:34099 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3IJOPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 10:15:22 -0400
Received: by mail-ie0-f178.google.com with SMTP id to1so5554142ieb.23
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 07:15:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378804510.4799.69.camel@porter.coelho.fi>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	<1378218848-7853-6-git-send-email-eliad@wizery.com>
	<1378795636.4799.44.camel@porter.coelho.fi>
	<CA+XVXfc6RG1BngT_+doiOUhtYAgnG9Q0-oXns-ckJkU7XhE5ag@mail.gmail.com>
	<1378804510.4799.69.camel@porter.coelho.fi>
Date: Tue, 10 Sep 2013 16:15:21 +0200
Message-ID: <CAB3XZEfPQb1FWT3wukBZvSkP9eB1kO=wPpWFxKXBmX5YULAVqw@mail.gmail.com> (sfid-20130910_161541_532754_C1FC6363)
Subject: Re: [PATCH 06/12] wlcore: send EAPOL frames with voice priority
From: Eliad Peller <eliad@wizery.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 12:15 PM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2013-09-10 at 11:11 +0200, Arik Nemtsov wrote:
>> On Tue, Sep 10, 2013 at 9:47 AM, Luca Coelho <luca@coelho.fi> wrote:
>> > On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
>> >> From: Igal Chernobelsky <igalc@ti.com>
>> >>
>> >> Send EAPOL frames with voice priority by setting TX_HW_ATTR_EAPOL_FRAME
>> >> new bit in tx attribute. Sending EAPOL with voice priority fixes
>> >> re-key timeout during heavy traffic issue.
>> >>
>> >> Signed-off-by: Igal Chernobelsky <igalc@ti.com>
>> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> >> ---
>> >
>> > This seems to be the same problem that Ben had and debugged by himself
>> > [1].  Fixing this in hostapd/wpa_supplicant seems more appropriate?
>> >
>> > This patch seems to take an advantage of some sort of hack in the
>> > firmware that will change the priority by itself when the
>> > TX_HW_ATTR_EAPOL_GRAME bit is set.  If we have a good reason to use this
>> > patch, we need to take care of the firmware version as well.  This
>> > probably doesn't work with the latest published firmware.
>> >
>> > [1] http://mid.gmane.org/522E18E5.1020503@candelatech.com
>>
>> I believe he only fixed one mode (AP - hostapd) but not the other (GO
>> - wpa_supplicant). Anyway that's what we tested at the time.
>
> Okay, I didn't dig much into it.
>
>
>> Anyway marking it as this level doesn't do any harm. You're right
>> about the FW version though - it should be upstreamed first.
>
> Fair enough.  If the firmware implements this, no reason why not use it.
> But I'll wait for the new firmware before applying this.
>
this change is backward compatible, so there's no issue applying it as is.
however, if you prefer waiting for a newer fw that's fine too.
i'll add it to the waiting list :)

Eliad.
