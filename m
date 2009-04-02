Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([207.115.11.52]:44885 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbZDBOpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 10:45:21 -0400
Message-ID: <49D4CF50.2060100@lwfinger.net> (sfid-20090402_164523_438210_FFFE987E)
Date: Thu, 02 Apr 2009 09:44:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: How does rfkill work?
References: <49D44635.80306@lwfinger.net> <1238666206.4141.12.camel@johannes.local>
In-Reply-To: <1238666206.4141.12.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Larry,
>=20
>> I'm having trouble getting the radio LED to work on b43legacy. When =
the LED's
>> are registered, I get LED index 0 registered with names of "b43legac=
y-phy0::tx"
>> and "b43legacy-phy0::rx", and LED index 1 with a name as of
>> "b43legacy-phy0::radio". I placed printk's at the entrance to
>> b43legacy_led_brightness_set(), which is the callback routine. I see=
 a number of
>> calls to modify LED index 0, which I assume are due to RX/TX activit=
y, but only
>> a single call for LED index 1 when the LED's are still being registe=
red. There
>> are no such calls generated when the radio switch is moved.
>>
>> I don't see where/how a particular LED is attached to the rfkill eve=
nt. Could
>> you point me to some code that does that?
>=20
> In theory, that is here:
>=20
>                 snprintf(name, sizeof(name),
>                          "b43legacy-%s::radio", wiphy_name(hw->wiphy)=
);
>                 b43legacy_register_led(dev, &dev->led_radio, name,
>                                  b43legacy_rfkill_led_name(dev),
>                                  led_index, activelow);
>=20
> I actually thought this was attached, by default, to the mac80211 rad=
io
> trigger, not the rfkill radio trigger.
>=20
> Can you check the contents of
> 	/sys/class/leds/b43legacy-...::radio/trigger
> please?

The first thing I noticed is that "radio" gets truncated to "rad", thus=
 the file
is /sys/class/leds/b43legacy-phy0\:\:rad/trigger, with contents "none i=
de-disk
ADP1-online BAT0-charging-or-full BAT0-charging BAT0-full phy0rx phy0tx
phy0assoc phy0radio [(]". I unloaded and reloaded the driver and found =
that the
"[(]" characters changed to "[=EF=BF=BDW[=EF=BF=BD]". It appears that s=
omething is putting
garbage in that file.

Larry


Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
