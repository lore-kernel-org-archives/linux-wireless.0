Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm8.bullet.mail.ird.yahoo.com ([77.238.189.23]:43520 "HELO
	nm8.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750730Ab2BSXRf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 18:17:35 -0500
Message-ID: <1329693453.51266.YahooMailClassic@web29503.mail.ird.yahoo.com> (sfid-20120220_001739_180522_7AE72462)
Date: Sun, 19 Feb 2012 23:17:33 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH] rtl8187: Add Ad-hoc mode
To: Attila Fazekas <turul64@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@canonical.com>
In-Reply-To: <4F416772.5030703@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Sun, 19/2/12, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 02/19/2012 01:54 PM, Attila
> Fazekas wrote:
> > Add AD-HOC support to the rtl8187 based on the rtl8180
> source
> > 
> > Signed-off-by: Attila Fazekas<turul64@gmail.com>
> > ---
> > diff --git
> a/drivers/net/wireless/rtl818x/rtl8187/dev.c
> > b/drivers/net/wireless/rtl818x/rtl8187/dev.c
> > index 638fbef..f8f9186 100644
> > --- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
> > +++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
> > @@ -232,6 +232,7 @@ static void rtl8187_tx(struct
> ieee80211_hw *dev,
> > struct sk_buff *skb)
> >   {
> >       struct rtl8187_priv
> *priv = dev->priv;
> >       struct
> ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> > +    struct ieee80211_hdr *tx_hdr =
>     (struct ieee80211_hdr *)(skb->data);
> >       unsigned int ep;
> >       void *buf;
> >       struct urb *urb;
> > @@ -249,7 +250,7 @@ static void rtl8187_tx(struct
> ieee80211_hw *dev,
> > struct sk_buff *skb)
> 
> This patch was mangled by your mailer. See how the line
> above is wrapped? In addition, the tabs seem to have been
> replaced by spaces.
> 
> To test what works, you should mail a patch to yourself and
> see if the version extracted from your mailer still
> applies.

I am curious about this patch - does it take this amount of driver-specific effort to make ad-hoc mode work? Master mode is preferably handled in a generic way by hostapd... "Add AD-HOC support to the rtl8187 based on the rtl8180 source" - could some refactor be done?

Hin-Tak
