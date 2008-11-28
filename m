Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:34810 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYK1Adq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 19:33:46 -0500
From: herton <herton@mandriva.com.br>
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [RFC] rtl8187: Do not wait for an ACK when IEEE80211_TX_CTL_NO_ACK is set
Date: Thu, 27 Nov 2008 22:33:40 -0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Felix Fietkau" <nbd@openwrt.org>
References: <69e28c910811261431u26e341d3p51ebadca807f4b61@mail.gmail.com> <1227823149.7559.1.camel@johannes.berg> <69e28c910811271439g3f7beaffx431ec1aa7549f7b9@mail.gmail.com>
In-Reply-To: <69e28c910811271439g3f7beaffx431ec1aa7549f7b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200811272233.40908.herton@mandriva.com.br> (sfid-20081128_013357_659527_C06CD82B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 27 November 2008 20:39:34 Stefanik G=E1bor wrote:
> On Thu, Nov 27, 2008 at 10:59 PM, Johannes Berg
>
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2008-11-27 at 19:52 -0200, Herton Ronaldo Krzesinski wrote:
> >> In this case then shouldn't mac80211/rate control alg give a right
> >> rates[0].count?
> >
> > It probably should put 1 into that value, yes. It doesn't seem to
> > enforce that now though, I'll take a look at doing that.
> >
> >> And other drivers have same bug?
> >
> > possibly.
> >
> > Another thing: the ".count" is the number of tries you should do, s=
o if
> > the hardware expects retries then you need to subtract 1.

Ops sorry, then I did a mistake in a previous patch reverting a subtrac=
t in=20
rtl8187_tx. This will fix the code, will submit a patch with proper cha=
ngelog:

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/w=
ireless/rtl818x/rtl8187_dev.c
index ceebeb7..41444e2 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -238,7 +238,7 @@ static int rtl8187_tx(struct ieee80211_hw *dev, str=
uct sk_buff *skb)
 		hdr->flags =3D cpu_to_le32(flags);
 		hdr->len =3D 0;
 		hdr->rts_duration =3D rts_dur;
-		hdr->retry =3D cpu_to_le32(info->control.rates[0].count << 8);
+		hdr->retry =3D cpu_to_le32((info->control.rates[0].count - 1) << 8);
 		buf =3D hdr;
=20
 		ep =3D 2;
@@ -256,7 +256,7 @@ static int rtl8187_tx(struct ieee80211_hw *dev, str=
uct sk_buff *skb)
 		memset(hdr, 0, sizeof(*hdr));
 		hdr->flags =3D cpu_to_le32(flags);
 		hdr->rts_duration =3D rts_dur;
-		hdr->retry =3D cpu_to_le32(info->control.rates[0].count << 8);
+		hdr->retry =3D cpu_to_le32((info->control.rates[0].count - 1) << 8);
 		hdr->tx_duration =3D
 			ieee80211_generic_frame_duration(dev, priv->vif,
 							 skb->len, txrate);


> >
> > johannes
>
> I actually tested that 0 is the right setting - I initially tested it
> with 1, and there was evidence that it was still retrying. Setting it
> to 0 truly behaved like a NO_ACK bit would on other HW. (I used
> aireplay-ng to get a view of transmission speed - the "chopchop" and
> "interactive replay" are good indicators. I used a patch to make all
> injected frames NO_ACK, then tested the highest rate that results in
> no multiple tries for the same number in chopchop. With the original
> code, I could transmit 25 frames per second - anything higher resulte=
d
> in chopchop requiring more than 256 packets for each byte. Most
> drivers start to behave this way over about 600 to 700 packets per
> second. Setting the retry count to 1 resulted in a max of 220/s befor=
e
> producing more-than-256-attempts errors, still lower than what other
> drivers do with NO_ACK, suggestive of the driver still retrying.
> Setting to 0 resulted in a 625/s max, on par with other drivers.)
> This means, hdr->retry is the number of retries, unlike ".count",
> which is the number of tries, including the initial transmit.

yep, you're right, I wrongly considered the retry field, that also made=
 me
introduce a bug that diff above fixes. Your patch was good, could be ap=
plied
while count is not enforced by mac80211.

--
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
