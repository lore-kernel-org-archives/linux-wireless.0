Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:62222 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbaFWSXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 14:23:38 -0400
Received: by mail-pd0-f172.google.com with SMTP id w10so5994740pde.3
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 11:23:38 -0700 (PDT)
Date: Mon, 23 Jun 2014 11:23:33 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/5] cfg80211: treat the special "unknown" alpha2 as valid
Message-ID: <20140623182333.GB1390@garbanzo.do-not-panic.com> (sfid-20140623_202358_797921_02F2E1C4)
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-3-git-send-email-arik@wizery.com>
 <CAB=NE6UZPcgAAJ6GAnjy2nSdYhLRqxo4h1ZZoZ7vYsAbYBiw+Q@mail.gmail.com>
 <CA+XVXfc=zDyie-3xO86k98zKQUZqDm0dEf9d5qMDAX83svfR_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXfc=zDyie-3xO86k98zKQUZqDm0dEf9d5qMDAX83svfR_Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 23, 2014 at 08:12:18PM +0300, Arik Nemtsov wrote:
> On Thu, Jun 19, 2014 at 1:08 AM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
> >> If the regulatory request contains the special "99" unknown-country code,
> >> allow a different alpha2 as response.
> >>
> >> This special alpha2 is used when the real alpha2 is unknown and should
> >> be provided by the driver via its get_regd() wiphy callback, as part of
> >> the regdomain info.
> >>
> >> Change-Id: I286e3aed828cabf22292b6fe320fdcfa61f0b951
> >> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> >> Reviewed-on: https://gerrit.rds.intel.com/32266
> >> Tested-by: IWL Jenkins
> >> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> >> ---
> >>  net/wireless/reg.c | 6 ++++--
> >>  1 file changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> >> index e2f33d7..c429ec5 100644
> >> --- a/net/wireless/reg.c
> >> +++ b/net/wireless/reg.c
> >> @@ -418,7 +418,8 @@ static bool is_user_regdom_saved(void)
> >>                 return false;
> >>
> >>         /* This would indicate a mistake on the design */
> >> -       if (WARN(!is_world_regdom(user_alpha2) && !is_an_alpha2(user_alpha2),
> >> +       if (WARN(!is_world_regdom(user_alpha2) && !is_an_alpha2(user_alpha2) &&
> >> +                !is_unknown_alpha2(user_alpha2),
> >>                  "Unexpected user alpha2: %c%c\n",
> >>                  user_alpha2[0], user_alpha2[1]))
> >>                 return false;
> >
> > When would the user alpha2 be a custom value? This is *very* different
> > than allowing an API to set the regulatory domain to a specific alpha2
> > value, which is what I though this was all about.
> 
> Well there's a default country burned in the FW/NVRAM. In order to get
> this country I send the "99" country code to FW, and it replies with
> the correct country code. Since we need the regulatory settings
> anyway, I didn't want to invent some new API to just get the current
> country code and then request settings for it.
> We could go down that route but IMHO that would complicate things
> needlessly.. Perhaps you have a different suggestion?

I see, OK the regulatory code is already complex as it is, and I think
we need to be careful avoid being loose on the API and specially be careful
so things are not used in ways they are not documented.

Getting a information from drivers as to what country is already
programmed in is definitely useful information and the regulatory_hint()
API was designed for this purpose. It seems we want to evolve this API
to handle different sources, in this case the firmware.

If I understand the goal correctly you want to let the driver tell
cfg80211 of the alpha2 but instead of having cfg08211 query CRDA /
wireless-regdb / internal-db you want to let the driver excercise the
ability to first query the firmware for the regulatory domain data
structure, the firmware then has the right to ignore the request and
then perhaps allow cfg0211 to proceed to query CRDA / wireless-regdb. If
I understand this correctly then I think a capability flag can be pegged
onto a wiphy to describe this modification on behavior for
regulatory_hint(), that is to query firmware first for regulatory data.
You can do this by extending the struct regulatory_request with the
fact that the driver request type is a bit different just as we have
modifieres for user_reg_hint_type, you'd want a driver_reg_hint_type,
we could also then use this to inform userspace of the type of driver
hint passed if sucessful. We already have code to queue the request
and then you'd just have to extend the processing code and have
a special case there to handle calling back to the driver when needed.

By centralizing the request we could end up using the driver's own
regulatory domain on all registered wiphys that can lack regulatory
information, drivers that issue the same regulatory_hint() alpha2 on
the same wdev might want to -EALREADY as the source would be the same.

Depending on the return value, as you already programmed, cfg80211 could
follow on to do something (document clearly the return value and their
consequences would be important), either apply the returned struct or
follow on to call wireless-regdb / internel-db, or bail or whatever.

  Luis
