Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59104 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192Ab2ATTUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 14:20:08 -0500
Received: by qcsf13 with SMTP id f13so486627qcs.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2012 11:20:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+yqC4Y-nKrX=jaGbPTk7LqsR+3jqPJssOEFuw0dPm+sMyMvGg@mail.gmail.com>
References: <20120119182033.5F60358073@lefflers.sfo.corp.google.com>
 <1327069053.9857.3.camel@jlt3.sipsolutions.net> <CA+yqC4Y-nKrX=jaGbPTk7LqsR+3jqPJssOEFuw0dPm+sMyMvGg@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 20 Jan 2012 20:19:46 +0100
Message-ID: <CA+XFjipV2wPDhr3S2R5VeLAgJm-kbsm9aUkZNNFMRbBYDRczsw@mail.gmail.com> (sfid-20120120_202013_806505_71367B04)
Subject: Re: [PATCH RESEND] mac80211: support fixed rate packet injection
To: Sam Leffler <sleffler@chromium.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 20, 2012 at 7:44 PM, Sam Leffler <sleffler@chromium.org> wrote:
> On Fri, Jan 20, 2012 at 6:17 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>>
>> On Thu, 2012-01-12 at 09:53 -0800, Sam Leffler wrote:
>>
>> > +     if (fixed_rate != -1) {
>> > +             struct ieee80211_channel *chan = local->hw.conf.channel;
>> > +             struct ieee80211_supported_band *sband =
>> > +                     local->hw.wiphy->bands[chan->band];
>> > +             struct ieee80211_tx_rate *rates = info->control.rates;
>> > +             int i;
>> > +
>> > +             if (fixed_rate_flags & IEEE80211_TX_RC_MCS) {
>> > +                     WARN_ON(!sband->ht_cap.ht_supported);
>> > +                     rates[0].idx = fixed_rate;
>>
>> Unless I missed something, this would be *trivial* to trigger by
>> injection -- doesn't seem like a good idea to me.
>>
>
> Can unprivileged users inject packets?  Is your preference to generate
> an error or just suppress the warning?
>
> -Sam

Yes, only the creation of monitor interfaces is restricted to root.
Once an interface is set up, anyone can inject.
