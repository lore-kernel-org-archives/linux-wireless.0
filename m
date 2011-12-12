Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37272 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab1LLLpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 06:45:15 -0500
From: Kalle Valo <kvalo@adurom.com>
To: "Guy\, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hsu\, Kenny" <kenny.hsu@intel.com>
Subject: Re: [PATCH 01/15] iwlwifi: add uCode version information support by testmode
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
	<1323390382-1678-2-git-send-email-wey-yi.w.guy@intel.com>
	<87vcpoe7bi.fsf@purkki.adurom.net>
	<1323534307.13074.192.camel@wwguy-huron>
Date: Mon, 12 Dec 2011 13:45:10 +0200
In-Reply-To: <1323534307.13074.192.camel@wwguy-huron> (Wey-Yi Guy's message of
	"Sat, 10 Dec 2011 08:25:07 -0800")
Message-ID: <87iplmdneh.fsf@purkki.adurom.net> (sfid-20111212_124519_782865_19F1D720)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Guy, Wey-Yi" <wey-yi.w.guy@intel.com> writes:

> On Sat, 2011-12-10 at 08:10 -0800, Kalle Valo wrote:
>> Wey-Yi Guy <wey-yi.w.guy@intel.com> writes:
>> 
>> > From: Hsu, Kenny <kenny.hsu@intel.com>
>> >
>> > Create new tm command to report uCode version to userspace
>> > - IWL_TM_CMD_APP2DEV_GET_FW_VERSION
>> 
>> Why not use wiphy.fw_version which is specifally meant for this purpose?
>> 
>
> fw_version is being formatted to string. we need u32

If the u32 format is so important (and I suspect it isn't, most likely
you have string format for your version numbers as well) you can always
format the u32 to hex, for example "0xdeadbeef".

Sure, it's ugly but still less ugly than having a private interface in
the driver. The idea of nl80211 testmode is NOT to replicate wext
private interface.

-- 
Kalle Valo
