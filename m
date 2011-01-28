Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22725 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab1A1XV4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 18:21:56 -0500
Subject: Re: [PATCH 7/8] iwlagn: remove
 CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110128164136.GF2452@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
	 <1296229671-3041-7-git-send-email-sgruszka@redhat.com>
	 <1296231817.7388.18.camel@wwguy-ubuntu>  <20110128164136.GF2452@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 15:20:21 -0800
Message-ID: <1296256821.8832.1.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, 2011-01-28 at 08:41 -0800, Stanislaw Gruszka wrote:
> On Fri, Jan 28, 2011 at 08:23:37AM -0800, wwguy wrote:
> > > -#ifdef CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
> > >  		priv->fw_index = UCODE_EXPERIMENTAL_INDEX;
> > >  		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
> > >  	} else if (priv->fw_index == UCODE_EXPERIMENTAL_INDEX) {
> > > -#endif
> > >  		priv->fw_index = priv->cfg->ucode_api_max;
> > >  		sprintf(tag, "%d", priv->fw_index);
> > >  	} else {
> > 
> > The whole reason has it in Kconfig file is to have user not remove the
> > experimental uCode from /lib/firmware and not use it.
> 
> What is easiest and less time consuming:
> 
> this:
> 
> $ mv /lib/firmware/iwlwifi-5000-exp.ucode /lib/firmware/iwlwifi-5000-exp.ucode.not_use
> 
> or this:
> 
> $ make menuconfig
> navigate to find option and edit it 
> $ make modules
> $ make modules_install
> 
> ?
> 
> > Also put it in Kconfig file, so it is easy for user to see they are
> > using experimental option. Agree?
> 
> Not really. I believe someone who download a tarball, unpack it and copy
> files to /lib/firmware is pretty much aware what he/she is doing.
> 
Agree whoever download the tarball know what he/she is doing, but I am
not fully agree the driver always use experimental uCode if it is in the
firmware directory

Wey


