Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53427 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1GWIQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 04:16:41 -0400
Received: by pzk37 with SMTP id 37so4896337pzk.1
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2011 01:16:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rzwvbdMGhR45mE90wOoM359NgcUHqsZhG54wNrJAerrgA@mail.gmail.com>
References: <20110722090414.4e3d80a5.rdunlap@xenotime.net>
	<1311366436-25791-1-git-send-email-linville@tuxdriver.com>
	<CACna6rzwvbdMGhR45mE90wOoM359NgcUHqsZhG54wNrJAerrgA@mail.gmail.com>
Date: Sat, 23 Jul 2011 10:16:39 +0200
Message-ID: <CACna6rxcOGdF9AOLXya6K+uK40KY3aRRjmdn6=nt671Ja=QPqA@mail.gmail.com> (sfid-20110723_101744_745893_747693B4)
Subject: Re: [PATCH] bcma: fix 'SSB_PCICORE_BFL_NOPCI' undeclared build breakage
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 22 lipca 2011 23:35 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> 2011/7/22 John W. Linville <linville@tuxdriver.com>:
>> linux-next-20110722/drivers/bcma/driver_pci.c:175: error: 'SSB_PCICORE_BFL_NOPCI' undeclared (first use in this function)
>>
>> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> ---
>>  drivers/bcma/driver_pci.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
>> index dc6f34a..745d264 100644
>> --- a/drivers/bcma/driver_pci.c
>> +++ b/drivers/bcma/driver_pci.c
>> @@ -172,8 +172,10 @@ static bool bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
>>            chipid_top != 0x5300)
>>                return false;
>>
>> +#ifdef CONFIG_SSB_DRIVER_PCICORE
>>        if (bus->sprom.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
>>                return false;
>> +#endif /* CONFIG_SSB_DRIVER_PCICORE */
>>
>>  #if 0
>>        /* TODO: on BCMA we use address from EROM instead of magic formula */
>
> Huh, I've no idea why do we have such a mess with boardflags.
>
> SPROM is board specific, not core specific. There is no such thing
> like core-specific boardflags.
>
> Currently we define boardflags in every driver that is doing to use them:
> #define SSB_PCICORE_BFL_NOPCI           0x00000400 /* Board leaves PCI floating */
>
> #define SSB_GIGE_BFL_ROBOSWITCH             0x0010
>
> #define B43_BFL_BTCOEXIST               0x0001  /* implements Bluetooth coexistance */
> #define B43_BFL_PACTRL                  0x0002  /* GPIO 9 controlling the PA */
> #define B43_BFL_AIRLINEMODE             0x0004  /* implements GPIO 13 radio
> disable indication */
> #define B43_BFL_RSSI                    0x0008  /* software calculates nrssi slope. */
> #define B43_BFL_ENETSPI                 0x0010  /* has ephy roboswitch spi */
> #define B43_BFL_XTAL_NOSLOW             0x0020  /* no slow clock available */
> #define B43_BFL_CCKHIPWR                0x0040  /* can do high power CCK transmission */
> #define B43_BFL_ENETADM                 0x0080  /* has ADMtek switch */
> #define B43_BFL_ENETVLAN                0x0100  /* can do vlan */
> #define B43_BFL_AFTERBURNER             0x0200  /* supports Afterburner mode */
> #define B43_BFL_NOPCI                   0x0400  /* leaves PCI floating */
> #define B43_BFL_FEM                     0x0800  /* supports the Front End Module */
> #define B43_BFL_EXTLNA                  0x1000  /* has an external LNA */
> #define B43_BFL_HGPA                    0x2000  /* had high gain PA */
> #define B43_BFL_BTCMOD                  0x4000  /* BFL_BTCOEXIST is given in alternate GPIOs */
> #define B43_BFL_ALTIQ                   0x8000  /* alternate I/Q settings */
>
> You can see we have them duplicated.
>
> The real solution would be to move defines into one shared place (ssb).

John, if you are looking for a quick fix, I'd prefer to replace that
SSB_PCICORE_BFL_NOPCI with 0x400.

As I said, the real fix will change code in b43, gige, driver_pci, b43legacy.

-- 
Rafał
