Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37813 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbbKZPqi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 10:46:38 -0500
Message-ID: <1448552793.2167.17.camel@sipsolutions.net> (sfid-20151126_164642_014598_BB38AD09)
Subject: Re: [PATCH] iwlwifi: mvm: add hwmon device for the temperature
 sensor
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	Luca Coelho <luca@coelho.fi>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kaufman, Liad" <liad.kaufman@intel.com>
Date: Thu, 26 Nov 2015 16:46:33 +0100
In-Reply-To: <877flbuke9.fsf_-_@nemi.mork.no> (sfid-20151121_221302_792132_2ABC435B)
References: <541F23D2.90600@gmail.com>
	 <1411327338-23099-13-git-send-email-egrumbach@gmail.com>
	 <87ppeoc4s0.fsf@nemi.mork.no>
	 <0BA3FCBA62E2DC44AF3030971E174FB31B5261F1@hasmsx107.ger.corp.intel.com>
	 <87d2amd24t.fsf@nemi.mork.no>
	 <0BA3FCBA62E2DC44AF3030971E174FB31B526977@hasmsx107.ger.corp.intel.com>
	 <1411760678.18773.5.camel@dubbel>
	 <A66968BA-6B95-4437-8A95-5EBFD6BCF583@mork.no>
	 <877flbuke9.fsf_-_@nemi.mork.no> (sfid-20151121_221302_792132_2ABC435B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bjørn,

> I got bored and made an attempt on this. Still just for fun.  I don't
> have a real usecase.  What do you think?  Completely useless?

It's not so bad :)

However, it's (soon going to be) redundant, we're planning to implement
a thermal_zone_device in this code, and if you then set the Kconfig
option THERMAL_HWMON you'll get a hwmon to go along with it. So I'd
rather not take this patch since we'd otherwise end up with two ways to
do the same thing in the driver.

johannes
