Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([204.127.217.104]:38019 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759987AbZDBPXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 11:23:16 -0400
Message-ID: <49D4D833.9070107@lwfinger.net> (sfid-20090402_172321_919980_B05D83F6)
Date: Thu, 02 Apr 2009 10:22:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: How does rfkill work?
References: <49D44635.80306@lwfinger.net>	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net> <1238684527.4141.63.camel@johannes.local>
In-Reply-To: <1238684527.4141.63.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2009-04-02 at 09:44 -0500, Larry Finger wrote:
>=20
>>> Can you check the contents of
>>> 	/sys/class/leds/b43legacy-...::radio/trigger
>>> please?
>> The first thing I noticed is that "radio" gets truncated to "rad", t=
hus the file
>> is /sys/class/leds/b43legacy-phy0\:\:rad/trigger,
>=20
> Cute. Must be that the limit is 20 bytes (19+NUL) in the buffer it us=
es
> in led core code.
>=20
>>  with contents "none ide-disk
>> ADP1-online BAT0-charging-or-full BAT0-charging BAT0-full phy0rx phy=
0tx
>> phy0assoc phy0radio [(]". I unloaded and reloaded the driver and fou=
nd that the
>> "[(]" characters changed to "[=EF=BF=BDW[=EF=BF=BD]". It appears tha=
t something is putting
>> garbage in that file.
>=20
> Ouch. That's bad. I'll try to figure it out. I don't see how my patch
> changes this -- does this happen without my patch too?

Without your "rfkill rewrite" patch, but with "rfkill-remove-unused-cod=
e",
"rfkill-remove-deprecated", and "rfkill-remove-user-claim" patches, the=
 file
/sys/class/..../trigger contains "none ide-disk BAT0-charging-or-full
BAT0-charging BAT0-full ADP1-online phy0rx phy0tx phy0assoc phy0radio [=
rfkill0]"

Now I know what should be inside the [].

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
