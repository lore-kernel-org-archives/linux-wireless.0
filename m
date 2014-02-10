Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaBJIMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 03:12:10 -0500
Message-ID: <1392019923.4128.0.camel@jlt4.sipsolutions.net> (sfid-20140210_091214_188456_4572C7A4)
Subject: Re: [PATCH 2/8] iwlwifi: mvm: disable scheduled scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Mon, 10 Feb 2014 09:12:03 +0100
In-Reply-To: <52F5FC02.8050508@broadcom.com> (sfid-20140208_104235_514359_C8CEB8F3)
References: <52EFFCE8.6070505@gmail.com>
	 <1391459962-7381-2-git-send-email-egrumbach@gmail.com>
	 <52F5FC02.8050508@broadcom.com> (sfid-20140208_104235_514359_C8CEB8F3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-02-08 at 10:42 +0100, Arend van Spriel wrote:
> On 02/03/14 21:39, Emmanuel Grumbach wrote:
> > From: Johannes Berg<johannes.berg@intel.com>
> >
> > The iwlwifi scheduled scan implementation doesn't adhere to the
> > userspace API correctly - the API assumes that any new incoming
> > 'incompatible' request (like scan or remain-on-channel for this
> > driver) will just cancel the scheduled scan. Instead our driver
> > relies on userspace cancelling it, thus breaking existing wpa_s
> > versions.
> 
> I think iwlwifi is not alone in this. At least I have to put a new task 
> on my todo list ;-)

:)
You may decide to not care - newer supplicant seems to always cancel
scheduled scan first (although that should never have been required,
Broadcom's proprietary Android driver also behaves to require that.)

However, you may find that you don't just need to support the latest
upstream wpa_supplicant, so ...

johannes

