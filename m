Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:32933 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbbJPQiJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 12:38:09 -0400
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
	Jan Kaisrlik <kaisrja1@fel.cvut.cz>,
	wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, bernd.lehmann@volkswagen.de,
	jan-niklas.meier@volkswagen.de, s.sander@nordsys.de
Subject: Re: [RFC PATCH 1/2] cfg80211: Add support for ITS-G5 band (5.9 GHz)
In-Reply-To: <1444997197.2370.22.camel@sipsolutions.net>
References: <1444994885-21825-1-git-send-email-kaisrja1@fel.cvut.cz> <1444997197.2370.22.camel@sipsolutions.net>
Date: Fri, 16 Oct 2015 18:38:04 +0200
Message-ID: <87h9lqeplf.fsf@steelpick.2x.cz> (sfid-20151016_183813_236927_25793D6A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

(I added wireless-regdb@lists.infradead.org to recipients, the original
mail is at http://marc.info/?l=linux-wireless&m=144499490005262)

On Fri, Oct 16 2015, Johannes Berg wrote:
> On Fri, 2015-10-16 at 13:28 +0200, Jan Kaisrlik wrote:
>> The patch adds support for Intelligent Transportation System (ITS-G5)
>> band as defined by ETSI EN 302 663 standard. This band is enabled by
>> a new configuration option CFG80211_REG_ITSG5_BAND, which depends on
>> CFG80211_CERTIFICATION_ONUS.
>
> That Kconfig option seems unnecessary - after all, the regulatory
> database still has a say in this?

I thought that the regdb is for unlicensed bands with unrestricted use.
The 5.9 GHz band is not licensed but it is restricted for ITS
applications. In http://marc.info/?l=linux-wireless&m=140183393707445&w=2
Luis Rodriguez suggested that having a Kconfig option may be the way to
go, but we may misread what he was saying.

I assume that if this band will be in regdb, it will be too easy to use
this band (e.g. by mistake) for non-ITS applications.

> Even the NL80211_RRF_ITSG5 flag seems somewhat unnecessary - if the
> regulatory database did in fact provide information on these channels,
> then we can assume they're usable, no?
>
> IOW - I don't really see the point of this patch - can't we treat these
> channels just like regular ones, and rely on the regulatory information
> to prevent their use in all but special scenarios (where the integrator
> is providing a proper database)?

Our goal is to make it easier for people to experiment with ITS in
controlled environment (e.g. in a university lab). So you suggest that
this should be enabled by providing custom regdb rather than recompiling
the kernel with CFG80211_CERTIFICATION_ONUS?

-Michal
