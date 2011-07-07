Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61652 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1GGFMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 01:12:44 -0400
Received: by wyg8 with SMTP id 8so387290wyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 22:12:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110706182937.GE28091@alittletooquiet.net>
References: <20110701173237.GC7125@alittletooquiet.net>
	<20110704052410.GA1364@vmraj-lnx.users.atheros.com>
	<20110704095341.GA1380@vmraj-lnx.users.atheros.com>
	<20110705124914.GC26882@alittletooquiet.net>
	<CAD2nsn0-FQuo7bT3nb3jJLDe1XwbMw4J-Gr8qFkY5zzY1O-vxg@mail.gmail.com>
	<20110705143029.GA28091@alittletooquiet.net>
	<CAD2nsn1r7cW7KZ2W_z+SURHRpaTvuC_bd42yN9S+y9JrYMkS4w@mail.gmail.com>
	<20110705172022.GB28091@alittletooquiet.net>
	<20110706023943.GA11178@vmraj-lnx.users.atheros.com>
	<CAD2nsn0HFgm6Puuzuy4gghdDvpb05WaQtETS4=mfQ63mFzo--Q@mail.gmail.com>
	<20110706182937.GE28091@alittletooquiet.net>
Date: Thu, 7 Jul 2011 10:42:42 +0530
Message-ID: <CAD2nsn3x5sfhTuzH66myCF0P2PyHoX+pqVkYgWC5ogssPdHsqw@mail.gmail.com> (sfid-20110707_071300_111753_386D011B)
Subject: Re: ath9k_htc fails to initialize TL-WN721N with compat-wireless 3.0-rc4-1
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 6, 2011 at 11:59 PM, Forest Bond <forest@alittletooquiet.net> wrote:
> Hi shafi,
>
> On Wed, Jul 06, 2011 at 03:58:13AM -0400, Mohammed Shafi wrote:
>> > To avoid multi reg writes please apply the following change
>> >
>> > diff --git a/drivers/net/wireless/ath/ath9k/wmi.h
>> > b/drivers/net/wireless/ath/ath9k/wmi.h
>> > index fde6da6..0878add 100644
>> > --- a/drivers/net/wireless/ath/ath9k/wmi.h
>> > +++ b/drivers/net/wireless/ath/ath9k/wmi.h
>> > @@ -124,7 +124,7 @@ enum wmi_event_id {
>> >        WMI_TXSTATUS_EVENTID,
>> >         };
>> >
>> >          -#define MAX_CMD_NUMBER 62
>> >          +#define MAX_CMD_NUMBER 1
>> >
>> >            struct register_write {
>> >                    __be32 reg;
>> > --
>>
>> did you try in your system the simple hack Raj had suggested?
>> it seems to solve ths issue, but we encountered some soft lock ups due
>> to the LED stuff is moved to mac80211 with the recent code base,
>> we will take a look at this to fix this, probably requires some backporting.
>
> Yes, the device seems to initialize properly with this patch.  Like you
> expected, I am seeing soft lock-ups when I try to bring the interface up.
>
>> in order to recreate the issue, we installed Ubuntu 8.04- the Hardy
>> Heron - released in April 2008.
>> as expected the issue is perfectly reproducible. thanks to Raj for his
>> help and suggestions.
>
> Thanks for taking the time to test.  I really appreciate everyone's help.
>
>> *please obtain the stable compat-wireless-2.6.36-4
>> http://linuxwireless.org/en/users/Download/stable/#compat-wireless_2.6.36_stable_releases
>> *download the old firmware
>> http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob_plain;f=ar9271.fw;hb=HEAD
>> (history http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=history;f=ar9271.fw;h=d0ee74a1c8dccb7cc21f5be90f1d4048fa9dbf9e;hb=HEAD)
>> with this your USB card will be up and running, we did some basic testing.
>> *I used  usbmodeswitch-0.9.4
>
> Ultimately we'd like to try the experimental AP mode.  I understand this was
> introduced in kernel version 2.6.40, so I don't think compat-wireless-2.6.36-4
> will work for us.

yes AP mode support is not available in 2.6.36-4 and so as the
corresponding firmware changes.

>
> Can you point me to the LED-related commits that you mentioned above?  We'll
> either need to backport the changes required to fix the soft lock-ups or upgrade
> our kernel to include these commits.

no I have not looked into that deeply, will surely take a look into it sooner.

>
>> we also recommend you upgrade to latest kernel available for your distribution,
>> because we may still face some other issues as ath9k_htc very much new
>> compared to ath9k
>
> A kernel upgrade is something I would like to avoid if possible, but of course
> it is something we'll consider if we need to.

its highly recommended you please upgrade the kernel. its needed because
 we can avoid fixing issues that may need to back ported in the future.

>
>> please also read
>> http://wireless.kernel.org/en/users/Download/compat-wireless-old
>
> I think this kernel is supported by the regular compat-wireless package, right?

true, but its also mentioned in the known issues that 2.6.26 >= is
what ath9k best supports.
its good that  ath9k_htc worked

>
> Thanks,
> Forest
> --
> Forest Bond
> http://www.alittletooquiet.net
> http://www.rapidrollout.com
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAk4UqZEACgkQRO4fQQdv5Ay9jQCbB3lJUTTYM0Vm1o+JNqwG0kyI
> BAMAnjiX7VDThAbNYOyasOBTarI5ZqtE
> =V/bH
> -----END PGP SIGNATURE-----
>
>



-- 
shafi
