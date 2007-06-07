Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:19329 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbXFGVfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 17:35:39 -0400
Received: by py-out-1112.google.com with SMTP id a29so1079168pyi
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2007 14:35:38 -0700 (PDT)
Message-ID: <43e72e890706071435x52fa0174idf270ef0774404a3@mail.gmail.com>
Date: Thu, 7 Jun 2007 17:35:38 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "stefano.brivio@polimi.it" <stefano.brivio@polimi.it>
Subject: Re: RFC: Regulatory info in mac80211
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Matt Norwood" <norwood@softwarefreedom.org>,
	"Theo de Raadt" <deraadt@cvs.openbsd.org>
In-Reply-To: <20070607212718.c9chfckmosg4w0wk@webmail.polimi.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <4665CCE7.5090409@lwfinger.net> <20070607091040.2b2f1d00@morte>
	 <43e72e890706071152n2d687497va9449d330e2078b4@mail.gmail.com>
	 <20070607212718.c9chfckmosg4w0wk@webmail.polimi.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/7/07, stefano.brivio@polimi.it <stefano.brivio@polimi.it> wrote:
> Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:
>
> > A bigger issue for users is support. As you very well know reverse
> > engineering is a long tedious process; we are essentially doomed to
> > reverse engineering  wireless drivers for some wireless devices where
> > regulatory compliance sits in the driver due to vendor fears on legal
> > liability. I'm not saying their fears are justified by any means I'm
> > just saying those fears do exist by some vendors and unfortunately we
> > suffer the consequences. So if we can do some sort of best effort,
> > perhaps we can steer some vendors to support us.
>
> I would say that we should do our best in supporting users instead.
>
> Furthermore, I understand your concerns, but:
> 1) I think that a weak regulatory domain support (such as commented
> defines in the mac80211 code) is sufficient to claim we comply with
> regulatory domains, while avoiding to hassle users.

Current mac80211 regdomain support is a joke. Once we get something
more decent I'd be inclined to agree with you. But to comply with is
not sufficient to gain vendor support and that's what I'd like more of
and why I think Larry mentioned it as well.

> 2) We won't get any vendor to support us thanks to regulatory
> compliance.

For just a FOSS implementation of it with no security measures in
place, you are right. Some vendors want some sort of security measure
on top of such regulatory compliance agents though. A perfect example
was Atheros' belief in the Hardware Abstraction Layer model as
sufficient for regulatory compliance. I'm inclined to believe some
vendors may vouch for support should such type of models still be
used. I'm inclined to believe that we can get some more vendor support
should we come up with an alternative to this which still allows full
FOSS drivers. Henry, can you perhaps comment a bit on Broadcom's
position on this?

> There are just some weird vendors such as Broadcom and
> some friendly vendors such as Realtek: it's unrealistic that vendors
> such as Broadcom would ever change their mind. You may say my point is
> short-sighted, but I really can't think that we can steer a vendor to
> support us just by complying to regulatory domains:

The idea is not just try to get vendor support by simply complying to
regulatory domain control but to try to see if we can provide some
sort of security measure to prevent modifications of such agent. I'm
not even saying that such security features are the right thing to do
-- in fact I think its ridiculous -- I'm just saying this is what some
vendors are asking for should we want support for FOSS drivers on some
devices where regulatory domain control is enforced at the driver
level RIGHT NOW.

IMO the long term goal should be to change legislation so that a
complete FOSS solution to regulatory compliance is sufficient for
802.11 and if such regulatory compliance is violated by the user
(regulatory, even if modifying the device such as adding a new antenna
which makes the device go out of compliance) liability is passed onto
the user, not the OEM or vendor. Note that this argument is made
purely for 802.11, not WiMAX ;) I think it may be something possible
for us to accomplish.

> it looks clear to
> me that Broadcom and other weird vendors such as TI are just
> ridicolously trying to protect IP.

I think "old-school" is a more appropriate description for them -- but
anyway, I have not yet heard one argument from a vendor which does
emphasize this as a reason to not support us. On the contrary the main
issue vendors have expressed concerns over support has been regulatory
compliance and way to assure the user cannot circumvent this due to
legal concerns over liability in the worst case scenarios in markets
where their products are sold (Singapore, Japan?).

>Or are you talking about the
> almost-friendly vendors like Intel?

I think Intel is as friendly as they'll get. And anyway -- no, Intel
has acknowledged the mess with regulatory compliance and I do believe
their developers strive as much as possible to get us proper support
and as close to a FOSS driver as possible. Their solution to the mess
is to put regulatory compliance in microcode, which most regulatory
agencies do seem to tolerate for a FOSS driver.

> 3) The GPL license, in my humble opinion, aims at the most possible
> freedom. I don't care if vendors support us if we don't aim at this.

You don't. Many people don't. But Aunt Tillie wants support for her
wireless card. And if it means switching back to Mac OS X to get
support for it she'll do it. I also don't think its fair for us to
have to reverse engineer all of our wireless drivers. To avoid this we
should try to listen to vendor concerns and see if we can address and
deal with them, for Aunt Tillie's sake. And if we determine such
concerns are unreasonable for a FOSS driver then I think in terms of
support we can only try to seriously lobby for a change in legislation
in our own locales to address this.

> However, as you can see, I CC'ed Theo DeRaadt, who, being an expert
> about these issues, will sure provide us with the best advice about
> what to do.

CC'd now, for real this time. He may actually have some useful
feedback on the topic.

  Luis
