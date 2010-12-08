Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35656 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab0LHXeS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 18:34:18 -0500
Subject: Re: [PATCH 2/3] iwlagn: implement layout-agnostic EEPROM reading
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <20101208201926.GF2423@tuxdriver.com>
References: <1291743428-19642-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1291743428-19642-3-git-send-email-wey-yi.w.guy@intel.com>
	 <20101207192806.GF2700@tuxdriver.com>
	 <1291751118.20668.8.camel@wwguy-ubuntu>
	 <20101208201926.GF2423@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 08 Dec 2010 15:33:11 -0800
Message-Id: <1291851191.10280.174.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Wed, 2010-12-08 at 12:19 -0800, John W. Linville wrote:
> On Tue, Dec 07, 2010 at 11:45:18AM -0800, Guy, Wey-Yi wrote:
> > Hi John,
> > 
> > On Tue, 2010-12-07 at 11:28 -0800, John W. Linville wrote:
> > > On Tue, Dec 07, 2010 at 09:37:07AM -0800, Wey-Yi Guy wrote:
> > > > From: Johannes Berg <johannes.berg@intel.com>
> > > > 
> > > > The current EEPROM reading code has some layout
> > > > assumptions that now turned out to be false with
> > > > some newer versions of the EEPROM. Luckily, we
> > > > can avoid all such assumptions by using data in
> > > > the EEPROM itself, so implement using that.
> > > > 
> > > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > > > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > > 
> > > Is rewriting the EEPROM code really necessary for 2.6.37?  This seems
> > > like a lot of code to potentially get wrong...
> > > 
> > 
> > I agree it is a lot of changes. It is necessary for 6005 and 6030
> > devices. I understand the Hardware is not out yet; but both devices is
> > already supported by .37; without this changes, the regulatory will have
> > issues.
> > 
> > Yes, you are correct, this changes will also impact the older devices
> > (6000, 6050, 1000). 
> > 
> > So it is really judgment call, we plan to release both 6005 and 6030
> > uCode in the next few weeks and hardware should be on the market early
> > next year. If by the time when hardware become available, distro already
> > move to .38, then I am ok with it. What you think?
> 
> What about a patch to disable those devices in 2.6.37, and leave the
> existing EEPROM code alone for that release?
> 

I don't think it is an option to disable all the new devices for .37
since we commit to support them in .37 kernel, 

How about re-work the patch to keep the orig. EEPROM reading method for
older devices, but using new EEPROM method for the newer devices
(6005/6030/...). it that work for .37 kernel?

Regards
Wey

