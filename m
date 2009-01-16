Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:37670 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764239AbZAPWNC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 17:13:02 -0500
Received: by gxk14 with SMTP id 14so1740148gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 14:13:01 -0800 (PST)
Message-ID: <43e72e890901161413n3fdd7031lfdd0a363941b697d@mail.gmail.com> (sfid-20090116_231309_523730_F28F1671)
Date: Fri, 16 Jan 2009 14:13:01 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 03/13] cfg80211: add wiphy_apply_custom_regulatory()
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090116163646.GG29609@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232097659.3854.20.camel@johannes> <20090116163646.GG29609@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 8:36 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Fri, Jan 16, 2009 at 01:20:59AM -0800, Johannes Berg wrote:
>> On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
>>
>> >  /**
>> >   * enum reg_set_by - Indicates who is trying to set the regulatory domain
>> > + * @REGDOM_SET_BY_PROBE: regulatory domain applied came prior to wiphy
>> > + *         registration by the driver itself using some custom regulatory
>> > + *         information.
>>
>> This is unnecessary, I think.
>
> I'll make note of it below.
>
>> > +/**
>> > + * freq_reg_info - get regulatory information for the given frequency
>> > + * @wiphy: the wiphy for which we want to process this rule for
>> > + * @center_freq: Frequency in KHz for which we want regulatory information for
>> > + * @bandwidth: the bandwidth requirement you have in KHz, if you do not have one
>> > + *         you can set this to 0. If this frequency is allowed we then set
>> > + *         this value to the maximum allowed bandwidth.
>> > + * @reg_rule: the regulatory rule which we have for this frequency
>> > + *
>> > + * Use this function to get the regulatory rule for a specific frequency on
>> > + * a given wireless device. If the device has a specific regulatory domain
>> > + * it wants to follow we respect that unless a country IE has been received
>> > + * and processed already.
>> > + *
>> > + * Returns 0 if it was able to find a valid regulatory rule which does
>> > + * apply to the given center_freq otherwise it returns non-zero. It will
>> > + * also return -ERANGE if we determine the given center_freq does not even have
>> > + * a regulatory rule for a frequency range in the center_freq's band. See
>> > + * freq_in_rule_band() for our current definition of a band -- this is purely
>> > + * subjective and right now its 802.11 specific.
>> > + */
>> > +static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
>> > +                    const struct ieee80211_reg_rule **reg_rule)
>> > +{
>> > +   return freq_reg_info_regd(wiphy, center_freq,
>> > +           bandwidth, reg_rule, NULL);
>> > +}
>>
>> Are you not using this or am I just not seeing the user?
>
> Yeah -- good catch, its just cruft left over from my previous work.

Actually  freq_reg_info_regd() is used by handle_channel_custom(),
hence my comment on re-inventing the wheel. But yeah it used.

  Luis
