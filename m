Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58646 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353AbcDLRnH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 13:43:07 -0400
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"Sudip Mukherjee" <sudip.mukherjee@codethink.co.uk>
Subject: Re: [PATCH] mwifiex: fix possible NULL dereference
Date: Tue, 12 Apr 2016 17:43:03 +0000
Message-ID: <867653EE-136B-488D-8F85-716B1ED9BD1A@intel.com> (sfid-20160412_194329_808060_30D4D9F1)
References: <1460388459-21090-1-git-send-email-sudipm.mukherjee@gmail.com>
 <CAHp75VfO3A+HBjkjc9WC9jzB9gtYrVM6izLmpiqLntChGOzjMA@mail.gmail.com>
In-Reply-To: <CAHp75VfO3A+HBjkjc9WC9jzB9gtYrVM6izLmpiqLntChGOzjMA@mail.gmail.com>
Content-Type: multipart/signed;
	boundary="Apple-Mail=_82A28291-85F1-4A42-AE7E-955067EA63CA";
	protocol="application/pgp-signature"; micalg=pgp-sha256
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Apple-Mail=_82A28291-85F1-4A42-AE7E-955067EA63CA
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii;
	delsp=yes;
	format=flowed

Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Mon, Apr 11, 2016 at 6:27 PM, Sudip Mukherjee
> <sudipm.mukherjee@gmail.com> wrote:
>> From: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>>
>> We have a check for card just after dereferencing it. So if it is NULL
>> we have already dereferenced it before its check. Lets dereference it
>> after checking card for NULL.
>
> IIUC the code does nothing with dereference.
>
> I would have told NAK if I would have been maintainer.
>
>> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>> ---
>>  drivers/net/wireless/marvell/mwifiex/pcie.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c  
>> b/drivers/net/wireless/marvell/mwifiex/pcie.c
>> index edf8b07..84562d0 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
>> @@ -2884,10 +2884,11 @@ static void mwifiex_unregister_dev(struct  
>> mwifiex_adapter *adapter)
>>  {
>>         struct pcie_service_card *card = adapter->card;
>
> Let's say it's 0.
>
>>        const struct mwifiex_pcie_card_reg *reg;
>> -       struct pci_dev *pdev = card->dev;
>
> This would be equal to offset of dev member in pcie_service_card struct.
>
> Nothing wrong here.

Actually, that is not true. The dereference of card tells the compiler that  
card can't be NULL, so it is free to eliminate the check below.  
Unbelievably, this can even happen for a reference such as &ptr->thing  
where the pointer isn't even actually dereferenced at all!

>> +       struct pci_dev *pdev;
>>         int i;
>>
>>         if (card) {
>> +               pdev = card->dev;
>>                 if (card->msix_enable) {
>>                         for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++)
>>                                 synchronize_irq(card->msix_entries[i].vector);
>> --
>> 1.9.1
>
>
>
> --
> With Best Regards,
> Andy Shevchenko


--
Mark Rustad, Networking Division, Intel Corporation

--Apple-Mail=_82A28291-85F1-4A42-AE7E-955067EA63CA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJXDTOnAAoJEDwO/+eO4+5u4TAP/Rh0B1w5txmGygx9AW3657Bu
Htn6SZcpNjNZ6wwQ0Mtnznz8g79KOgy9MwTkumi+x6TEr+8P6mWKfCaOLiKwp5iR
s80y1PotUefHl+VZHm9/taoDntQDZDzlff64f/6fzT20zBNsscANfSfxiEO25wfC
znX5HgM4qnW+Dso5wAGQlBQmAgEVoMwtItAeGNVhJ5lOaFuX9kIjc2g3tP+4kZyH
JophiUOw6McT1AuNWkREFHANWzGQ4miENeWMFMYXwJAAhSXb/2lb596H93vmfuHR
AewDHt+xPT+PEmO9vXlIGNWpCeK95Po6Se0mHIc33WeJ6/DRWe3tAt0zEUr8auqT
Lr4vmvIFs/LW9cOb0pBptvyxCmbw87fp4w7NsM7LNC8CbwAbE7EUGouRm24IGHbp
wcbdm7hh3J0WiciUxSsluYnWfa9STL/3r1ysRDduPwCstZ2prHt58kV9V3uxptHB
VwaT/ZF0G9j457oI7KJpH8PRGnvM0e2+s3yTjEix6DLZv07cF9Y7ngzQ3t26dV82
TFXozdBSqQQzcHjp4HTjlG0T3XgBcEumxP4XbdvN91g2rXAp5drCrkpcSpUIzEKK
tE9xM7ml7qD8TmQq0Hc+Hd0HTmA8OdLQ1NNI7hIt0K2LUh23N6/yS2I/i3LpSeF/
KdriujWI8IeLmcSvVafw
=CCkz
-----END PGP SIGNATURE-----

--Apple-Mail=_82A28291-85F1-4A42-AE7E-955067EA63CA--
