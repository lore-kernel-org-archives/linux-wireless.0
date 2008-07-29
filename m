Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:37530 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbYG2VLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 17:11:47 -0400
Received: by wa-out-1112.google.com with SMTP id j37so39586waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 14:11:47 -0700 (PDT)
Message-ID: <1ba2fa240807291411j14e0db0etc7d0d56def66104e@mail.gmail.com> (sfid-20080729_231150_680291_17FA2635)
Date: Wed, 30 Jul 2008 00:11:47 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Randy Dunlap" <rdunlap@xenotime.net>,
	"David S. Miller" <davem@davemloft.net>,
	"John Linville" <linville@tuxdriver.com>
Subject: Re: Fix iwlwifi compilation without CONFIG_IWLWIFI_DEBUG
Cc: "Andreas Schwab" <schwab@suse.de>, linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20080729135509.6db7c9b4.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <jebq0g8qdf.fsf@sykes.suse.de>
	 <1ba2fa240807291350m4d698713k7c3ea21d25ee105f@mail.gmail.com>
	 <20080729135509.6db7c9b4.rdunlap@xenotime.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 11:55 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Tue, 29 Jul 2008 23:50:25 +0300 Tomas Winkler wrote:
>
>> On Tue, Jul 29, 2008 at 10:03 PM, Andreas Schwab <schwab@suse.de> wrote:
>> > drivers/net/wireless/iwlwifi/iwl-led.c: In function 'iwl_led_brightness_set':
>> > drivers/net/wireless/iwlwifi/iwl-led.c:198: error: 'led_type_str' undeclared (first use in this function)
>> > drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared identifier is reported only once
>> > drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function it appears in.)
>> >
>> > Signed-off-by: Andreas Schwab <schwab@suse.de>
>> > ---
>> > diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
>> > index 899d7a2..a58571c 100644
>> > --- a/drivers/net/wireless/iwlwifi/iwl-led.c
>> > +++ b/drivers/net/wireless/iwlwifi/iwl-led.c
>> > @@ -195,8 +195,10 @@ static void iwl_led_brightness_set(struct led_classdev *led_cdev,
>> >                return;
>> >
>> >
>> > +#ifdef CONFIG_IWLWIFI_DEBUG
>> >        IWL_DEBUG_LED("Led type = %s brightness = %d\n",
>> >                        led_type_str[led->type], brightness);
>> > +#endif
>> >        switch (brightness) {
>> >        case LED_FULL:
>> >                if (led->type == IWL_LED_TRG_ASSOC)
>> >
>>
>> Thanks for your patch
>> But the fixes were already sent out  a week ago or You can find them
>> on this mailing list.
>
> But the reason that we are seeing this (third IIRC) patch for this problem
> is that the patch needs to be merged somewhere..... :(
> other than the mailing list.

Definitely. John Linville was also on OLS I guess that's the reason
for delay in merge.  I've even reposed this patches to LKML IRCC to
Andrew Morton's request
What more can I do.  Maybe David Miller can somehow speed up the
process not sure.
But this is like 5th patch I've received to fix this starting to be a
bit annoying.

BTW 'Denis V. Lunev' is the author of the 3 patches that fixes this
http://marc.info/?l=linux-wireless&m=121642949226032&w=2
http://marc.info/?l=linux-wireless&m=121636411821968&w=2
http://marc.info/?l=linux-wireless&m=121629329109400&w=2

Tomas.
