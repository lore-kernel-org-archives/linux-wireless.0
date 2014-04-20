Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:39555 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaDTT3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 15:29:02 -0400
Received: by mail-oa0-f43.google.com with SMTP id eb12so3519209oac.2
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 12:29:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140420205452.79a95330@wiggum>
References: <1398018659-17263-1-git-send-email-zajec5@gmail.com>
	<20140420205452.79a95330@wiggum>
Date: Sun, 20 Apr 2014 21:29:01 +0200
Message-ID: <CACna6rwjEP8qZ+SWQEOREmr=4wBJSgeNY_mG5GQpOWem7Jgrgw@mail.gmail.com> (sfid-20140420_212905_984121_F82B3529)
Subject: Re: [wireless-next][PATCH 1/2] b43: ssb: refuse to support more than
 IEEE 802.11 core
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-04-20 20:54 GMT+02:00 Michael Büsch <m@bues.ch>:
> On Sun, 20 Apr 2014 20:30:58 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
>> index 69fc3d6..cf84cf2 100644
>> --- a/drivers/net/wireless/b43/main.c
>> +++ b/drivers/net/wireless/b43/main.c
>> @@ -5486,39 +5486,42 @@ int b43_ssb_probe(struct ssb_device *sdev, const struct ssb_device_id *id)
>>       struct b43_bus_dev *dev;
>>       struct b43_wl *wl;
>>       int err;
>> -     int first = 0;
>>
>>       dev = b43_bus_dev_ssb_init(sdev);
>>       if (!dev)
>>               return -ENOMEM;
>>
>>       wl = ssb_get_devtypedata(sdev);
>
>
> The whole "struct b43_wl" and "ssb_get_devtypedata" was to support multiple
> cores of the same type in a single driver instance (= b43 multicore).
> With multicore support being removed, everything in b43_wl could be merged into b43_wldev.
> Also the use of ssb_get_devtypedata could probably be removed, too.
>
> This will simplify a lot of the b43 startup and shutdown code.

Yeah, I've noticed that, but this will be a bit complex to clean all
that code. I planned to handle this in future with further patches.

Do you think it's OK to push this small patchset and continue cleaning
process later? I'm afraid it may take a lot of time to clean in
completely and patchset would be huge. That's why I wanted to handle
it with small steps.
