Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50390 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbZDCFJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 01:09:50 -0400
Received: by fxm2 with SMTP id 2so811714fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 02 Apr 2009 22:09:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238733474.19390.2.camel@violet>
References: <49D44635.80306@lwfinger.net> <49D4D833.9070107@lwfinger.net>
	<1238689637.24708.41.camel@johannes.local> <49D5018E.6050001@lwfinger.net>
	<1238696967.6137.5.camel@johannes.local> <49D506FE.5070405@lwfinger.net>
	<1238698084.7630.3.camel@johannes.local> <1238698667.7630.7.camel@johannes.local>
	<49D521BF.2080301@lwfinger.net> <1238733474.19390.2.camel@violet>
Date: Fri, 3 Apr 2009 07:09:32 +0200
Message-ID: <ac3eb2510904022209q2826cb32k1caef88b80ed11d8@mail.gmail.com> (sfid-20090403_070955_456637_1090DF8F)
Subject: Re: How does rfkill work?
From: Kay Sievers <kay.sievers@vrfy.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 3, 2009 at 06:37, Marcel Holtmann <marcel@holtmann.org> wro=
te:
>> > On Thu, 2009-04-02 at 20:48 +0200, Johannes Berg wrote:
>> >
>> > Could you try something for me?
>> >
>> > In drivers/leds/led-triggers.c in led_trigger_show you have
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(trig, &trigger_lis=
t, next_trig) {
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(KERN_DEBUG "available =
trigger: %s\n", trig->name);
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (led_cd=
ev->trigger && !strcmp(led_cdev->trigger->name,
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 trig->name))
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 len +=3D sprintf(buf+len, "[%s] ", trig->name);
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 len +=3D sprintf(buf+len, "%s ", trig->name);
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> >
>> > could you do the modification, with a kernel that has the TRIG_NAM=
E_MAX
>> > set to 50, and see what it prints? I'm completely confused by this
>> > failure mode since the garbage you get is actually put into bracke=
ts, so
>> > it seems the strcmp() is returning 0 which seems odd.
>>
>> Have I told you that I hate things that appear to be intermittent?
>>
>> I added the printk, returned TRIG_NAME_MAX to 50, rebuilt and reboot=
ed. This
>> time I got
>>
>> ~/wireless-testing> cat /sys/class/leds/b43legacy-phy0\:\:rad/trigge=
r
>> none ide-disk ADP1-online BAT0-charging-or-full BAT0-charging BAT0-f=
ull phy0rx
>> phy0tx phy0assoc phy0radio [rfkill0]
>> ~/wireless-testing> dmesg | grep available
>> available trigger: ide-disk
>> available trigger: ADP1-online
>> available trigger: BAT0-charging-or-full
>> available trigger: BAT0-charging
>> available trigger: BAT0-full
>> available trigger: phy0rx
>> available trigger: phy0tx
>> available trigger: phy0assoc
>> available trigger: phy0radio
>> available trigger: rfkill0
>>
>> I'll leave the printk in place for the moment.
>>
>> The name is being truncated by "#define BUS_ID_SIZE 20" in
>> include/linux/device.h. As changing that define would be pretty inva=
sive, I plan
>> to use a shorter name when the LED is registered.
>
> I am under the impression that all these limitations are going away. =
Did
> you talk to Kay or Greg about this?

The limit is already gone in the current tree:
  http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commitdiff;h=3D1fa5ae857bb14f6046205171d98506d8112dd74e

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
