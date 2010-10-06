Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9173 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab0JFXcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 19:32:50 -0400
Subject: Re: [PATCH 6/6] iwlagn: define 130 series of WiFi/BT combo devices
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <AANLkTin6wQzKn885CWxbaX2o1ERXWsu73iZVHhcuB5z1@mail.gmail.com>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1286378593-7509-7-git-send-email-wey-yi.w.guy@intel.com>
	 <AANLkTin6wQzKn885CWxbaX2o1ERXWsu73iZVHhcuB5z1@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 06 Oct 2010 16:32:02 -0700
Message-Id: <1286407922.12594.27.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

On Wed, 2010-10-06 at 16:28 -0700, Julian Calaby wrote:
> On Thu, Oct 7, 2010 at 02:23, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> > add new structures and defines need to identify 130 devices.
> >
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-6000.c |   44 +++++++++++++++++++++++++++++++
> >  drivers/net/wireless/iwlwifi/iwl-agn.c  |   10 +++++++
> >  drivers/net/wireless/iwlwifi/iwl-agn.h  |    2 +
> >  3 files changed, 56 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
> > index 5866ad8..43ec898 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-6000.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
> > @@ -75,6 +77,9 @@
> >  #define _IWL6000G2B_MODULE_FIRMWARE(api) IWL6000G2B_FW_PRE #api ".ucode"
> >  #define IWL6000G2B_MODULE_FIRMWARE(api) _IWL6000G2B_MODULE_FIRMWARE(api)
> >
> > +#define IWL130_FW_PRE "iwlwifi-130-"
> > +#define _IWL100_MODULE_FIRMWARE(api) IWL130_FW_PRE #api ".ucode"
> > +#define IWL100_MODULE_FIRMWARE(api) _IWL130_MODULE_FIRMWARE(api)
> 
> I haven't looked at the rest of the file, but is this correct: you're
> defining IWL100_MODULE_FIRMWARE using the IWL1*3*0 definitions, which
> don't seem to be defined.
> 
> (I note that these definitions aren't used, but still.....)
> 
Good catch, you are correct. I will push another patch to fix it.

Thanks
Wey


