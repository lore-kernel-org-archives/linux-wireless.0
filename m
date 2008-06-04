Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:9254 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbYFDXHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 19:07:19 -0400
Received: by wa-out-1112.google.com with SMTP id j37so197036waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2008 16:07:17 -0700 (PDT)
Message-ID: <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com> (sfid-20080605_010724_849529_FF21DFFB)
Date: Thu, 5 Jun 2008 02:07:17 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, "Dmitry Torokhov" <dtor@mail.ru>
In-Reply-To: <1212611246.4018.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
	 <1212549017-30144-2-git-send-email-hmh@hmh.eng.br>
	 <1212611246.4018.12.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 4, 2008 at 11:27 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Wed, 2008-06-04 at 00:10 -0300, Henrique de Moraes Holschuh wrote:
>> rfkill really should have been named rfswitch.  As it is, one can get
>> confused whether RFKILL_STATE_ON means the KILL switch is on (and
>> therefore, the radio is being *blocked* from operating), or whether it
>> means the RADIO rf output is on.
>>
>> Clearly state that RFKILL_STATE_ON means the radio is *unblocked* from
>> operating (i.e. there is no rf killing going on).
>
> Looking over the rfkill stuff again, I think we have a problem.  There
> are actually 3 states for each radio:
>
> a) radio on
> b) radio off, softkilled by NM, user, or whatever
> c) radio off, hardkilled by a physical switch
>
> I don't think that the rfkill layer can represent this, since the
> 'state' member of /sys/class/rfkill/rfkillX is only 0 or 1.  You should
> be able to simulate state (b) by doing "iwconfig wlan0 txpower off".  If
> the driver doesn't suck, the driver should then rfkill the radio (and
> thus /sys/class/rfkill/rfkill0/state would be 0), but all killswitches
> are still "on".  But there's no way to find out that the killswitches
> are all "on" by reading something in sysfs because their state is not
> distinct from the radio's state.
>
> There are basically two options here:
>
> 1) separate switch state from radio state by having something on the
> _device_
> like /sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0/radio_state that
> is 0 (radio on), 1 (radio off, softkilled), or 2 (radio off,
> hardkilled).  Keep /sys/class/rfkill/rfkillX as actual killswitches as
> reported by wireless drivers or by machine-specific BIOS proxy drivers
> like hp-wmi, and keep the 'state' member rfkillX devices like it is now
>
> 2) Change the 'state' member of the /sys/class/rfkill/rfkillX devices to
> reflect the hardkill and softkill
>
> I personally like (1) the best, because there's a clear difference
> between radio state and switch state, and it would preserve
> compatibility with the current rfkill system.  If the userspace process
> doesn't see the 'radio_state' item in sysfs for that specific wireless
> device, it would fall back to using only /sys/class/rfkill/rfkill0/state
> and loose the ability to handle softkill.
>
SW should be able to more sw radio switch regardless of hw switch so
I believe it's better to have separate sysfs entry for sw and hw switch states.
hw sysfs file should be read only.

I agree it good to keep radio state separately as well.

Third I think this patch use opposite logic as used currently in
practice. RFKILL_ON means that radio is off .

Thanks
Tomas


> Thoughts?
>
> Dan
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
