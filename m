Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:48871 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYK0VwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 16:52:09 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [RFC] rtl8187: Do not wait for an ACK when IEEE80211_TX_CTL_NO_ACK is set
Date: Thu, 27 Nov 2008 19:52:19 -0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
References: <69e28c910811261431u26e341d3p51ebadca807f4b61@mail.gmail.com> <200811271543.59126.herton@mandriva.com.br> <69e28c910811271202s295bbf5bo3dc8c04c50b08a01@mail.gmail.com>
In-Reply-To: <69e28c910811271202s295bbf5bo3dc8c04c50b08a01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200811271952.21408.herton@mandriva.com.br> (sfid-20081127_225215_066688_243428EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Quinta 27 Novembro 2008, =E0s 18:02:22, Stefanik G=E1bor escreveu:
> On Thu, Nov 27, 2008 at 6:43 PM, Herton Ronaldo Krzesinski
>
> <herton@mandriva.com.br> wrote:
> > nack.
> >
> > I've seen other drivers set just a flag when hardware has a bit fie=
ld to
> > signalize that there isn't need to ack the tx packet to be sent, bu=
t
> > don't saw anyone changing retry in tx hw header. Also setting to 0 =
in
> > no_ack case looks wrong, for example see ath5k where it even checks=
 for
> > 0 and returns an error if you try to do this.
> >
> > --
> > []'s
> > Herton
>
> IMO the current implementation is even worse - completely disregard
> NO_ACK, and when a packet that should not be ACKed according to IEEE
> 802.11:2007 is sent (such as a broadcast), retry repeatedly until
> timeout.

In this case then shouldn't mac80211/rate control alg give a right rate=
s[0].count?
And other drivers have same bug?
But I agree that we should set to 0 if to the hardware it means that 0 =
is the
same meaning to the no ack bitfield on others; only there is no referen=
ce/docs
mentioning this.

> Also, v26.1010 of the vendor driver does exactly what my patch does.

Is this newer than 26.1036.0708.2008 I have here? The version it never =
sets 0,
in code there is this:

                if( WLAN_FC_GET_STYPE(le16_to_cpu(frag_hdr->frame_ctl))=
 =3D=3D IEEE80211_STYPE_PROBE_RESP )
                        tx[5] |=3D (1<<8);//(priv->retry_data<<8); //re=
try lim ;
                else
                        tx[5] |=3D (11<<8);//(priv->retry_data<<8); //r=
etry lim ;

I didn't found this version 26.1010 to download, do you know where I ca=
n get?

--
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
