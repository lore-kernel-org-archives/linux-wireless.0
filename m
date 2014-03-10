Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:53771 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaCJHDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 03:03:53 -0400
Received: by mail-ob0-f175.google.com with SMTP id uy5so6530293obc.6
        for <linux-wireless@vger.kernel.org>; Mon, 10 Mar 2014 00:03:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394174912.4192.9.camel@dubbel>
References: <1394017904-4012-1-git-send-email-luca@coelho.fi>
	<1394017904-4012-3-git-send-email-luca@coelho.fi>
	<CA+BoTQkb95xGNtVUxvn_u==P6fuy-h0iNAp8pGEcq8m0ZUm-7A@mail.gmail.com>
	<1394174912.4192.9.camel@dubbel>
Date: Mon, 10 Mar 2014 08:03:53 +0100
Message-ID: <CA+BoTQmOPZGLt0Bv+YSZcXVif65G6+tRP0sbhcJEvz65FjABRg@mail.gmail.com> (sfid-20140310_080356_781153_F7D72DB7)
Subject: Re: [PATCH v5 2/3] mac80211: implement chanctx reservation
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 March 2014 07:48, Luca Coelho <luca@coelho.fi> wrote:
> On Wed, 2014-03-05 at 13:04 +0100, Michal Kazior wrote:
>> On 5 March 2014 12:11, Luca Coelho <luca@coelho.fi> wrote:
>>
>> [...]
>>
>> > +       /* unref our reservation before assigning */
>> > +       ctx->refcount--;
>> > +       sdata->reserved_chanctx = NULL;
>> > +       ret = ieee80211_assign_vif_chanctx(sdata, ctx);
>> > +       if (ret) {
>> > +               /* if assign fails refcount stays the same */
>> > +               if (ctx->refcount == 0)
>> > +                       ieee80211_free_chanctx(local, ctx);
>> > +               goto out_wake;
>> > +       }
>>
>> This actually won't work if there are AP VLANs (I noticed that yesterday).
>>
>> You can't call ieee80211_vif_copy_chanctx_to_vlans() here due to
>> current locking requirements. I have a patch for that though ;-) I'll
>> send it soon.
>
> How is this related to this patch?
>
> Anyway, good to know that you have fixed it. :)

If you re-assign a chanctx of an AP that has VLANs you leave VLANs
with the old chanctx pointer. Those pointers should be updated or else
you'll end up dereferencing an invalid pointer.


Michał
