Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42984 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaGWTPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 15:15:30 -0400
Received: by mail-pd0-f170.google.com with SMTP id g10so2151325pdj.15
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2014 12:15:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WxUi9J+ODtvojAkT5PN5LsB=SWKhgbzqSkGkbepWeaOg@mail.gmail.com>
References: <CA+XVXfcJwZJPz9rLWx6+KSWzEfkcdnjBYpzhyKfvmX7Au38akA@mail.gmail.com>
 <20140630222132.GN1390@garbanzo.do-not-panic.com> <CA+XVXffHGQFDQ+yAhdh+R=XuDsT4QfhvFfWK4b2Cw_DttzL-BQ@mail.gmail.com>
 <20140702020442.GP1390@garbanzo.do-not-panic.com> <CA+XVXffvG6GagBPMZF+iogaAeYV0kUoi4BX68J0fxOfsHjE70A@mail.gmail.com>
 <20140703221901.GS1390@garbanzo.do-not-panic.com> <CA+XVXffnDs4oCnyD0NzmyG6=jxqXwUFd+Tj8XAsWGC1bgcMH8A@mail.gmail.com>
 <CA+XVXfewhKpsdVo5Yq3RiKWoDe85h1ne_QVUDtFuC4sfECkV7g@mail.gmail.com>
 <20140708025719.GU1390@garbanzo.do-not-panic.com> <CA+XVXffMM9W76ysqgs=pyAHubavefgjqW5u8bNSZxTX69j7nzg@mail.gmail.com>
 <20140723004132.GX1390@garbanzo.do-not-panic.com> <CA+XVXfd-4jYUy3oz4cOqBprG358X2D9m7Pgq_JrkZKHERm6f3A@mail.gmail.com>
 <CAB=NE6WxUi9J+ODtvojAkT5PN5LsB=SWKhgbzqSkGkbepWeaOg@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 23 Jul 2014 22:15:13 +0300
Message-ID: <CA+XVXfcHwOAndEfUo3YtZxbgHtC12qC22QcpVXZFM41WKn0LiQ@mail.gmail.com> (sfid-20140723_211536_812299_45CA8701)
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user hints
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2014 at 9:06 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
>> I also suggest adding another argument to regulatory_hint_regd() to
>> allow the driver to specify the intersection policy. It seems that
>> currently the code (__reg_process_hint_driver()) only allows to
>> intersect, which is not appropriate to us.
>> So the final form can look like:
>>
>> regulatory_hint_regd(struct wiphy,
>>                               const struct ieee80211_regdomain *regd,
>>                               enum nl80211_driver_reg_hint_type,
>>                               enum nl80211_reg_intersect_policy policy);
>>
>> enum nl80211_reg_intersect_policy {
>>          REG_INTERSECT_POLICY_DEFAULT,
>>          REG_INTERSECT_POLICY_OVERRIDE,
>>          REG_INTERSECT_POLICY_INTERSECT,
>> };
>
> We don't want to use the driver regulatory data to help the regulatory
> core at all because I noted it would get things messy fast. That would
> mean you never have to deal with any intersection or the cfg80211
> regulatory domain at all. So none of this would be needed. The hint
> would just be for the driver. Its sad that driver regulatory data
> can't contribute to the regulatory core but I think its best this way
> to keep things clean and simple. If the driver does want to help the
> best way is to contribute to wireless-regdb and move to that.

I guess I didn't get that one.

Isn't that problematic for cell-base hints coming from usermode? I
mean, what wiphy are they from?
It's also problematic because currently usermode uses the
cfg80211_regdomain for its regulatory data (NL80211_CMD_GET_REG).

Granted, all of this can be changed, but I think it's easier to update
the global regdomain.

The cell-base hints from usermode with the regdomain data coming from
the FW was the original reason to introduce the get_regd() callback.
For driver originating hints I agree regulatory_hint_regd() is a
cleaner solution.

I feel the case of two different cards, one of which uses get_regd()
and the other wireless-regdb is a non-existent corner-case. And we're
throwing out the baby with the bathwater.
Why write extra code for a case that doesn't happen? How about adding
appropriate regulatory_flags to ensure this can't happen?

Overall it seems to be the API you've suggested in the previous email
with the addition of get_regd() for usermode hints can work well,
updating the global cfg80211_regdomain.

Regards,
Arik
