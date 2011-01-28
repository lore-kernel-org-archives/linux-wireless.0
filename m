Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab1A1Qlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:41:46 -0500
Date: Fri, 28 Jan 2011 17:41:36 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/8] iwlagn: remove
 CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
Message-ID: <20110128164136.GF2452@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
 <1296229671-3041-7-git-send-email-sgruszka@redhat.com>
 <1296231817.7388.18.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296231817.7388.18.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 28, 2011 at 08:23:37AM -0800, wwguy wrote:
> > -#ifdef CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
> >  		priv->fw_index = UCODE_EXPERIMENTAL_INDEX;
> >  		strcpy(tag, UCODE_EXPERIMENTAL_TAG);
> >  	} else if (priv->fw_index == UCODE_EXPERIMENTAL_INDEX) {
> > -#endif
> >  		priv->fw_index = priv->cfg->ucode_api_max;
> >  		sprintf(tag, "%d", priv->fw_index);
> >  	} else {
> 
> The whole reason has it in Kconfig file is to have user not remove the
> experimental uCode from /lib/firmware and not use it.

What is easiest and less time consuming:

this:

$ mv /lib/firmware/iwlwifi-5000-exp.ucode /lib/firmware/iwlwifi-5000-exp.ucode.not_use

or this:

$ make menuconfig
navigate to find option and edit it 
$ make modules
$ make modules_install

?

> Also put it in Kconfig file, so it is easy for user to see they are
> using experimental option. Agree?

Not really. I believe someone who download a tarball, unpack it and copy
files to /lib/firmware is pretty much aware what he/she is doing.

Stanislaw
