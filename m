Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5511 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab1LLUrg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 15:47:36 -0500
Subject: Re: [PATCH 01/15] iwlwifi: add uCode version information support
 by testmode
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hsu, Kenny" <kenny.hsu@intel.com>
In-Reply-To: <87iplmdneh.fsf@purkki.adurom.net>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1323390382-1678-2-git-send-email-wey-yi.w.guy@intel.com>
	 <87vcpoe7bi.fsf@purkki.adurom.net>	<1323534307.13074.192.camel@wwguy-huron>
	 <87iplmdneh.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 11:48:25 -0800
Message-ID: <1323719305.13074.199.camel@wwguy-huron> (sfid-20111212_214740_012231_30411ACB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-12 at 03:45 -0800, Kalle Valo wrote:
> "Guy, Wey-Yi" <wey-yi.w.guy@intel.com> writes:
> 
> > On Sat, 2011-12-10 at 08:10 -0800, Kalle Valo wrote:
> >> Wey-Yi Guy <wey-yi.w.guy@intel.com> writes:
> >> 
> >> > From: Hsu, Kenny <kenny.hsu@intel.com>
> >> >
> >> > Create new tm command to report uCode version to userspace
> >> > - IWL_TM_CMD_APP2DEV_GET_FW_VERSION
> >> 
> >> Why not use wiphy.fw_version which is specifally meant for this purpose?
> >> 
> >
> > fw_version is being formatted to string. we need u32
> 
> If the u32 format is so important (and I suspect it isn't, most likely
> you have string format for your version numbers as well) you can always
> format the u32 to hex, for example "0xdeadbeef".
> 
> Sure, it's ugly but still less ugly than having a private interface in
> the driver. The idea of nl80211 testmode is NOT to replicate wext
> private interface.
> 
it is ugly :-)
We are not try to replicate wext private interface, but just try to
support the need for our existing debugging applications.

Doing so will mean change the existing OS agnostic applications to
understand "string" format. 

Thanks
Wey


