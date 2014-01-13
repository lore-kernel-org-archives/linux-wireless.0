Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35651 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaAMLOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 06:14:41 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq4so2867437wib.5
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 03:14:40 -0800 (PST)
Date: Mon, 13 Jan 2014 12:13:57 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 08/36] iwlwifi: mvm: Change power management dependency
 on multi MAC
Message-ID: <20140113111357.GA4611@magnum.frso.rivierawaves.com> (sfid-20140113_121449_236445_F3D5E265)
References: <52B0B72A.5070704@gmail.com>
 <1387313079-28123-8-git-send-email-egrumbach@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1387313079-28123-8-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 17, 2013 at 10:44:11PM +0200, Emmanuel Grumbach wrote:
> From: Alexander Bondar <alexander.bondar@intel.com>
> 
> FW still does not support power management on multiple MAC interfaces.
> Currently the driver enforce this limitation by disabling PM if second
> interface is added. Change this behavior to allow PM on a single interface
> even if other interfaces exist but not bound to any specific PHY.
> PM will be enabled if only one single interface is bound.
> 
> Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Hi,

This broke monitor mode:
(unsetting .power_update_binding does not hang)

modprobe iwlmvm
iw dev wlan0 set type monitor
iw dev wlan0 set freq 5180 40 5190  # hangs

Can you reproduce it easily or do you need me to post further dbg info ?

 
Karl
