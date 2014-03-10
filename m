Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:52527 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaCJJSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 05:18:32 -0400
Received: by mail-oa0-f48.google.com with SMTP id m1so6668676oag.7
        for <linux-wireless@vger.kernel.org>; Mon, 10 Mar 2014 02:18:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394442523.18265.9.camel@dubbel>
References: <1394017904-4012-1-git-send-email-luca@coelho.fi>
	<1394017904-4012-3-git-send-email-luca@coelho.fi>
	<CA+BoTQkb95xGNtVUxvn_u==P6fuy-h0iNAp8pGEcq8m0ZUm-7A@mail.gmail.com>
	<1394174912.4192.9.camel@dubbel>
	<CA+BoTQmOPZGLt0Bv+YSZcXVif65G6+tRP0sbhcJEvz65FjABRg@mail.gmail.com>
	<1394442523.18265.9.camel@dubbel>
Date: Mon, 10 Mar 2014 10:18:32 +0100
Message-ID: <CA+BoTQk6-FQMFzKHa9SFUAmLVd8j-8g075J9vxyHj1Ps0k-JzQ@mail.gmail.com> (sfid-20140310_101836_368596_9B2E7525)
Subject: Re: [PATCH v5 2/3] mac80211: implement chanctx reservation
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <lrothc@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 March 2014 10:08, Luca Coelho <lrothc@gmail.com> wrote:
> On Mon, 2014-03-10 at 08:03 +0100, Michal Kazior wrote:
>> On 7 March 2014 07:48, Luca Coelho <luca@coelho.fi> wrote:
>> > On Wed, 2014-03-05 at 13:04 +0100, Michal Kazior wrote:
>> >> On 5 March 2014 12:11, Luca Coelho <luca@coelho.fi> wrote:
>> >>
>> >> [...]
>> >>
>> >> > +       /* unref our reservation before assigning */
>> >> > +       ctx->refcount--;
>> >> > +       sdata->reserved_chanctx = NULL;
>> >> > +       ret = ieee80211_assign_vif_chanctx(sdata, ctx);
>> >> > +       if (ret) {
>> >> > +               /* if assign fails refcount stays the same */
>> >> > +               if (ctx->refcount == 0)
>> >> > +                       ieee80211_free_chanctx(local, ctx);
>> >> > +               goto out_wake;
>> >> > +       }
>> >>
>> >> This actually won't work if there are AP VLANs (I noticed that yesterday).
>> >>
>> >> You can't call ieee80211_vif_copy_chanctx_to_vlans() here due to
>> >> current locking requirements. I have a patch for that though ;-) I'll
>> >> send it soon.
>> >
>> > How is this related to this patch?
>> >
>> > Anyway, good to know that you have fixed it. :)
>>
>> If you re-assign a chanctx of an AP that has VLANs you leave VLANs
>> with the old chanctx pointer. Those pointers should be updated or else
>> you'll end up dereferencing an invalid pointer.
>
> I see.  So, I need to call ieee80211_vif_copy_chanctx_to_vlans() here,
> but to do that I need your patch that allows it to be called without the
> RTNL.
>
> So, now this series will depend on that patch, I'll talk to Johannes.

There's also another catch with having unassign-assign chanctx
swapping. There's a brief period of time where chanctx_mtx unprotected
code (think rcu based sections) access the chanctx_conf to get
band/sband. This ends up with bloody NULL dereferences if you have a
5GHz-only hw. I'm currently patching those up. This would be another
(although indirect) dependency for the patchset.

We might also want to have a ieee80211_vif_chanctx() wrapper that
would return either assigned chanctx or reserved chanctx before the
reservation patchset. Otherwise, even with those NULL dereferences
patched you risk WARN_ONs and other (logic) failures.


Michał
