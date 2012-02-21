Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:63964 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2BURo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 12:44:26 -0500
Received: by qafk1 with SMTP id k1so7366554qaf.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 09:44:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329693453.51266.YahooMailClassic@web29503.mail.ird.yahoo.com>
References: <4F416772.5030703@lwfinger.net>
	<1329693453.51266.YahooMailClassic@web29503.mail.ird.yahoo.com>
Date: Tue, 21 Feb 2012 18:44:25 +0100
Message-ID: <CAFmNhL=5TSTZ94ZrSUztG9Hs28Mqk8vMB7rS51SNgE2RCK5s7g@mail.gmail.com> (sfid-20120221_184431_018126_E9E0B4C7)
Subject: Re: [PATCH] rtl8187: Add Ad-hoc mode
From: Attila Fazekas <turul64@gmail.com>
To: htl10@users.sourceforge.net
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think it is worth the effort.

Hostapd AFAIK is not working with rtl8187 now.
Until we can make it work in master mode, the adhoc mode could be an
alternative. I think even if we can use it in master mode, ad-hoc mode
should be implemented.

About refactoring:

rtl8180_beacon_work()
Now is almost the same, I think it is possible to make it generic by a
macro, or by creating new source/object file linked to both driver, or
even possible to create a common module.
But, this function will be different if someone will be able to add
some hardware aided beacon timestamp update. (If I can have more
information about this hardware I'll try it)
Creating a new common module just for one small function, IMHO not
worth the effort.
Please advice.

struct rtl8187_vif, struct rtl8180_vif  now are the same, they might
be the same in the future as well.
We can remove them and create new one named rtl818x_vif in the rtl818x.h .
Shall I do it ?



On Mon, Feb 20, 2012 at 12:17 AM, Hin-Tak Leung
<htl10@users.sourceforge.net> wrote:
> --- On Sun, 19/2/12, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> On 02/19/2012 01:54 PM, Attila
>> Fazekas wrote:
>> > Add AD-HOC support to the rtl8187 based on the rtl8180
>> source
>> >
>> > Signed-off-by: Attila Fazekas<turul64@gmail.com>
>> > ---
>> > diff --git
>> a/drivers/net/wireless/rtl818x/rtl8187/dev.c
>> > b/drivers/net/wireless/rtl818x/rtl8187/dev.c
>> > index 638fbef..f8f9186 100644
>> > --- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
>> > +++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
>> > @@ -232,6 +232,7 @@ static void rtl8187_tx(struct
>> ieee80211_hw *dev,
>> > struct sk_buff *skb)
>> >   {
>> >       struct rtl8187_priv
>> *priv = dev->priv;
>> >       struct
>> ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>> > +    struct ieee80211_hdr *tx_hdr =
>>     (struct ieee80211_hdr *)(skb->data);
>> >       unsigned int ep;
>> >       void *buf;
>> >       struct urb *urb;
>> > @@ -249,7 +250,7 @@ static void rtl8187_tx(struct
>> ieee80211_hw *dev,
>> > struct sk_buff *skb)
>>
>> This patch was mangled by your mailer. See how the line
>> above is wrapped? In addition, the tabs seem to have been
>> replaced by spaces.
>>
>> To test what works, you should mail a patch to yourself and
>> see if the version extracted from your mailer still
>> applies.
>
> I am curious about this patch - does it take this amount of driver-specific effort to make ad-hoc mode work? Master mode is preferably handled in a generic way by hostapd... "Add AD-HOC support to the rtl8187 based on the rtl8180 source" - could some refactor be done?
>
> Hin-Tak
