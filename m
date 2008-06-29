Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:28636 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYF2J5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2008 05:57:17 -0400
Received: by wa-out-1112.google.com with SMTP id j37so843803waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2008 02:57:16 -0700 (PDT)
Message-ID: <1ba2fa240806290257r1db0e021n152945d41ffe2f42@mail.gmail.com> (sfid-20080629_115720_469895_CAE1E7E6)
Date: Sun, 29 Jun 2008 12:57:16 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: don't accept WEP keys other than WEP40 and WEP104
Cc: drago01 <drago01@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1214639847.5507.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214610613-6990-1-git-send-email-tomas.winkler@intel.com>
	 <f6ca9fed0806272346y2e8fde2cwa27a79ee83d0c0af@mail.gmail.com>
	 <1214639847.5507.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 28, 2008 at 10:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2008-06-28 at 08:46 +0200, drago01 wrote:
>
>> > +/**
>> > + * enum ieee80211_key_len - key length
>> > + * @WEP40: WEP 5 byte long key
>> > + * @WEP104: WEP 13 byte long key
>> > + */
>> > +enum ieee80211_key_len {
>> > +       LEN_WEP40 = 5,
>> > +       LEN_WEP104 = 13,
>> > +};
>
>
>> > +               if (alg == ALG_WEP &&
>
>> What about 0 ?
>> See http://marc.info/?l=linux-wireless&m=121458316301507&w=2
>
>
> I don't think zero-keylen will have WEP there, will it? I don't really
> know though.

This patch  pushes the length check to ieee80211_set_encryption.
Unlike John's patch
where check was done in ieee80211_ioctl_siwencode.
The benefit of this is that both ENCODE end ENCODEEXT are treated.
The zero length key i.e. changing index is already taken care of in
ieee80211_ioctl_siwencode

<snip>
if (erq->flags & IW_ENCODE_DISABLED)
		remove = 1;
else if (erq->length == 0) {
		/* No key data - just set the default TX key index */
		ieee80211_set_default_key(sdata, idx);
		return 0;
}
</snip>

Tomas
