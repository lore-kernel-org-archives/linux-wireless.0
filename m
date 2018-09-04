Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-tai-02.qualcomm.com ([103.229.16.227]:34995 "EHLO
        alexa-out-tai-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727024AbeIDPnr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 11:43:47 -0400
From: Wen Gong <wgong@qti.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>, Wen Gong <wgong@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: RE: [EXTERNAL] Re: [PATCH v3] ath10k: support NET_DETECT WoWLAN
 feature
Date: Tue, 4 Sep 2018 11:18:25 +0000
Message-ID: <b6d8ada015e04738b6b3cee95e485e14@aptaiexm02f.ap.qualcomm.com> (sfid-20180904_131909_876042_BEEB79F0)
References: <1534402113-14337-1-git-send-email-wgong@codeaurora.org>
 <877ek18vyn.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877ek18vyn.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Kalle Valo
> Sent: Tuesday, September 4, 2018 5:15 PM
> To: Wen Gong <wgong@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org; ath10k@lists.infradead.org
> Subject: [EXTERNAL] Re: [PATCH v3] ath10k: support NET_DETECT WoWLAN
> feature
>=20
> Wen Gong <wgong@codeaurora.org> writes:
>=20
> > For WoWLAN support, it expect to support wake up based on discovery of
> [...]
>=20
> > +	channel_list =3D (u32 *)ptr;
> > +	for (i =3D 0; i < cmd->num_of_channels; i++)
> > +		channel_list[i] =3D pno->a_networks[0].channels[i];
>=20
> channel_list does not look endian safe to me, I'll change this to use __l=
e32.
Yes, __le32 is more safe.

> > +enum wmi_nlo_cipher_algorithm {
> > +	WMI_NLO_CIPHER_ALGO_NONE           =3D 0x00,
> > +	WMI_NLO_CIPHER_ALGO_WEP40          =3D 0x01,
> > +	WMI_NLO_CIPHER_ALGO_TKIP           =3D 0x02,
> > +	WMI_NLO_CIPHER_ALGO_CCMP           =3D 0x04,
> > +	WMI_NLO_CIPHER_ALGO_WEP104         =3D 0x05,
> > +	WMI_NLO_CIPHER_ALGO_BIP            =3D 0x06,
> > +	WMI_NLO_CIPHER_ALGO_WPA_USE_GROUP  =3D 0x100,
> > +	WMI_NLO_CIPHER_ALGO_RSN_USE_GROUP  =3D 0x100,
>=20
> Two defines with the same value 0x100, is this really correct?

Yes, it is an interface between host driver /firmware.

> --
> Kalle Valo
>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
