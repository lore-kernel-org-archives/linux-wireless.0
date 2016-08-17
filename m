Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34129 "EHLO
	mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbcHQUUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 16:20:39 -0400
Received: by mail-it0-f68.google.com with SMTP id e63so345659ith.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2016 13:20:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471463348.5173.16.camel@sipsolutions.net>
References: <20160817125800.19154-1-toke@toke.dk> <20160817144531.4285-1-toke@toke.dk>
 <1471463348.5173.16.camel@sipsolutions.net>
From: Dave Taht <dave.taht@gmail.com>
Date: Wed, 17 Aug 2016 22:07:48 +0200
Message-ID: <CAA93jw4+WTiFAdUJkPaf5aRDy81vMW34TPQt7xSgv95tsXU=cA@mail.gmail.com> (sfid-20160817_222043_000961_3CEB2B1B)
Subject: Re: [Make-wifi-fast] [PATCH v2] mac80211: Move crypto IV generation
 to after TXQ dequeue.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
	make-wifi-fast@lists.bufferbloat.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 17, 2016 at 9:49 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
> You need to work on coding style, a lot of your indentation is
> completely messed up.
>
>> +     switch (sdata->vif.type) {
>> +     case NL80211_IFTYPE_STATION:
>> +             if (sdata->u.mgd.use_4addr) {
>> +                     pn_offs =3D 30;
>> +                     break;
>> +             }
>> +             pn_offs =3D 24;
>> +             break;
>> +     case NL80211_IFTYPE_AP_VLAN:
>> +             if (sdata->wdev.use_4addr) {
>> +                     pn_offs =3D 30;
>> +                     break;
>> +             }
>> +             /* fall through */
>> +     case NL80211_IFTYPE_ADHOC:
>> +     case NL80211_IFTYPE_AP:
>> +             pn_offs =3D 24;
>> +             break;
>> +     default:
>> +             return;
>> +     }
>> +
>> +     if (sta->sta.wme) {
>> +             pn_offs +=3D 2;
>> +     }
>
> I think you just reinvented ieee80211_hdrlen(). No?
>
>> -     if (fast_tx->pn_offs) {
>> -             u64 pn;
>> -             u8 *crypto_hdr =3D skb->data + fast_tx->pn_offs;
>
> No need to undo the pn_offs optimisation for the !txq case, you can
> pass it in to the new function that will fill it.
>
> However, you're still doing it wrong - now you haven't fixed anything
> for TKIP, which won't hit the fastpath.

well, we're getting there. the results of both patch attempts were
really nice, and brought encrypted performance with fq back into line
with unencrypted. Still running crypted tests as I write...

So fixing TKIP would be next, forcing the AP to use that? What other
scenarios do we have to worry about? WDS?


> johannes
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast



--=20
Dave T=C3=A4ht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
