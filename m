Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57156 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbYFMMfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 08:35:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH 1/3] iwlwifi: adding channels to sysfs
Date: Fri, 13 Jun 2008 14:34:45 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>
References: <1213343095-8133-1-git-send-email-yi.zhu@intel.com> <1213346113.3860.3.camel@johannes.berg> <1ba2fa240806130511i1686bee6m8701614a11a46aa6@mail.gmail.com>
In-Reply-To: <1ba2fa240806130511i1686bee6m8701614a11a46aa6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806131434.46148.mb@bu3sch.de> (sfid-20080613_143524_296898_73D9B62B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 13 June 2008 14:11:36 Tomas Winkler wrote:
> On Fri, Jun 13, 2008 at 11:35 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> >>  drivers/net/wireless/iwlwifi/iwl4965-base.c |   58 ++++++++++++++++++++++++++-
> >> >>  1 files changed, 56 insertions(+), 2 deletions(-)
> >> >>
> >> >> diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> >> >> index 81a1c22..c179b21 100644
> >> >> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> >> >> +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> >> >> @@ -4122,8 +4122,62 @@ static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR, show_power_level,
> >> >>  static ssize_t show_channels(struct device *d,
> >> >>                            struct device_attribute *attr, char *buf)
> >> >>  {
> >> >> -     /* all this shit doesn't belong into sysfs anyway */
> >> >> -     return 0;
> >> >
> >> > Hehe. Do you really have to? You can query this information with
> >> > nl80211. I don't know why you need all that sysfs stuff anyway.
> >>
> >> I'm not sure why Yi has cut off the log message but original was
> >>
> >> 'This patch returns channel list to sysfs. This is requirement
> >> for validation purposes'
> >>
> >> Our automation is build around sysfs and wext and I'm not going to
> >> rewrite it now.
> >
> > If you managed to get along without this for so long, why is it needed
> > in upstream now?
> 
> We didn't run without it, We  were developing HW 5000 on older kernel
> now I just merging it upstream. See my announcement  Try to imagine
> that there is world on totally different planet with different
> gravitation constant,
> 
> > Remember, sysfs is API. You don't get to change it gratuitously, so
> > neither should you add to it gratuitously. And we already _have_ API for
> > this particular thing which is not dependent on a particular
> > hardware/driver to boot!
> Agree. We've just returned what was there before
> I think you understand what legacy means after your try to replace
> wext. It will take time
> till we switch to new API. Unfortunately cannot fix everything in one day.


IMO a compromise could be to put this API under a default-off kconfig option
with a big fat warning that the API is supposed to be deleted and replaced
by cfg80211 soon. So this would only be temporary API for special purposes
that nobody should actually use. But if somebody needs to, he can do so and
has no loss of functionality for the time until the correct API is established.

-- 
Greetings Michael.
