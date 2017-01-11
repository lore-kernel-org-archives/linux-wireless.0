Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62582 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752322AbdAKNNt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 08:13:49 -0500
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Subject: Re: [PATCH 3/3] cfg80211: Specify the reason for connect timeout
Date: Wed, 11 Jan 2017 13:13:37 +0000
Message-ID: <20170111131335.GB27748@jouni.qca.qualcomm.com> (sfid-20170111_141402_418855_7B87E3BC)
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
 <1483984388-30237-3-git-send-email-jouni@qca.qualcomm.com>
 <a59ef282-921d-6591-ab33-0a8dd3ef4294@broadcom.com>
In-Reply-To: <a59ef282-921d-6591-ab33-0a8dd3ef4294@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 09, 2017 at 09:24:56PM +0100, Arend Van Spriel wrote:
> > diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> > @@ -38,6 +38,7 @@ struct cfg80211_conn {
> >  		CFG80211_CONN_ASSOCIATE_NEXT,
> >  		CFG80211_CONN_ASSOCIATING,
> >  		CFG80211_CONN_ASSOC_FAILED,
> > +		CFG80211_CONN_ASSOC_FAILED_TIMEOUT,
>=20
> Was kinda expecting AUTH_FAILED_TIMEOUT....

Me too when going through the changes.. But only the association failure
cases had different triggers that needed a change here.

> > @@ -172,6 +174,7 @@ static int cfg80211_conn_do_work(struct wireless_de=
v *wdev)
> >  	case CFG80211_CONN_AUTH_FAILED:
> > +		*treason =3D NL80211_TIMEOUT_AUTH;
>=20
> ... but it seems AUTH failure always is a timeout?

The CFG80211_CONN_AUTH_FAILED case is currently used only in
cfg80211_sme_auth_timeout() which is indeed always a timeout.

--=20
Jouni Malinen                                            PGP id EFC895FA=
