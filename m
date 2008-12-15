Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:55136 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbYLOQaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 11:30:24 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2565853rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 08:30:23 -0800 (PST)
Message-ID: <69e28c910812150830s5884ad61j87d16013142639cb@mail.gmail.com> (sfid-20081215_173049_735885_A35CFF78)
Date: Mon, 15 Dec 2008 17:30:23 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: set mac address in add_interface
Cc: maximlevitsky@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081215161435.M87237@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081118044037.GA18983@hash.localnet>
	 <69e28c910812150747j60cf17d9nc2e24aabb991d2a9@mail.gmail.com>
	 <20081215161435.M87237@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 5:17 PM, Bob Copeland <me@bobcopeland.com> wrot=
e:
> On Mon, 15 Dec 2008 16:47:48 +0100, Stefanik G=E1bor wrote
>> This patch regressed support for aireplay-ng's "fragmentation attack=
" feature!
>
> Does reverting just the following hunk make it work again?
>
>> > --- a/drivers/net/wireless/ath5k/attach.c
>> > +++ b/drivers/net/wireless/ath5k/attach.c
> [...]
>> > @@ -317,15 +317,9 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k=
_softc
> *sc, u8 mac_version)
>> >                goto err_free;
>> >        }
>> >
>> > -       /* Set MAC address */
>> > -       ret =3D ath5k_eeprom_read_mac(ah, mac);
>> > -       if (ret) {
>> > -               ATH5K_ERR(sc, "unable to read address from EEPROM:=
 0x%04x\n",
>> > -                       sc->pdev->device);
>> > -               goto err_free;
>> > -       }
>> > -
>> > +       /* MAC address is cleared until add_interface */
>> >        ath5k_hw_set_lladdr(ah, mac);
>> > +
>> >        /* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
>> >        memset(ah->ah_bssid, 0xff, ETH_ALEN);
>> >        ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
>
> --
> Bob Copeland %% www.bobcopeland.com
>
>
>

Yes, this fixes it.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
