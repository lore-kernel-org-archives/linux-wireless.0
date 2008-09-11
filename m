Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:26394 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbYIKARQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 20:17:16 -0400
Received: by yw-out-2324.google.com with SMTP id 9so42349ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Sep 2008 17:17:15 -0700 (PDT)
Message-ID: <43e72e890809101717y2ffa9df3lfcad4b997b55249c@mail.gmail.com> (sfid-20080911_021718_821102_FBBE6A28)
Date: Wed, 10 Sep 2008 17:17:14 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 16/18] mac80211 hwsim: verify vif pointers
Cc: "John Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1221091773.3804.60.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080910220145.707263000@sipsolutions.net>
	 <20080910220426.564761000@sipsolutions.net>
	 <20080911000630.GC20358@tesla>
	 <1221091773.3804.60.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 10, 2008 at 5:09 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-09-10 at 17:06 -0700, Luis R. Rodriguez wrote:
>> On Wed, Sep 10, 2008 at 03:02:01PM -0700, Johannes Berg wrote:
>> > --- everything.orig/drivers/net/wireless/mac80211_hwsim.c       2008-09-10 23:58:05.000000000 +0200
>> > +++ everything/drivers/net/wireless/mac80211_hwsim.c    2008-09-10 23:58:11.000000000 +0200
>> > @@ -28,6 +28,29 @@ static int radios = 2;
>> >  module_param(radios, int, 0444);
>> >  MODULE_PARM_DESC(radios, "Number of simulated radios");
>> >
>> > +struct hwsim_vif_priv {
>> > +       u32 magic;
>> > +};
>> > +
>> > +#define HWSIM_VIF_MAGIC        0x69537748
>> > +
>> > +static inline void hwsim_check_magic(struct ieee80211_vif *vif)
>> > +{
>> > +       struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
>> > +       BUG_ON(vp->magic != HWSIM_VIF_MAGIC);
>>
>> If its a debugging tool then better WARN_ON instead no?
>
> I don't know, yeah, maybe. I can change it.

Leave it for now, it can be changed later.

  Luis
