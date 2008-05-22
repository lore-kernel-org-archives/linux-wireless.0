Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:39790 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYEVSVU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 14:21:20 -0400
Received: by wf-out-1314.google.com with SMTP id 27so150015wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 11:21:20 -0700 (PDT)
Message-ID: <69e28c910805221121v1a34901co35ec41bff41bd1ec@mail.gmail.com> (sfid-20080522_202125_063966_9BB38E42)
Date: Thu, 22 May 2008 20:21:20 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: JMF <tolas_feup@hotmail.com>,
	"=?ISO-8859-1?Q?Alejandro_Grijalba_Mart=EDnez?=" <sud@latinsud.com>,
	"Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: do not alter injected seq numbers
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <69e28c910805221115g6290e5e9nef4444efca07aea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47FAB829.9010304@latinsud.com> <200804081025.39645.mb@bu3sch.de>
	 <loom.20080522T171937-155@post.gmane.org>
	 <69e28c910805221115g6290e5e9nef4444efca07aea@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2008 at 7:48 PM, JMF <tolas_feup@hotmail.com> wrote:
> Michael Buesch <mb@...> writes:
>  (...)
>> > +   if (unlikely(tx->flags & IEEE80211_TXRXD_TX_INJECTED))
>> > +           return TXRX_CONTINUE;
>  (...)
>> This does not work, since we use injection for other types of
>>  frames. For example management frames from hostapd. We don't want
>>  (and can't) make hostapd keep track of sequence numbers.
>> You'll have to contact radiotap people and add a flag for this.
>>  This would also solve the hardware counter problem then.
>
> The last time I saw tx.c, this should now be something like
>     info->flags & IEEE80211_TX_CTL_INJECTED
> But as far as I can see the usage is the same.
> And, unless I'm wrong, IEEE80211_TX_CTL_INJECTED is only used
>  with Monitor mode interfaces.
> Does hostapd use monitor mode interfaces? Because if it doesn't,
>  and if I saw things correcly, info->flags won't be set to
>  IEEE80211_TX_CTL_INJECTED, right?
>
> Any comments on this?

The flag is IEEE80211_TX_INJECTED. Here is a new patch, for the
current wireless-testing:

Signed-off-by: Alejandro Grijalba Mart=EDnez <sud@latinsud.com>
Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

---

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f35eaea..e5e8483 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -292,6 +292,9 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *t=
x)
 {
       struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)tx->skb->d=
ata;

+       if (unlikely(tx->flags & IEEE80211_TX_INJECTED))
+               return TX_CONTINUE;
+
       if (ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)) >=3D 2=
4)
               ieee80211_include_sequence(tx->sdata, hdr);



--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
