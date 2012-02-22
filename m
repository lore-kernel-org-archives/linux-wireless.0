Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36815 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2BVR7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 12:59:35 -0500
Received: by bkcjm19 with SMTP id jm19so334446bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2012 09:59:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328834790.5067.2.camel@dcbw.foobar.com>
References: <1328837032-26137-1-git-send-email-stas.yakovlev@gmail.com>
	<CAGRGNgWVsGt08gxoyaoG7sG7NgubF+qqjk=LaCruRJiUe1fuig@mail.gmail.com>
	<1328834790.5067.2.camel@dcbw.foobar.com>
Date: Wed, 22 Feb 2012 20:59:34 +0300
Message-ID: <CA++WF2M99q70fj5KrH3HaFGL59ZSmjRHL5vgoDVoyp9zVuizXQ@mail.gmail.com> (sfid-20120222_185939_328094_C9BA9642)
Subject: Re: [PATCH] ipw2x00: remove ipw2100_rates_11b[]
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Julian Calaby <julian.calaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 February 2012 03:46, Dan Williams <dcbw@redhat.com> wrote:
> On Fri, 2012-02-10 at 11:26 +1100, Julian Calaby wrote:
>> Hi Stanislav,
>>
>> On Fri, Feb 10, 2012 at 12:23, Stanislav Yakovlev
>> <stas.yakovlev@gmail.com> wrote:
>> > It's just a duplicate of ipw2100_bg_rates[].
>>
>> Looks sensible to me.
>
> Except that the 2100 is a B-only device; it doesn't do G at all.  So
> wouldn't it make sense to get rid of ipw2100_rates_bg[] instead?

It looks like we all agree that one of them should be removed. I did
not see an easy way to remove ipw2100_rates_bg[]. Maybe it makes more
sense to rename it to ipw2100_rates_b[]?

Stanislav


> Dan
>
>> Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
>>
>> > Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
>> > ---
>> >  drivers/net/wireless/ipw2x00/ipw2100.c |   11 ++---------
>> >  1 files changed, 2 insertions(+), 9 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
>> > index a0e5c21..63567fb 100644
>> > --- a/drivers/net/wireless/ipw2x00/ipw2100.c
>> > +++ b/drivers/net/wireless/ipw2x00/ipw2100.c
>> > @@ -309,13 +309,6 @@ static const long ipw2100_frequencies[] = {
>> >
>> >  #define FREQ_COUNT     ARRAY_SIZE(ipw2100_frequencies)
>> >
>> > -static const long ipw2100_rates_11b[] = {
>> > -       1000000,
>> > -       2000000,
>> > -       5500000,
>> > -       11000000
>> > -};
>> > -
>> >  static struct ieee80211_rate ipw2100_bg_rates[] = {
>> >        { .bitrate = 10 },
>> >        { .bitrate = 20, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
>> > @@ -323,7 +316,7 @@ static struct ieee80211_rate ipw2100_bg_rates[] = {
>> >        { .bitrate = 110, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
>> >  };
>> >
>> > -#define RATE_COUNT ARRAY_SIZE(ipw2100_rates_11b)
>> > +#define RATE_COUNT ARRAY_SIZE(ipw2100_bg_rates)
>> >
>> >  /* Pre-decl until we get the code solid and then we can clean it up */
>> >  static void ipw2100_tx_send_commands(struct ipw2100_priv *priv);
>> > @@ -6896,7 +6889,7 @@ static int ipw2100_wx_get_range(struct net_device *dev,
>> >        range->num_bitrates = RATE_COUNT;
>> >
>> >        for (i = 0; i < RATE_COUNT && i < IW_MAX_BITRATES; i++) {
>> > -               range->bitrate[i] = ipw2100_rates_11b[i];
>> > +               range->bitrate[i] = ipw2100_bg_rates[i].bitrate * 100 * 1000;
>> >        }
>> >
>> >        range->min_rts = MIN_RTS_THRESHOLD;
>> > --
>> > 1.7.2.5
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>
>
