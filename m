Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28518 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab0LGTqZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 14:46:25 -0500
Subject: Re: [PATCH 2/3] iwlagn: implement layout-agnostic EEPROM reading
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <20101207192806.GF2700@tuxdriver.com>
References: <1291743428-19642-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1291743428-19642-3-git-send-email-wey-yi.w.guy@intel.com>
	 <20101207192806.GF2700@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 07 Dec 2010 11:45:18 -0800
Message-Id: <1291751118.20668.8.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Tue, 2010-12-07 at 11:28 -0800, John W. Linville wrote:
> On Tue, Dec 07, 2010 at 09:37:07AM -0800, Wey-Yi Guy wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > The current EEPROM reading code has some layout
> > assumptions that now turned out to be false with
> > some newer versions of the EEPROM. Luckily, we
> > can avoid all such assumptions by using data in
> > the EEPROM itself, so implement using that.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> Is rewriting the EEPROM code really necessary for 2.6.37?  This seems
> like a lot of code to potentially get wrong...
> 

I agree it is a lot of changes. It is necessary for 6005 and 6030
devices. I understand the Hardware is not out yet; but both devices is
already supported by .37; without this changes, the regulatory will have
issues.

Yes, you are correct, this changes will also impact the older devices
(6000, 6050, 1000). 

So it is really judgment call, we plan to release both 6005 and 6030
uCode in the next few weeks and hardware should be on the market early
next year. If by the time when hardware become available, distro already
move to .38, then I am ok with it. What you think?

Thanks

Wey

