Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:38604 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751363Ab2BORaQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 12:30:16 -0500
Received: by lamf4 with SMTP id f4so1318667lam.28
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 09:30:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329128888.3365.3.camel@jlt3.sipsolutions.net>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
	<1327581484-22047-8-git-send-email-victorg@ti.com>
	<4F27819A.1030200@sipsolutions.net>
	<CAK80WHZpAAG_NWcuGUK2FJ_UwOhFXraVVkugR3W5FZEHCb6Z0A@mail.gmail.com>
	<CAB=NE6WkArbBkiT6A4eEKEo6k2EJ2SsxjoNoPHp5BDWZNR3t8g@mail.gmail.com>
	<1329128888.3365.3.camel@jlt3.sipsolutions.net>
Date: Wed, 15 Feb 2012 19:01:46 +0200
Message-ID: <CAK80WHb1TgQk-yU_CrPzVgM-R-fzPK=n8A_GtZxGE3xXpYQ22w@mail.gmail.com> (sfid-20120215_183021_033207_63544DEE)
Subject: Re: [RFC 7/9] nl80211/cfg80211: add DFS feature flag
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 13, 2012 at 12:28 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-02-09 at 15:11 -0800, Luis R. Rodriguez wrote:
>> On Thu, Feb 2, 2012 at 8:08 AM, Goldenshtein, Victor <victorg@ti.com> wrote:
>> > On Tue, Jan 31, 2012 at 7:52 AM, Johannes Berg
>> > <johannes@sipsolutions.net> wrote:
>> >> On 1/26/2012 4:38 AM, Victor Goldenshtein wrote:
>> >>>
>> >>> +static int nl80211_put_feature_flags(struct wiphy *wiphy,
>> >>> +                                    struct sk_buff *msg)
>> >>> +{
>> >>> +       if (wiphy->flags&  WIPHY_FLAG_SUPPORTS_DFS)
>> >>>
>> >>> +               wiphy->features |= NL80211_FEATURE_DFS;
>> >>> +
>> >>> +
>> >>> +       NLA_PUT_U32(msg, NL80211_ATTR_FEATURE_FLAGS, wiphy->features);
>> >>> +
>> >>> +       return 0;
>> >>> +nla_put_failure:
>> >>> +       return -ENOBUFS;
>> >>> +}
>> >>
>> >>
>> >> I think you misunderstood the new feature flags -- they're supposed to be
>> >> set by the driver directly, not indirectly via wiphy->flags.
>> >>
>> >
>> > yep, I guess you're right.
>>
>> While a it, consider adding one for the requirement of sending the
>> channel switch announcement within mac80211, not the driver. In that
>> case, although a DFS feature may be available in the driver, DFS
>> should not be enabled on the driver through nl80211 unless that
>> feature gets implemented in mac80211.
>
> That, however, should be feature flag in mac80211, not cfg80211 (wiphy),
> and in fact I think it can probably be done by checking if the low-level
> function is there instead.
>
> johannes
>

Besides the NL80211_FEATURE_DFS, I'd prefer to add an additional flag
which will indicate current DFS state, as I wrote in one of my
previous emails:
Zefir Kurtisi and myself thought to rename the start_radar detection +
en_tx functions to something like dfs_start_cac() and
dfs_resume_cac(),
these two will set/reset WIPHY_FLAG_DFS_CAC_IN_PROGRESS flag, which
should add some additional protection.


-- 
Thanks,
Victor.
